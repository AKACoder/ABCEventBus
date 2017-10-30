//
//  ABCEvent.swift
//  shortvoice
//
//  Created by AKACoder on 2017/10/27.
//  Copyright © 2017年 AKACoder. All rights reserved.
//

import Foundation

public class ABCMessage {
    public var Name: String
    public var Data: Any?
    
    public init(name: String, data: Any?) {
        Name = name
        Data = data
    }
}

public class ABCAnnouncement: ABCMessage {}

public protocol ABCMessageReceiver: class {
    func Receive(_ message: ABCMessage)
}


