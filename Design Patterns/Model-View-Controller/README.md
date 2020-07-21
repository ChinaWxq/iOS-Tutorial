# MVC
## MVC

<p align="center">
<img src="/resources/MVC.jpeg">
</p>

说起MVC，必须拿斯坦福大学公开课上的这幅图来说明，这可以说是最经典和最规范的MVC标准。

用UML图表示
![](/resources/MVC_Diagram.png)

- **Models** 持有数据，他们通常为struct或者class。
- **Views** 展示视觉元素和控制屏幕，他们通常为`UIView`的子类。
- **Controllers** 调节models和views，他们通常为`UIViewController`的子类。

controllers允许强引用models和views，所以controllers能够直接访问。相反models和views不应该强引用持有他们的controller，否则会造成**循环引用**。models通过属性观察与controller通信，views通过IBAction与controller通信。

> MVC在iOS中的实现思路： 一句话描述就是Controller负责将Model的数据用View渲染展示。

### MVC如何产生

APP的实质就是界面与数据的交互。

- 需要类负责界面的渲染展示，于是有了View。
- 需要类负责管理数据，于是有了Model。
- 我们设计的View应该能显示任意的内容，比如UILabel显示的文字应该是任意的而不只是某个特定Model的内容，**所以我们不应该在View的实现中去写和Model相关的任何代码（任何代码指的是：修改Model的逻辑不应该在View里实现，使用Model的数据渲染视图是允许的）**，如果这样做了那么View的可扩展性就相当低了。
- 同样Model只负责处理数据，不处理界面的交互，**所以Model中不应该写任何View相关代码（同样指的是：Model中不应该实现View的交互逻辑）**。
- **数据和界面应该同步**，也就是一定要有个地方要把Model的数据赋值给View，而Model内部和View的内部都不可能去写这样的代码，所以只能新创造一个类出来了，取名为Controller。


### MVC是如何工作的

上图把MVC分为三个独立的区域，并且中间用了一些线来隔开，C和V以及C和M之间的白线，一部分是虚线一部分是实线，这就表明了引用关系：**C可以直接引用V和M，而V和M不能直接引用C，而V和M之间则是双黄线，它们俩谁也不能引用谁，你既不能在M里面写V，也不能在V里面写M。**

#### 1.View与ViewController的交互


视图层最常见的事件就是按钮点击事件，实际上处理这个事件的应该是Controller，所以View把这个事件传递给了Controller。如何传递的呢，从图可以看到View上面的action，代表是事件，Controller上面的target，就是靶子，View究竟要把事件传递给谁？它被规定了传递给靶子，Controller实际上就是靶子，**View只负责传递事件，不负责关心靶子是谁。这是V和C的一种交互方式，也是Target-Action（目标-动作对设计模式。）**
旁边还画出了V对C的另一种传值方式：协议-委托。委托有两种：代理和数据源。什么是代理？就是专门处理should、will、did事件的委托。什么是数据源？就是专门处理data、count等等的委托。

总结一下，就是主要通过三种方式：
- action-target用来负责传递特定的事件。
- dataSource-protocol用来通过回调的形式动态通过数据绘制界面。
- delegate-protocol提前约定了对一些事件的处理规则，当被规定的事件发生后，就按照协议的规定来进行处理。协议委托可以通过协议方法的参数由V向C传值。比如cell点击事件的协议方法，tableView通过indexPath参数告诉C是哪个cell被点击了。

#### 2.Model与ViewController的交互

Model是数据管理者，数据可以是本地的、也可能是服务器的。拿一个简单的需求作为例子，例如我想在一个UILabel中显示一段文字，文字是网络请求获得的。

使用MVC设计模式：C中需要一个V（UIButton）作为属性显示这段文字，文字从M中获取，获取的地方在哪里呢？通常在C的生命周期里面，往往是viewDidLoad方法中调用M获取数据的方法来获取数据。M获取的数据是异步网络请求获得的，网络请求结束后，C才应该用M的数据赋值给V，那么现在如何知道网络请求结束了？
OC中有一种机制来解决这个问题“一个对象想要关系另一个对象的属性是否放生变化”的问题，**KVO**。



**KVO全称为Key Value Observing，键值监听机制，由NSKeyValueObserving协议提供支持，NSObject类继承了该协议，所以NSObject的子类都可使用该方法。让一个对象去观察另一个对象的某个键值路径所代表的属性，一旦发生了变化，那么系统会调用观察者的方法`observingValueKeyForPath:`。** 如果想在C中M的data属性发生改变之后刷新界面，那么就只需要向M添加观察者C，观察路径为@"data"。对C来讲，一旦M的data属性发生了变化，那么C的observingValueKeyForPath方法就会被调用，在方法中实现数据的传递，达到M和V同步的效果。


