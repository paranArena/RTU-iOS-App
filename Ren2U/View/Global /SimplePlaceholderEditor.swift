//
//  SimplePlaceholder.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import SwiftUI

struct SimplePlaceholderEditor: View {
    
    let placeholder: String
    @Binding var text: String
    @FocusState var foucsState: Bool?
    
    
    var body: some View {
        TextEditor(text: $text)
            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
            .focused($foucsState, equals: true)
            .background(.clear)
            .opacity(text.isEmpty ? 0.1 : 1)
            .background(alignment: .topLeading) {
                TextEditor(text: .constant(placeholder))
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                    .foregroundColor(.gray_ADB5BD)
                    .isHidden(hidden: !text.isEmpty)
            }
    }
}
//
//struct SimplePlaceholder_Previews: PreviewProvider {
//    static var previews: some View {
//        SimplePlaceholder()
//    }
//}
