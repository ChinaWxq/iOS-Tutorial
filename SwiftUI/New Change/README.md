# What's New in SwiftUI

## Say Goodbye to SceneDelegate

在WWDC20之前，使用SwiftUI创建视图，你必须将其包装在`UIHostingController`，Controller被包装在一个`UIWindow`，window在`SceneDelegate`中定义。

```swift
import UIKit
import SwiftUI

// Auto-generated code
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    ...
    
}
```

在WWDC20之后，一个新的解决方案出现：`App`。
在新建SwiftUI文件中，`Life Cycle`选项中有2个可选项：
- SwiftUI App
- UIKit App Delegate

> 生命周期是应用状态的引用，通常是沿时间线改变，"active"，"inactive"，"background"。我们在启动时展示UI界面，在退出应用时保存数据。

在之前我们使用`AppDelegate`和`SceneDelegate`来管理生命周期，这样很繁琐。如今使用`App Name App.swift`文件来代替。

<p align="center">
<img src="/resources/LifeCycle.png">
</p>

以下便是`HelloWorldApp.swift`文件的内容。

```swift
@main
struct HelloWorldApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

```
Magic！仅仅几行代码就有全新的SwiftUI App生命周期管理方式。

那么具体内容是什么意思呢？

- `@main`告诉Xcode以下的结构`HelloWorldApp`，是应用程序的入口点。仅有一个结构能被该属性标志。
- `App`是展示应用程序行为和结构的协议。`HelloWorldApp`遵循该协议，代表应用本身。
- `Scene`，SwiftUI的View的body属性必须是`View`类型，类似的SwiftUI的App的body属性必须是`Scene`类型。

### App Protocol

```swift
protocol App
```
通过声明符合App协议的结构来创建应用，实现必须的计算属性`body`来定义内容。

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```
在结构之前声明`@main`属性，来声明应用程序的入口点。该协议提供`main()`方法的默认实现，系统会调用该方法启动应用。在所有文件中只有一个明确的入口点。应用的`body`由遵循`Scence`协议组成。每个场景都包含视图层次结构的根视图，并由系统管理其生命周期。


### Scene Protocol

app的用户界面部分，生命周期由系统管理。

```swift
protocol Scene
```
你可以在app的`body`中组成一个或多个遵循`Scene`协议的实例。你可以将SwiftUI提供的原始场景（例如`WindowGroup`）与其他场景组成自定义场景一起使用。为了实现自定义场景，需要遵循`Scene`协议，实现必须的计算属性`body`并为自定义场景提供内容。
场景就像视图的容器一样，并自动为您管理，系统根据使用平台，来决定何时以及如何展示用户界面展示的视图层级结构。

---

如果需要观察可选的生命周期事件，在旧的`SceneDelegate`，就是这样：

```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    ...
    lots more code
    ...
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        print("scene is now active!")
    }
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print("scene is now inactive!")
    }
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        print("scene is now in the background!")
    }
}
```
在新的生命周期管理中，我们很容易实现：
```swift
@main
struct HelloWorldApp: App {
    @Environment(\.scenePhase) private var scenePhase
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .active:
                print("scene is now active!")
            case .inactive:
                print("scene is now inactive!")
            case .background:
                print("scene is now in the background!")
            @unknown default:
                print("Apple must have added something new!")
            }
        }
    }
}
```
我们使用了一个属性`scenePhase`，它能从系统中获取当前的活跃状态。反斜杠`\`指明我们使用了键值，意味着引用了App的属性。无论何时属性的值发生改变，`onChnage`修饰符被调用，我们可以获取生命周期的状态。