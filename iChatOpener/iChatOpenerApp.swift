//
//  iChatOpenerApp.swift
//  iChatOpener
//
//  Created by John Edge on 4/7/23.
//

import SwiftUI

@main
struct iChatOpenerApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: iChatOpenerDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
