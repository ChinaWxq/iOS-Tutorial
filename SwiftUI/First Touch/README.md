## First Touch

以下是打开新建`SwiftUI`项目的默认代码。

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

`ContentView`遵循`View`协议，`View`协议要求一个名为`body`类型为`some View`的计算属性。你可能会疑问`some`关键字的作用？

### Opaque Types

`some`关键字在`Swift 5.1版本`中被引入，定义为一个**不透明类型**。不透明类型是一种而无需提供具体类型的返回类型。限制调用者需要了解的有关返回类型的信息，仅仅公开有关其协议遵从性的信息。

**使用不透明类型是一种让编译器根据返回值来决定函数返回的具体类型发方法。**

在SwiftUI中，`some View`意味着`body`始终实现`View`协议，但调用者无需知道具体的实现类型。

在Swift文档中对不透明类型的解释：

>  You can think of an opaque type like being the reverse of a generic type.
…
An opaque type lets the function implementation pick the type for the value it returns in a way that’s abstracted away from the code that calls the function.
你可以认为不透明类型就像是通用类型的逆向。
不透明类型可以使函数实现从调用函数的代码中抽象出来的方式为返回的值选择类型。

换句话说，标准的通用占位符由调用者填充。 调用泛型函数时，您会将泛型类型限制为传递给该函数的类型。 您可以将不透明类型视为一种泛型函数，其中，占位符类型由实现返回类型填充。


以下代码不包含一个合法的不透明类型，两个代码分支返回不同的具体类型，第一个选择分支返回Text View，第二个分支返回VStack View。
```swift
struct ContentView: View {
    var x: Bool = false
    
    var body: some View {
        if x {
            return Text("This is true")
        } else {
            return VStack { Text("This is false") }
        }
    }
}
```
返回类型在编译时并不能被知道，所以是一个非法的不透明类型。

### SwiftUI与MVVM

**MVVM原则**
在 MVVM 架构中 View 和 Model 不能直接通信，必须通过 ViewModel。ViewModel 是 MVVM 的核心，它通常要实现一个观察者，当 Model 数据发生变化时 ViewModel 能够监听并通知到对应的 View 做 UI 更新，反之当用户操作 View 时 ViewModel 也能获取到 UI 的变化并通知 Model 数据做出对应的更新操作。这就是 MVVM 中数据的双向绑定。
SwiftUI+Combine框架原生就是MVVM架构，很容易支持数据的双向绑定。

![](/resources/SwiftUI_MVVM.png)