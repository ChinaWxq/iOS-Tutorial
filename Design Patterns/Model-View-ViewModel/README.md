## MVVM

MMVM：Model、View、ViewModel。与MVC相比，多了一个ViewModel少了一个Controller。VM的意义在于数据。
Model负责对数据进行存和取，然后我们对数据除了存取，还需要**解析**操作。

### MVVM的诞生

> 举个例子：网络请求获取字典，字典作为原始数据放在Model中，Controller需要使用字典某可以key对应的一个数组，然后来用于UITableView的显示。

```swift
@objc func refreshAction(_ sender: UIRefreshControl) {
    self.model.data.removeAll()
    AF.request("https://api.seniverse.com/v3/weather/now.json?key=SJSVidYf39dI84d0s&location=shanghai&language=zh-Hans&unit=c").responseJSON { (response) in
        if let value = response.value {
            let json = JSON(value)
            if let result = json.dictionary?["results"]?[0] {
                if let dict = result.dictionary {
                    for key in dict.keys {
                        if let value = dict[key]?.dictionaryObject {
                            for key in value.keys {
                                let title = key;
                                let value = value[key];
                                let model = Model(title: title, detailTitle: value as! String)
                                self.model.data.append(model)
                                self.tableView.reloadData() // 刷新UI
                            }
                        }
                    }
                }
            }
        }
    }
    sender.endRefreshing()
}
```

<p align="center">
<img src="../resources/MVC.gif">
</p>

我们往往把数据解析的工作放在了Controller中，在之前分析的MVC如何分配工作一样，需要数据有了M，需要界面有了V，需要有一个地方同步M和V于是有了C，我们忽略了M的进一步处理数据解析的过程。

> 在MVC出生的年代，手机APP的数据往往都比较简单，没有现在那么复杂，所以那时的数据解析很可能一步就解决了，所以既然有这样一个问题要处理，而面向对象的思想就是用类和对象来解决问题，显然V和M早就被定义死了，它们都不应该处理“解析数据”的问题，理所应当的，“解析数据”这个问题就交给C来完成了。

而现在App功能越来越复杂，数据结构越来越复杂，解析数据就没那么简单，如果继续按照MVC的设计模式，将数据解析工作放在Controller里面，Controller就显得极为臃肿。然后Controller期初设计的目的并不是处理数据。

Controller的工作：
- self.view用来作为所有视图的容器
- 管理自己的生命周期
- 处理Controller之间的跳转
- 实现Controller容器

而数据解析的任务并不应该由Controller来实现，M、V、C都不应处理数据，那么由谁来负责呢？开发者为数据解析新创建一个类ViewModel。这就是MVVM的诞生。

### 如何实现MVVM

现在我们开始着手实现MVVM之前，我先简单提一下之前遗留的一个问题：为什么MVVM这个名字里面，没有Controller的出现（为什么不叫MVCVM，C去哪了）。
你只需要记住两点：

1、Controller的存在感被完全的降低了；

2、VM的出现就是Controller存在感降低的原因。

在MVVM中，Controller不再像MVC那样直接持有Model了。

想象Controller是一个Boss，数据是一堆文件（Model），如果现在是MVC，那么数据解析（比如整理文件）需要由Boss亲自完成，然而实际上Boss需要的仅仅是整理好的文件而不是那一堆乱七八糟的整理前的文件。

所以Boss招聘了一个秘书，现在Boss就不再需要管理原始数据（整理之前的文件）了，他只需要去找秘书：你帮我把文件整理好后给我。

那么这个秘书就首先去拿到文件（原始数据），然后进行整理（数据解析），接下来把整理的结果给Boss。

所以秘书就是VM了，并且Controller（Boss）现在只需要直接持有VM而不需要再持有M了。

如果再进一步理解C、VM、M之间的关系：因为Controller只需要数据解析的结果而不关心过程，所以就相当于VM把“如何解析Model”给封装起来了，C甚至根本就不需要知道M的存在就能把工作做好。

那么我们MVVM中的持有关系就是：C持有VM，VM持有M。

所以在实现MVVM中一种必要的思想就是：

一旦在实现Controller的过程中遇到任何跟Model（或者数据）相关的问题，就找VM要答案。