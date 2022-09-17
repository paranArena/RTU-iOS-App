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
    @State private var isRequested = false
    @State private var isPresented = false
    @State private var isPresented2 = false
    
    var body: some View {
        List {
            Group {
                TextField("email", text: $pwVM.input.email)
                
                Button {
                    pwVM.requestEmailCode(email: pwVM.input.email)
                    isRequested = true
                } label: {
                    Text("인증번호 보내기")
                }
            }
            .isHidden(hidden: isRequested)
            
            Group {
                TextField("인증코드", text: $pwVM.input.code)
                SecureField("새 비밀번호", text: $pwVM.input.password)
                SecureField("비밀번호 확인", text: $pwVM.input.passwordCheck)
                
                Button {
                    if !pwVM.input.checkCondition {
                        isPresented = true
                    } else {
                        Task {
                            if await pwVM.passwordResetWithVerificationCode(email: pwVM.input.email, code: pwVM.input.code, password: pwVM.input.password) {
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
            OneButtonAlert.noActionButton
        } message: {
            Text("비밀번호 변경에 실패했습니다.")
        }
        .alert("비밀번호 변경 불가능", isPresented: $isPresented) {
            OneButtonAlert.noActionButton
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
