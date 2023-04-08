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

struct iChatOpenerDocument: FileDocument {
    var text: String

    init(text: String = "Hello, world!") {
        self.text = text
    }

    static var readableContentTypes: [UTType] { [.ichat, .binaryPropertyList,] }

    init(configuration: ReadConfiguration) throws {
        var string = ""
        
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        let ims = IChatDecoder(data) as! NSMutableArray
        for i in ims {
            if let im = i as? InstantMessage {
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
