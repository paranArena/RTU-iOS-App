//
//  CustomPlaceholder.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/12.
//

import SwiftUI

struct CapsulePlaceholder: View {
    
    
    @Binding var text: String
    let placeholder: Text
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .padding()
                    .foregroundColor(.Gray_ADB5BD)
            }
            
            TextField("", text: $text)
                .padding()
        }
        .overlay(
            Capsule()
                .stroke(Color.Gray_ADB5BD, lineWidth: 1)
        )
    }
}

//struct CustomPlaceholder_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomPlaceHolder(text: "", placeholder: .contrast("Email"))
//    }
//}
