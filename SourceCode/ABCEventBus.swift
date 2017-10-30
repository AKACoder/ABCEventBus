//
//  ABCEventBus.swift
//  shortvoice
//
//  Created by AKACoder on 2017/10/27.
//  Copyright © 2017年 AKACoder. All rights reserved.
//

import Foundation
import Async

class ABCBasicEventBus {
    var ReceiverMap = [String: [ABCMessageReceiver]]()
    var ReceiverMapLock = NSObject()
    
    @discardableResult
    func Register(receiver: ABCMessageReceiver, for name: String) -> Bool {
        if let _ = ReceiverMap[name] {} else {
            ReceiverMap[name] = [ABCMessageReceiver]()
        }
        
        var newReceiver = false
        objc_sync_enter(ReceiverMapLock)
        if(!ReceiverMap[name]!.contains(where: { (prev) -> Bool in
            return prev === receiver
        })) {
            newReceiver = true
            ReceiverMap[name]?.append(receiver)
        }
        objc_sync_exit(ReceiverMapLock)
        
        return newReceiver
    }
    
    func Deregister(from name: String, for receiver: ABCMessageReceiver) {
        guard var _ = ReceiverMap[name] else {
            return
        }
        
        objc_sync_enter(ReceiverMapLock)
        for (idx,prev) in ReceiverMap[name]!.enumerated() {
            if(prev === receiver) {
                ReceiverMap[name]?.remove(at: idx)
                break
            }
        }
        objc_sync_exit(ReceiverMapLock)
        
    }
    
    func Post(for name: String, data: Any?) {
        guard let receiverList = ReceiverMap[name] else {
            return
        }
        
        objc_sync_enter(ReceiverMapLock)
        for receiver in receiverList {
            Async.background {
                receiver.Receive(ABCMessage(name: name, data: data))
            }
        }
        objc_sync_exit(ReceiverMapLock)
    }
}

class ABCAnnouncementBus: ABCBasicEventBus {
    var AnnouncementMap = [String: [ABCAnnouncement]]()
    var AnnouncementMapLock = NSObject()
    
    @discardableResult
    override func Register(receiver: ABCMessageReceiver, for name: String) -> Bool {
        objc_sync_enter(AnnouncementMapLock)
        let isNewReceiver = super.Register(receiver: receiver, for: name)
        
        if(isNewReceiver) {
            PickAnnouncementWhenRegister(from: name, for: receiver)
        }
        objc_sync_exit(AnnouncementMapLock)

        return isNewReceiver
    }
    
    func Publish(for name: String, data: Any?) -> ABCAnnouncement {
        let announcement = ABCAnnouncement(name: name, data: data)
        if let _ = AnnouncementMap[name] {} else {
            AnnouncementMap[name] = [ABCAnnouncement]()
        }
        
        objc_sync_enter(AnnouncementMapLock)
        AnnouncementMap[name]?.append(announcement)
        objc_sync_exit(AnnouncementMapLock)
        
        guard let receiverList = ReceiverMap[name] else {
            return announcement
        }
        
        objc_sync_enter(ReceiverMapLock)
        for receiver in receiverList {
            Async.background {
                receiver.Receive(announcement)
            }
        }
        objc_sync_exit(ReceiverMapLock)
        
        return announcement
    }
    
    func Cancel(announcement: ABCAnnouncement, from name: String) {
        guard let _ = AnnouncementMap[name] else {
            return
        }
        objc_sync_enter(AnnouncementMapLock)
        for (idx,prev) in AnnouncementMap[name]!.enumerated() {
            if(prev === announcement) {
                AnnouncementMap[name]?.remove(at: idx)
                break
            }
        }
        objc_sync_exit(AnnouncementMapLock)
    }
    
    func CancelAllAnnouncement(from name: String) {
        guard let _ = AnnouncementMap[name] else {
            return
        }
        objc_sync_enter(AnnouncementMapLock)
        AnnouncementMap[name]?.removeAll()
        objc_sync_exit(AnnouncementMapLock)
    }
    
    func PickAnnouncementWhenRegister(from name: String, for receiver: ABCMessageReceiver) {
        guard let announcementList = AnnouncementMap[name] else {
            return
        }
        
        for announcement in announcementList {
            Async.background {
                receiver.Receive(announcement)
            }
        }
    }
}


open class ABCEventBus {
    static var EventBus = ABCBasicEventBus()
    static var AnnouncementBus = ABCAnnouncementBus()
    
    open class func RegisterEventReceiver(_ receiver: ABCMessageReceiver, for name: String) {
        ABCEventBus.EventBus.Register(receiver: receiver, for: name)
    }
    
    open class func RegisterAnnouncementReceiver(_ receiver: ABCMessageReceiver, for name: String) {
        ABCEventBus.AnnouncementBus.Register(receiver: receiver, for: name)
    }
    
    open class func Post(for name: String, data: Any?) {
        ABCEventBus.EventBus.Post(for: name, data: data)
    }
    
    open class func Publish(for name: String, data: Any?) -> ABCAnnouncement {
        return ABCEventBus.AnnouncementBus.Publish(for: name, data: data)
    }
    
    open class func Cancel(announcement: ABCAnnouncement, from name: String) {
        ABCEventBus.AnnouncementBus.Cancel(announcement: announcement, from: name)
    }
    
    open class func CancelAllAnnouncement(from name: String) {
        ABCEventBus.AnnouncementBus.CancelAllAnnouncement(from: name)
    }
    
    open class func DeregisterEvent(from name: String, for receiver: ABCMessageReceiver) {
        ABCEventBus.EventBus.Deregister(from: name, for: receiver)
    }
    
    open class func DeregisterAnnouncement(from name: String, for receiver: ABCMessageReceiver) {
        ABCEventBus.AnnouncementBus.Deregister(from: name, for: receiver)
    }
}















