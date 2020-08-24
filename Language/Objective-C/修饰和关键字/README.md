## __unused

定义某个变量而不使用，用`__unused`修饰，不使用的变量会有警告。

```objc
__unused NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(print) userInfo:nil repeats:YES];
```