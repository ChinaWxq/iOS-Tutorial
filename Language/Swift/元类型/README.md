## .Type和.self是什么？有什么区别？

 .Type 和 .self 都和元类型相关，**元类型**在Swift中非常有用，你肯定在多种场合中使用过它，例如在表格注册`tableView.register(CustomerCell.self, forCellReuseIdentifier:"CustomerCell")`或者JSON解析` try decoder.decode(Infomation.self, from: json)`，但你可能并不了解它的真正含义。

## 什么是元类型？

元类型被定义为 type of type 类型的类型，听起来很奇怪？类型的类型是什么意思？通过例子来了解元类型。

```swift
struct Player {
    static let name = "Ryan"
    func play(_ game: String) { }
}

let player: Player = Player()
```

你可以看到 player 是一个对象， Player 是一个类型。 Player() 是一个实例, :Player 是实例的类型。你可以通过 player 调用 play 方法，但是你不能通过实例对象来访问 name 私有属性。

那么我们如何能访问私有属性呢？最简单的方式是 `Player.name` ，直接返回一个 String ，有没有其他方式呢？我们可以调用 type(of: player).name 拿到私有属性。

 type(of) 将对象转化为可以访问所有类属性的对象，我们来看看仅用 type(of) 会发生什么？

```swift
let something = type(of: player) //Player.Type
```
我们得到`Player.Type`，意味着是`Player`的类型，也就是`Player`的元类型。

```swift
let name = something.name
let instance: Player = name.init()
```
我可以通过元类型访问类的所有属性和方法。当你想要仅基于对象类型来完成初始化对象，访问对象所有属性和方法的操作时，元类型非常有用，在泛型中用途很广。以下是一个工厂模式的例子。

```swift
func create<T: BlogPost>(blogType: T.Type) -> T {
    switch blogType {
    case is TutorialBlogPost.Type:
        return blogType.init(subject: currentSubject)
    case is ArticleBlogPost.Type:
        return blogType.init(subject: getLatestFeatures().random())
    case is TipBlogPost.Type:
        return blogType.init(subject: getKnowledge().random())
    default:
        fatalError("Unknown blog kind!")
    }
}
```

现在我们可以讨论 Int.Type 和 Int.self 的关系：

|属性|值|
| - | - |
| Int | 5 |
| Int.Type | Int.self |

 Int.Type 是 Int 元类型的类型名，类似与 Int 是 Int 类型名。
 Int.self 是 Int 元类型的类型值，类型与 5 是 Int 类型的一个值。

在调用函数时传入值，在编写函数参数类型时我们填入类型名。

```swift
func method(_ num: Int) {}

func method1(_ type: Int.Type) {}

method(5)

method(Int.self) // 不能使用 Int.Type
```
仔细思考🤔这段代码，体会 Int Int.self Int.Type 5 之间的联系。

所以我们在为tableview注册的时候不能使用
`tableView.register(UITableViewCell.Type, forCellReuseIdentifier: "cell")`而是使用
`tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")`。

## type(of:)动态元类型 vs .self静态元类型

 type(of) 返回一个对象的元类型，动态。

 .self 返回一个类型的元类型，静态。

```swift
let myNum: Any = 1 // Compile time type of myNum is Any, but the runtime type if Int.
type(of: myNum) // Int.Type
```
在编译时myNum的类型是 Any，但在运行时类型type检测 myNum 是 Int 。

## 总结

在 Swift 中能够表示 “任意” 这个概念的除了 Any 和 AnyObject 以外，还有一个 AnyClass。AnyClass 在 Swift 中被一个 typealias 所定义：
```swift
typealias AnyClass = AnyObject.Type
```
通过 AnyObject.Type 这种方式所得到是一个元类型 (Meta)。在声明时我们总是在类型的名称后面加上 .Type，比如 A.Type 代表的是 A 这个类型的类型。也就是说，我们可以声明一个元类型来存储 A 这个类型本身，而在从 A 中取出其类型时，我们需要使用到 .self。

> 其实在 Swift 中，.self 可以用在类型后面取得类型本身，也可以用在某个实例后面取得这个实例本身。前一种方法可以用来获得一个表示该类型的值，这在某些时候会很有用；而后者因为拿到的实例本身，所以暂时似乎没有太多需要这么使用的案例。




### 参考资料
[What's .self, .Type and .Protocol? Understanding Swift Metatypes](https://swiftrocks.com/whats-type-and-self-swift-metatypes.html)
[ANYCLASS，元类型和 .SELF](https://swifter.tips/self-anyclass/)