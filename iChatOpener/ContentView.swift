//
//  ContentView.swift
//  iChatOpener
//
//  Created by John Edge on 4/7/23.
//

import SwiftUI

struct HTMLStringView: View {
    let htmlContent: String
    
    var fontName = "Helvetica"
    var fontSize: CGFloat = 12
    
    func parseHTML(html: String) -> String {
        return html
    }
    
    var body: some View {
        Text(parseHTML(html: htmlContent))
            .font(Font.custom(fontName, size: fontSize))
            .foregroundColor(.black)
            .colorInvert()
    }
}

struct ContentView: View {
    @Binding var document: iChatOpenerDocument

    var body: some View {
        List(document.messages, id: \.self){ iChatMessage in
            VStack(alignment: .leading) {
                Text(iChatMessage.sender)
                    .font(.headline)
                HTMLStringView(htmlContent: iChatMessage.message)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(iChatOpenerDocument()))
    }
}
