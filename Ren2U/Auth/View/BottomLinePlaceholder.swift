//
//  BottomLinePlaceholder.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/13.
//

import SwiftUI

struct BottomLinePlaceholder: View {
    
    let placeholder: Text
    @Binding var text: String
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .foregroundColor(.Gray_ADB5BD)
                    .font(.system(size: 14))
            }
            
            TextField("", text: $text)
        }
        .overlay(
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(text.isEmpty ? .Gray_ADB5BD : .Navy_1E2F97)
            }
        )
    }
}

struct BottomLinePlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        BottomLinePlaceholder(placeholder: Text("placeholder"), text: .constant(""))
    }
}
