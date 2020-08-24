## 回调

定义：可执行代码与一个特定的事件绑定，当事件发生时执行代码。在Objc中有四种回调方法：Target-Action，Delegate&DataSource，NSNotification，Blocks。

### 目标动作对(Target-Action)
在开发中使用最多就是UIControl中的`addTarget`方法。
```objc
// UIControl.h
- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
```
当事件发生时向指定对象发送指定消息。对象是`target`，消息是`action`。

### 辅助对象(Delegate&DataSource)

我们经常使用UITableView，需要使用到UITableViewDelegate和UITableViewDataSource。
```objc
self.tableView.delegate = self;
self.tableView.dataSource = self;
```
我们将VC设为tableview的代理对象和数据源对象，是tableView的辅助对象。当tableView需要更新或者相应某个事件，就会向辅助对象发送相应的消息。

```objc
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
```
当我们设置为数据源对象时，必须实现`numberOfRowsInSection`和`cellForRowAtIndexPath`方法。

### 通知中心(NSNotification)

目标动作对和辅助对象适用于向一个对象发送消息，如果要向多个对象发送消息，我们需要使用通知中心来实现。



### 闭包(Blocks)

