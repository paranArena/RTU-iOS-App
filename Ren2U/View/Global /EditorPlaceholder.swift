//
//  SimplePlaceholder.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import SwiftUI
import Introspect

struct EditorPlaceholder: View {
    
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextEditor(text: $text)
            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
            .background(alignment: .topLeading) {
                TextEditor(text: text.isEmpty ? .constant(placeholder) : .constant(""))
                    .foregroundColor(.gray_ADB5BD)
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
            }
            .introspectTextView { uiTextView in
                uiTextView.backgroundColor = .clear
            }
    }
        
}
//
//struct SimplePlaceholder_Previews: PreviewProvider {
//    static var previews: some View {
//        SimplePlaceholder()
//    }
//}
