//
//  ContentView.swift
//  iChatOpener
//
//  Created by John Edge on 4/7/23.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: iChatOpenerDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(iChatOpenerDocument()))
    }
}
