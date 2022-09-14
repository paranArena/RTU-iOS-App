//
//  CustomSecurePlaceholder.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/12.
//

import SwiftUI

struct CapsuleSecurePlaceholder: View {
    
    @Binding var text: String
    let placeholder: Text
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .padding()
                    .foregroundColor(.gray_ADB5BD)
            }
            
            SecureField("", text: $text)
                .padding()
        }
        .overlay(
            Capsule()
                .stroke(Color.gray_ADB5BD, lineWidth: 1)
        )
    }
}

//struct CustomSecurePlaceholder_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomSecurePlaceholder(text: "", placeholder: .contrast("Password"))
//    }
//}
