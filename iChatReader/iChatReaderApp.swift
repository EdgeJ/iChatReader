//
//  iChatReaderApp.swift
//  iChatReader
//
//  Created by John Edge on 4/7/23.
//

import SwiftUI

@main
struct iChatReaderApp: App {
    var body: some Scene {
        DocumentGroup(viewing: iChatDocument.self) {
            ContentView(document: $0.$document)
        }
    }
}
