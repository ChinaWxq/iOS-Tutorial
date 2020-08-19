## Runtime

### 介绍

Objective-C扩展了C语言，并加入了面向对象特性和`Smalltalk`消息机制。扩展的核心是一个用C和汇编语言写的`Runtime`库。它是Objective-C面向对象和动态机制的基石。

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

```objc
//对象
struct objc_object {
    Class isa  OBJC_ISA_AVAILABILITY;
};
//类
struct objc_class {
    Class isa  OBJC_ISA_AVAILABILITY;
#if !__OBJC2__
    Class super_class                                        OBJC2_UNAVAILABLE;
    const char *name                                         OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
    struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
    struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
#endif
} OBJC2_UNAVAILABLE;
//方法列表
struct objc_method_list {
    struct objc_method_list *obsolete                        OBJC2_UNAVAILABLE;
    int method_count                                         OBJC2_UNAVAILABLE;
#ifdef __LP64__
    int space                                                OBJC2_UNAVAILABLE;
#endif
    /* variable length structure */
    struct objc_method method_list[1]                        OBJC2_UNAVAILABLE;
}                                                            OBJC2_UNAVAILABLE;
//方法
struct objc_method {
    SEL method_name                                          OBJC2_UNAVAILABLE;
    char *method_types                                       OBJC2_UNAVAILABLE;
    IMP method_imp                                           OBJC2_UNAVAILABLE;
}
```