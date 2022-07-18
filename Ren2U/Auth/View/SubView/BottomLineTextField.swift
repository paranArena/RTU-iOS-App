//
//  TextEditorBottomLine .swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/13.
//

import SwiftUI


enum OverlayLocation: String, CaseIterable {
    case leading
    case trailing
    case none 
}

struct BottomLineTextfield: View {
    
    let placeholder: String
    let placeholderLocation: OverlayLocation
    @Binding var isConfirmed : Bool
    @Binding var text: String
    
    
    var body: some View {
        TextField("", text: $text)
            .overlay(
                VStack {
                    Spacer()
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(isConfirmed ? .Navy_1E2F97 : .Gray_ADB5BD)
                }
            )
            .overlay(
                HStack {
                    if placeholderLocation == .trailing {
                        Spacer()
                    }
                    Text(placeholder)
                        .font(.system(size: 14))
                        .foregroundColor(.Gray_ADB5BD)
                    if placeholderLocation == .leading {
                        Spacer()
                    }
                }
            )
    }
}

struct TextEditorBottomLine__Previews: PreviewProvider {
    static var previews: some View {
        BottomLineTextfield( placeholder: "보기", placeholderLocation: .trailing, isConfirmed: .constant(false), text: .constant("Text"))
    }
}
