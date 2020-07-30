

# SwiftUI Tips

1. Spacer()会扩展以使其包含视图使用其父视图的所有空间，而不是仅由其内容定义其大小。
2. 调用 .clipShape(Circle()) ，将图像裁剪成圆形。Circle 可以当做一个蒙版的形状，也可以通过 stroke 或 fill 绘制视图。
3. List使用Identifiable数据，使用key-path标识每一个元素(\.self)或者数据遵循Identifiable协议。
4. 嵌入到NavigationView实现导航，.navigationBarTitle()设置导航栏，NavigationLink实现转场。
5. 自定义预览。调用preViewDevice系列修饰符改变预览设备机型、尺寸等。

```swift
ForEach(["iPhone SE", "iPhone XS MAX", "iPad Pro (12.9-inch) (3rd generation)"], id: \.self) {
            deviceName in
            LandmarkList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
```

6. 当@State修饰过的属性发生变化，会根据新的属性值重新绘制UI。控件与属性绑定，绑定是对可变状态的引用。使用$前缀，对一个属性或者状态变量进行绑定。
7. 若要在列表中组合静态和动态视图，或者将两个或多个不同的动态视图组合在一起，要使用 ForEach 类型，而不是将数据集合传递给 List 。
8.  ObservableObject是数据的自定义对象，SwiftUI监视可能影响到视图的可观察对象的任何修改，并在修改之后对视图做出改变。SwiftUI会订阅你的ObservableObject，当数据更改时更新需要刷新的视图。



## Apple官方教程重要Question

Q：When creating a custom SwiftUI view, where do you declare the view’s layout? 

当你创建一个自定义SwiftUI视图，在哪声明视图的布局？

A：In the `body` property.

Custom views implement the `body` property, which is a requirement of the `View` protocol.

在`body`属性，自定义视图需要实现`View`协议，在`body`属性中定义视图的内容、布局和行为。

---

Q：In addition to `List`, which of these types presents a dynamic list of views from a collection?

除了`List`之外，哪一种类型能显示集合中视图的动态列表？

A：

```
ForEach
```

Place a `ForEach` instance inside a `List` or other container type to create a dynamic list.

将`ForEach`实例放在`List`或者其他容器类型能实现动态列表。

---

Q：You can create a `List` of views from a collection of `Identifiable` elements. What approach do you use to adapt a collection of elements that don’t conform to the `Identifiable`protocol?

可以从`Identifiable`元素的集合来创建`List`，哪种方法能适合不满足`Identifiable`协议的元素集合？

A：Passing a key path along with the data to `List(_:id:)`.

Pass the key path to a uniquely identifying property for your collection’s elements as the second parameter when creating a `List`.

通过键值路径和数据一起传递给`List`构造方法，将键值路径作为集合元素的唯一标识属性，作为第二个参数传递给`List`构造方法中。

---

Q：Which of the following passes data downward in the view hierarchy?

哪一项将数据向下传递给视图层次结构？

A：The `environmentObject(_:)` modifier.

You apply this modifier so that views further down in the view hierarchy can read data objects passed down through the environment.

应用`environmentObject(_:)`修饰符，你可以在视图层次结构中更深的视图中通过环境读取传递的数据对象。

---

Q：What’s the role of a binding?

绑定的作用是什么？

A：It’s a value and a way to change that value.

A binding controls the storage for a value, so you can pass data around to different views that need to read or write it.

是一种值，也是改变值的一种方式。存储属性的绑定控制，你可以在数据传递到需要读写的不同视图中。