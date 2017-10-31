# ABCEventBus
An simple post/receive eventbus.  

### 中文 [README](https://github.com/AKACoder/ABCEventBus/blob/master/README_zh.md)

### about README and  'ABC'
- My english is not good enough, so i use google translate to complete this README.  
- '**ABC**' is for '**available but chaos**'.  

### key features (doesn't mean it's good)  
- Async and name based post/receive  
- Provide **announcement** ([explain](https://github.com/AKACoder/ABCEventBus/blob/master/README.md#what-is-announcement))  
- Implemented by the callback  
- All receivers will be executed in the background queue  

### warning again
>**All receive callbacks will be executed in the background queue**

### what is 'announcement'?
>1. It will be effective until it is canceled.
>This is means when the new receiver register, 
>it will receive all 'announcement' that have not been canceled .
>  
>2. 'announcement' can be canceled.

### dependency  
**[duemunk/Async](https://github.com/duemunk/Async) is awesome!**  

### install  
for cocoapods:    
>pod 'ABCEventBus'
  
or add the file to your project directly 

### usage  
**ABCEventBus** provides a set of class method, so use it just like this:
```swift
ABCEventBus.Post(...)
```

**receiver must conform ABCMessageReceiver protocol**  
```swift
protocol ABCMessageReceiver: class {
    func Receive(_ message: ABCMessage)
}
```



### class method

##### for register & deregister  
```swift
//register an event receiver
RegisterEventReceiver(_ receiver: ABCMessageReceiver, for name: String)

//register an announcement receiver
RegisterAnnouncementReceiver(_ receiver: ABCMessageReceiver, for name: String)

//deregister event
DeregisterEvent(from name: String, for receiver: ABCMessageReceiver)

//deregister announcement
DeregisterAnnouncement(from name: String, for receiver: ABCMessageReceiver)

```


##### for post/publish(announcement)  
```swift
//post an event
Post(for name: String, data: Any?)

//publish an annountment
Publish(for name: String, data: Any?) -> ABCAnnouncement

//cancel announcement
Cancel(announcement: ABCAnnouncement, from name: String)

//cancel all announcement
CancelAllAnnouncement(from name: String)
 
```

### example?
There is no examples because **ABCEventBus** is very simple. 
Everything you want to know is in the code.

### License
The source is made available under the MIT license.


