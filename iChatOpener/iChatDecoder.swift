//
//  iChatDecoder.swift
//  iChatOpener
//
//  Created by John Edge on 4/13/23.
//

import Foundation
import AppKit

func IChatDecoder(data: Data) -> [InstantMessage] {
    NSKeyedArchiver.setClassName("InstantMessage", for: InstantMessage.self)
    NSKeyedArchiver.setClassName("Presentity", for: Presentity.self)
    NSKeyedArchiver.setClassName("NSFont", for: NSFont.self)
    NSKeyedArchiver.setClassName("NSMutableParagraphStyle", for: NSMutableParagraphStyle.self)
    NSKeyedArchiver.setClassName("NSTextAttachment", for: NSTextAttachment.self)
    NSKeyedArchiver.setClassName("NSColor", for: NSColor.self)
    
    let unarchiver = NSKeyedUnarchiver.init(forReadingWith: data as Data)
    
    let root = unarchiver.decodeObject(forKey: "$root")
    var ims: [InstantMessage] = []
    var people: NSMutableSet = []
    
    for id in root as! any Sequence {
        if let obj = id as? NSArray {
            for sub in obj {
                if let im = sub as? InstantMessage {
                    ims.append(im)
                    if let _ = im.subject {
                        people.add(im.subject.accountName!)
                    }
                    if let _ = im.sender {
                        people.add(im.sender.accountName!)
                    }
                }
            }
        }
    }
    for im in ims {
        if people.count > 2 {
            im.isMultiParty = true
        }
        // im.participantIds = people
        // im.chatId = root.lastObject
    }
    return ims
}
