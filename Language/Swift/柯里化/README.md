# 柯里化（Currying）

## Introduction

柯里化是函数式编程的概念，将多参数函数转化为单参数的函数方法。函数式编程的思想贯穿于Swift中。从简单的例子了解概念：

函数将输入的数字加1，函数表达的内容十分有限，如果我们之后还需要加2，加3的函数那么就得编写新的函数。
```swift
func addOne(num: Int) -> Int {
    return num + 1
}
```
有没有更通用的方法呢？定义一个通用的函数，它将接受需要与输入数字增加的数，并返回一个函数。返回的函数接受输入数字的本身。
```swift
func addTo(_ adder: Int) -> (Int) -> Int {
    return {
        num in
        num + adder
    }
}

let addTwo = addTo(2) 
let result = addTwo(6) // 8
```
当有了addTo函数，便可以轻松得到加2，3类的函数，实现了通用方法。

---
编写一个Int类型比较的通用函数。

```swift
func greaterThan(_ compare: Int) -> (Int) -> Bool {
    return {$0 > compare}
}

let greaterThanTen = greaterThan(10)
greaterThanTen(11) // true
greaterThanTen(9) // false
```
柯里化的好处：
1. 惰性求值。第一次调用获得函数，不会产生计算。第二个调用函数才会发生计算，起到延迟计算的效果。
2. 动态生成函数。根据需求返回函数，实现量产相似方法，避免一个模板生成重复代码。

## Example

```swift
class BankAccount {
    var blance: Double = 0.0
    func deposit(_ amount: Double) {
        blance += amount
    }
}
```
可以创建一个实例调用`deposit`方法，
```swift
let account = BankAccount()
account.deposit(100) // balance is now 100
```
我们也可以这样调用
```swift
let depositor = BankAccount.deposit(_:)
depositor(account)(100) // balance is now 200
```
这完全等于以上内容，我们将方法赋给变量。请注意`BankAccount.deposit(_:)`并没有传递参数，我们不在这里调用方法（因为不能再类型上调用实例方法），而是对其进行引用，类似于C语言的函数指针。第二部是调用函数。

Swift中实例方式只是一种类型方法，它可以作为参数并返回一个函数。

```swift
BankAccount.deposit(account)(100) // balance is now 300
```

在swift button添加点击事件时Selector使用字符串生成，面临一个非常危险的问题，难以重构无法运行时检查。但target-action是iOS开发中非常重要的设计模式。想要安全使用的话，可以利用方法的柯里化。

```swift
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        button.addTarget(self, action: Selector("clickButton"), for: .touchUpInside)
    }
    
    @objc func clickButton() {
        print(#function)
    }
}
```