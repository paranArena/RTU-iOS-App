//
//  ResetPassWordWithCode.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/13.
//

import SwiftUI
import Alamofire

struct ResetPassWordWithCode: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = "" 
    @State private var isRequested = false
    
    @State private var code = ""
    @State private var passwordReset = PasswordReset()
    
    @State private var isPresented = false
    
    @State private var isPresented2 = false
    var body: some View {
        List {
            Group {
                TextField("email", text: $email)
                
                Button {
                    authVM.requestEmailCode2(email: email)
                    isRequested = true
                } label: {
                    Text("인증번호 보내기")
                }
            }
            .isHidden(hidden: isRequested)
            
            Group {
                TextField("인증코드", text: $code)
                SecureField("새 비밀번호", text: $passwordReset.password)
                SecureField("비밀번호 확인", text: $passwordReset.passwordCheck)
                
                Button {
                    if !passwordReset.checkCondition {
                        isPresented = true
                    } else {
                        Task {
                            if await authVM.passwordResetWithVerificationCode(email: email, code: code, password: passwordReset.password) {
                                dismiss()
                            } else {
                                
                            }
                        }
                    }
                } label: {
                    Text("완료")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                }

            }
            .isHidden(hidden: !isRequested)
        }
        .alert("변경 실패", isPresented: $isPresented2) {
            OneButtonAlert.okButton
        } message: {
            Text("비밀번호 변경에 실패했습니다.")
        }
        .alert("비밀번호 변경 불가능", isPresented: $isPresented) {
            OneButtonAlert.okButton
        } message: {
            Text("8~30자리 동일한 비밀번호를 입력해주세요")
        }
        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
        .animation(.easeInOut, value: isRequested)
        .basicNavigationTitle(title: "비밀번호 찾기")
    }
}

struct ResetPassWordWithCode_Previews: PreviewProvider {
    static var previews: some View {
        ResetPassWordWithCode()
    }
}
