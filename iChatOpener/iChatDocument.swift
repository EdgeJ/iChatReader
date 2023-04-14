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

struct iChatDocument: FileDocument {
    // var text: String
    var messages: [InstantMessage]

    init(text: String = "Hello, world!") {
        // self.text = text
        let im = InstantMessage()
        let sender = Presentity()
        sender.accountName = "me"
        im.sender = sender
        im.message = NSAttributedString(string: "Hello, world!")
        self.messages = [im]
    }

    static var readableContentTypes: [UTType] { [.ichat, .binaryPropertyList,] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        messages = []
        let ims = IChatDecoder(data: data)
        for im in ims {
            // Fallthrough to system user if no other user is found
            if let _ = im.sender {
                // pass
            } else {
                let sender = Presentity()
                sender.accountName = "System"
                im.sender = sender
            }
            messages.append(im)
        }
    }
    
    // We don't really edit any ichat files, but .fileWrapper needs to be here to
    // conform to the FileDocument protocol.
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = configuration.existingFile!.regularFileContents
        return .init(regularFileWithContents: data!)
    }
}
