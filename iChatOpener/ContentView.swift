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
                Text(im.sender.accountName)
                    .font(.headline)
                Text(im.message.string)
                    .font(Font.custom("Helvetica", size: 12))
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
