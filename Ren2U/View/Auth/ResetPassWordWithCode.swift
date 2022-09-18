//
//  ResetPassWordWithCode.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/13.
//

import SwiftUI
import Alamofire

struct ResetPassWordWithCode: View {
    
    @StateObject var pwVM = PasswordViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Group {
                TextField("email", text: $pwVM.input.email)
                
                Button {
                    pwVM.requestEmailCode(email: pwVM.input.email)
                } label: {
                    Text("인증번호 보내기")
                }
            }
            .isHidden(hidden: pwVM.isCodeRequested)
            
            Group {
                TextField("인증코드", text: $pwVM.input.code)
                SecureField("새 비밀번호", text: $pwVM.input.password)
                SecureField("비밀번호 확인", text: $pwVM.input.passwordCheck)
                
                Button {
                    Task { await pwVM.passwordResetWithVerificationCode() } 
                } label: {
                    Text("완료")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                }

            }
            .isHidden(hidden: !pwVM.isCodeRequested)
        }
        .alert(pwVM.dismissAlert.title, isPresented: $pwVM.dismissAlert.isPresented) {
            Button("확인") { dismiss() }
        } message: {
            pwVM.dismissAlert.message
        }
        .alert(pwVM.oneButtonAlert.title, isPresented: $pwVM.oneButtonAlert.isPresented) {
            OneButtonAlert.noActionButton
        } message: {
            pwVM.oneButtonAlert.message
        }
        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
        .animation(.easeInOut, value: pwVM.isCodeRequested)
        .basicNavigationTitle(title: "비밀번호 찾기")
    }
}

struct ResetPassWordWithCode_Previews: PreviewProvider {
    static var previews: some View {
        ResetPassWordWithCode()
    }
}
