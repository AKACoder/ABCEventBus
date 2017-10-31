# ABCEventBus
一个简单的iOS版数据总线工具。  

### [english README](https://github.com/AKACoder/ABCEventBus/blob/master/README.md)

### 关于'ABC'
- '**ABC**' 是 '**available but chaos**' 的缩写，用以说明我的水平不是很好。  

### 关键属性 (只是关键，未必优秀)  
- 基于'名字'的异步事件总线  
- 提供 **announcement** ([说明](https://github.com/AKACoder/ABCEventBus/new/master#什么是-announcement公告))  
- 使用callback方式实现  
- 所有的接收回调都会在 background queue 中执行  

### 再次提醒
>**所有的接收回调都会在 background queue 中执行**

### 什么是 'announcement'（公告）?
>1. 一个 'announcement' 在其被撤回之前，会一直有效。
>也就是说，当一个新的接受者注册的时候，他会收到所有，他注册之前发布的，未被撤回的公告。
>  
>2. 'announcement' 可以被撤回.

### 依赖  
**[duemunk/Async](https://github.com/duemunk/Async)**  
如果你在使用
Grand Central Dispatch 
([GCD](https://developer.apple.com/library/prerelease/ios/documentation/Performance/Reference/GCD_libdispatch_Ref/index.html))
强烈建议你尝试一下Async！

### 安装  
cocoapods:    
>pod 'ABCEventBus'
  
或者直接吧SourceCode下的源码拖到工程里 

### 使用  
**ABCEventBus** 提供了一组类方法，所以像下面这样使用就好:
```swift
ABCEventBus.Post(...)
```

**接收者必须遵守 ABCMessageReceiver 协议**  
```swift
protocol ABCMessageReceiver: class {
    func Receive(_ message: ABCMessage)
}
```



### 类方法列表

##### 注册注销接收者  
```swift
//注册一个事件接收者
RegisterEventReceiver(_ receiver: ABCMessageReceiver, for name: String)

//注册一个公告接收者
RegisterAnnouncementReceiver(_ receiver: ABCMessageReceiver, for name: String)

//注销一个事件接收者
DeregisterEvent(from name: String, for receiver: ABCMessageReceiver)

//注销一个公告接收者
DeregisterAnnouncement(from name: String, for receiver: ABCMessageReceiver)

```


##### 事件、公告的发布  
```swift
//发送一个事件
Post(for name: String, data: Any?)

//发布一个公告
Publish(for name: String, data: Any?) -> ABCAnnouncement

//取消一个公告
Cancel(announcement: ABCAnnouncement, from name: String)

//取消所有公告
CancelAllAnnouncement(from name: String)
 
```

### 例子?
**ABCEventBus** 非常简单，所有你想要要知道的东西，都在源码里。

### License
MIT
