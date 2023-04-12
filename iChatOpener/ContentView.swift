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
        List(document.messages, id: \.self){ im in
            VStack(alignment: .leading) {
                // Ignore parsing failures, since messageBody will default to raw html.
                let _ = try? im.parse()
                Text(im.senderName)
                    .font(.headline)
                Text(im.messageBody)
                    .font(Font.custom(im.messageFontName, size: im.messageFontSize))
                    .textSelection(.enabled)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(iChatOpenerDocument()))
    }
}
