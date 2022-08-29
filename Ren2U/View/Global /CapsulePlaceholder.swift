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
    let color: Color
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .padding()
                    .foregroundColor(color) 
            }
            
            TextField("", text: $text)
                .padding()
        }
        .overlay(
            Capsule()
                .stroke(color, lineWidth: 1)
        )
    }
}

//struct CustomPlaceholder_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomPlaceHolder(text: "", placeholder: .contrast("Email"))
//    }
//}
