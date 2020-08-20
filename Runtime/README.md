## Runtime

### 介绍

Objective-C扩展了C语言，并加入了面向对象特性和`Smalltalk`消息机制。扩展的核心是一个用C和汇编语言写的`Runtime`库。它是Objective-C面向对象和动态机制的基石。

> 动态语言：运行时确定变量数据类型的语言，变量使用之前不需要类型声明。
静态语言：编译时确定变量数据类型的语言，大多数静态语言使用变量之前必须声明变量类型。

### 消息传递

调用一个对象的方法例如：`[obj foo]`，编译器转成消息发送`obj_msgSend(obj, foo)`，`Runtime`的执行流程：

1. 首先通过obj的`isa`指针找到它的class。
2. 在class的`objc_method_list`中查找`foo`。
3. 如果没有找到，就继续在`super_class`中查找
4. 一旦找到就去执行它的实现`IMP`

一个class往往只有一部分函数会被经常调用，每次查找方法时都需要遍历一次效率低，如果把常用函数缓存下来就能提高查询效率。这也就是`objc_class`中另一个重要成员`objc_cache`做的事情 - 再找到`foo`之后，把`foo`的`method_name`作为key ，`method_imp`作为value给存起来。当再次收到`foo`消息的时候，可以直接在缓存中找到，避免去遍历`objc_method_list`。

objc_msgSend的方法定义为：
```objc
OBJC_EXPORT id _Nullable
objc_msgSend(id _Nullable self, SEL _Nonnull op, ...)
```

消息传递是如何实现的呢？

#### 类对象(objc_class)
objc类是由`Class`类型来表示的，实际是一个指向`objc_class`的结构体指针。
```objc
/// An opaque type that represents an Objective-C class.
typedef struct objc_class *Class;
```
objc/runtime.h对`objc_class`结构体的定义：

```objc
struct objc_class {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;

#if !__OBJC2__
    Class _Nullable super_class                              OBJC2_UNAVAILABLE;
    const char * _Nonnull name                               OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;
    struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;
    struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;
#endif

} OBJC2_UNAVAILABLE;
```
结构体中包含了指向父类的指针、类的名字、版本、实例大小、实例变量列表、方法列表、缓存、协议列表。结构体第一个成员变量是`isa`指针，说明`Class`本身就是一个对象，称为类对象，类对象在编译的时候产生用于创建实例对象，是单例。

#### 实例对象(objc_object)

```objc
/// Represents an instance of a class.
struct objc_object {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
};

/// A pointer to an instance of a class.
typedef struct objc_object *id;
```
实例对象就是一个`objc_object`结构体，内容是类型为`Class`的`isa`指针，指向类对象。
`id`类型就是`objc_object`结构体指针。

#### isa指针关系

![](/resources/isa.png)

- 类的实例对象isa指针指向类
- 类isa指针指向元类
- 元类superclass指向父类的元类
- 元类isa指针指向根元类
- 根元类的isa指针指向自身

> 当你给对象发送消息时，消息是在寻找这个对象的类的方法列表。
当你给类发消息时，消息是在寻找这个类的元类的方法列表。

#### 方法(objc_method)

```objc
struct objc_method {
    SEL _Nonnull method_name                                 OBJC2_UNAVAILABLE;
    char * _Nullable method_types                            OBJC2_UNAVAILABLE;
    IMP _Nonnull method_imp                                  OBJC2_UNAVAILABLE;
}                                                            OBJC2_UNAVAILABLE;
```
- SEL method_name 方法名
- char* method_types 方法类型
- IMP method_imp 方法实现

**SEL**

```objc
typedef struct objc_selector *SEL;
```
SEL：类成员方法的指针，与C的函数指针不一样，函数指针直接保存了方法的地址，而SEL只是方法的编号。
其中@selector（）是取类方法的编号，取出的结果是SEL类型。

**IMP**
```objc
typedef void (*IMP)(void /* id, SEL, ... */ ); 
```
IMP：函数指针，指向程序内存地址的指针。