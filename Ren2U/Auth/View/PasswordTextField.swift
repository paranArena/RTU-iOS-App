//
//  PasswordTextField.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/14.
//

import SwiftUI

struct PasswordTextField: View {
    
    let textType: String
    @Binding var text: String
    @Binding var isShowingPassword: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(textType)
                .font(.system(size: 12))
            
            Group {
                if isShowingPassword {
                    TextField("", text: $text)
                } else {
                    SecureField("", text: $text)
                }
            }
            
            .font(.system(size: 16))
            .overlay(
                HStack {
                    Spacer()
                    Button {
                        isShowingPassword.toggle()
                    } label: {
                        Text("보기").font(.system(size: 14)).foregroundColor(.Gray_ADB5BD)
                    }
                }
            )
        }
    }
}

//struct PasswordTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        PasswordTextField()
//    }
//}
