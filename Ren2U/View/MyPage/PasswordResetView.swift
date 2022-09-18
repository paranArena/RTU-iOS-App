//
//  PasswordResetView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/13.
//

import SwiftUI
import HidableTabView

struct PasswordResetView: View {
    
    @StateObject var pwVM: PasswordViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            Button {
                pwVM.requestEmailCode(email: pwVM.input.email)
            } label: {
                Text("코드 전송")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray_F1F2F3))
                    .padding(.horizontal, 20)
            }
            .isHidden(hidden: pwVM.isCodeRequested)

            
            VStack(spacing: 5) {
                TextField("인증코드", text: $pwVM.input.code)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                    .padding(.leading)
                
                Divider() 
                
                SecureField("비밀번호", text: $pwVM.input.password)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                    .padding(.leading)
                
                Divider()
                
                SecureField("비밀번호 확인", text: $pwVM.input.passwordCheck)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                    .padding(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray_F1F2F3))
            .padding(.horizontal, 20)
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
        .basicNavigationTitle(title: "비밀번호 변경")
        .onAppear {
            UITabBar.hideTabBar()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task { await pwVM.passwordResetWithVerificationCode() }
                } label: {
                    Text("완료")
                }

            }
        }
        .avoidSafeArea()
    }
}

//struct PasswordResetView_Previews: PreviewProvider {
//    static var previews: some View {
//        PasswordResetView()
//    }
//}
