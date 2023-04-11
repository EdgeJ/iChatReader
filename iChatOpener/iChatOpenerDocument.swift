//
//  iChatOpenerDocument.swift
//  iChatOpener
//
//  Created by John Edge on 4/7/23.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var ichat: UTType {
        UTType(filenameExtension: "ichat")!
    }
}

struct iChatMessage: Hashable {
    let sender: String
    let message: String
    
    init(s: String, m: String) {
        sender = s
        message = m
    }
    
    static func == (lhs: iChatMessage, rhs: iChatMessage) -> Bool {
        return lhs.sender == rhs.sender && lhs.message == rhs.message
    }
}

struct iChatOpenerDocument: FileDocument {
    var text: String
    var messages: [iChatMessage]

    init(text: String = "Hello, world!") {
        self.text = text
        self.messages = [
            iChatMessage(s: "me",
                         m: "<html><body ichatballooncolor=\"#7BB5EE\" ichattextcolor=\"#000000\"><font face=\"Helvetica\" size=3 ABSZ=12>Hello, world!</font></body></html>")
        ]
    }

    static var readableContentTypes: [UTType] { [.ichat, .binaryPropertyList,] }

    init(configuration: ReadConfiguration) throws {
        var string = ""
        
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        messages = []
        let ims = IChatDecoder(data) as! NSMutableArray
        for i in ims {
            if let im = i as? InstantMessage {
                messages.append(iChatMessage(s: im.sender.accountName, m: im.message))
                string = string + im.toJSONString()
            }
        }
        text = string
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}
