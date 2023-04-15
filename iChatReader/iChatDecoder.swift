//
//  iChatDecoder.swift
//  iChatReader
//
//  Created by John Edge on 4/13/23.
//

import Foundation
import AppKit

func IChatDecoder(data: Data) -> [InstantMessage] {
    let unarchiver = NSKeyedUnarchiver.init(forReadingWith: data as Data)
    
    let root = unarchiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey)
    var ims: [InstantMessage] = []
    var people: Set<String> = []
    
    for id in root as! any Sequence {
        if let obj = id as? NSArray {
            for sub in obj {
                if let im = sub as? InstantMessage {
                    ims.append(im)
                    if let _ = im.subject {
                        people.insert(im.subject.accountName)
                    }
                    if let _ = im.sender {
                        people.insert(im.sender.accountName)
                    }
                }
            }
        }
    }
    for im in ims {
        if people.count > 2 {
            im.isMultiParty = true
        }
        im.participantIds = people
        // im.chatId = root.lastObject
    }
    return ims
}
