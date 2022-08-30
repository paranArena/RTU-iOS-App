//
//  BottomLinePlaceholder.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/13.
//

import SwiftUI

struct BottomLinePlaceholder: View {
    
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray_ADB5BD)
                    .font(.system(size: 14))
            }
            
            TextField("", text: $text)
        }
        .overlay(
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(text.isEmpty ? .gray_ADB5BD : .navy_1E2F97)
            }
        )
    }
}

struct BottomLinePlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        BottomLinePlaceholder(placeholder: "placeholder" , text: .constant(""))
    }
}
