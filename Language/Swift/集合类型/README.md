# 集合类型

## 数组和可变性

```swift
let fibs = [0, 1, 1, 2, 3, 5]
```

我们可以在数组上执行isEmpty和count常见操作，获取数组的第一个元素和最后一个元素，可以使用first或者last，如果数组是空的，两者返回nil，还可以使用通过下标的方式访问数组中的元素，获取元素前要确定下标是否在数组的范围之内，如果下标越界，你的程序就会崩溃。

```swift
var x = [1, 2, 3]
var y = x
y.append(4) // 修改y，不会影响到x
```

> 数据分为基本数据类型和对象数据类型。基本数据类型直接存储在栈中，引用数据类型存储的对象在栈中的引用，数据存在堆内存中。引用数据类型在栈中存储了指向数据的指针。浅拷贝只负责某个对象的指针，而不负责对象本身，新旧指针指向同一片内存。但深拷贝会创建一个新的相同的对象，新指针与旧指针不指向同一片内存，也就不指向同一个对象，修改新指针指向的内容不会影响到旧指针所指向的对象。

Swift中的Array是结构体，是基础数据类型，复制时进行浅拷贝。

而在NSArray上的处理不同Array，尽管是一个不可变的NSArray，但是它的**引用特性并不能保证这个数组不会被改变**。

```swift
let a = NSMutableArray(array: [1, 2, 3])
let b: NSArray = a
a.insert(4, at: 3) // 修改a影响到b

// 不影响到b的办法
let b = a.copy() as! NSArray
a.insert(4, at: 3) // b仍然是[1, 2, 3]
```

NSArray是数组对象，是引用类型数据，浅拷贝时会将对象指向同一个引用。

## 数组变形

### Map

对序列中的每一个元素进行转换操作。下面代码计算一个整数数组里的元素的平方：

```swift
let fibs = [1, 2, 3]
var squared:[Int] = []
for fib in fibs {
    squared.append(fib)
}

let squaredWithMap = fibs.map { fib in
    fib * fib
}
```

使用map的优势：简洁、清晰；square不用var声明可以使用let；square不用显示指明类型。

```swift
@inlinable public func map<T>(_ transform: (Element) throws -> T) rethrows -> [T]
    /// - Parameter transform: A mapping closure. `transform` accepts an
    ///   element of this sequence as its parameter and returns a transformed
    ///   value of the same or of a different type.
    /// - Returns: An array containing the transformed elements of this
    ///   sequence.
```

我们对map进行一种简单实现：

```swift
extension Array {
    func myMap<T>(_ transform: (Element) -> T) -> [T] {
        var result: [T] = []
        for x in self {
            result.append(transform(x))
        }
        return result
    }
}

let squaredWithMyMap = fibs.myMap{ fib in
    fib * fib
}
```

Element是数组中包含元素类型的占位符，T是元素转换之后的类型的占位符。map函数本身不关心Element和U是什么，实际类型取决于调用者。

### 使用函数将行为参数化

map可以将模板代码分离出来，模板代码不随每次调用发生改变，发生改变的transform闭包代码，根据变化函数作为参数来实现不同的函数功能。标准款中，有很多将**行为参数化**的设计模式。

### filter

Filter序列中符合条件的过滤出新建一个序列。map和filter组合使用，可以轻易完成很多数组操作。得到0到9的平方数中偶数集合。

```swift
print((0..<10).map{ $0 * $0}.filter{$0 % 2 == 0})
// [0, 4, 16, 36, 64]
extension Array {
    func myFilter(_ isIncluded: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for x in self where isIncluded(x) {
            result.append(x)
        }
        return result
    }
}
```

### reduce

reduce将元素合并成一个新值。轻松对集合所有元素求和。

```swift
let sum = (0..<10).reduce(0, {(total, num) in total + num}) // 45

extension Array {
    func myReduce<T>(_ initial: T, _ combine: (T, Element) -> T) -> T {
        var result = initial
        for x in self {
            result = combine(result, x) // combine计算方法
        }
        return result
    }
}
```

