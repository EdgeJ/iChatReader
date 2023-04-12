//
//  iChatOpenerDocument.swift
//  iChatOpener
//
//  Created by John Edge on 4/7/23.
//

import SwiftUI
import SwiftSoup
import UniformTypeIdentifiers

extension UTType {
    static var ichat: UTType {
        UTType(filenameExtension: "ichat")!
    }
}

class iChatMessage: Hashable {
    let senderName: String
    let messageRaw: String
    var messageBody: String
    var messageFontName: String
    var messageFontSize: CGFloat
    // var messageFontColor: String
    
    init(sender: String, message: String) {
        // Initialize with some default values.
        // These will typically be parsed to new values from the HTML string in the message body
        // with the _parse() method.
        senderName = sender
        messageRaw = message
        messageBody = message
        messageFontName = "Helvetica"
        messageFontSize = 12
    }
    
    func parse() throws {
        do {
            let doc: Document = try SwiftSoup.parse(messageRaw)
            let font: Element = try doc.select("font").first()!
            self.messageBody = try doc.text()
            self.messageFontName = try font.attr("face")
            if let fontSizeStr = try? font.attr("ABSZ") {
                if let fontSizeNum = NumberFormatter().number(from: fontSizeStr) {
                    self.messageFontSize = CGFloat(truncating: fontSizeNum)
                }
            }
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    
    static func == (lhs: iChatMessage, rhs: iChatMessage) -> Bool {
        return lhs.senderName == rhs.senderName && lhs.messageBody == rhs.messageBody
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(senderName)
        hasher.combine(messageBody)
    }
}

struct iChatOpenerDocument: FileDocument {
    var text: String
    var messages: [iChatMessage]

    init(text: String = "Hello, world!") {
        self.text = text
        self.messages = [
            iChatMessage(sender: "me",
                         message: "<html><body ichatballooncolor=\"#7BB5EE\" ichattextcolor=\"#000000\"><font face=\"Helvetica\" size=3 ABSZ=12>Hello, world!</font></body></html>")
        ]
    }

    static var readableContentTypes: [UTType] { [.ichat, .binaryPropertyList,] }

    init(configuration: ReadConfiguration) throws {
        var string = ""
        
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        messages = []
        let ims = IChatDecoder(data) as NSMutableArray
        for i in ims {
            if let im = i as? InstantMessage {
                messages.append(iChatMessage(sender: im.sender.accountName, message: im.message))
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
