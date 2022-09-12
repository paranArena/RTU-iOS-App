//
//  PasswordResetView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/13.
//

import SwiftUI
import HidableTabView

struct PasswordResetView: View {
    
    @StateObject var pwVM = PasswordViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            SecureField("비밀번호", text: $pwVM.input.password)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .padding(.leading)
            Divider()
                .padding(.horizontal)
            SecureField("비밀번호 확인", text: $pwVM.input.passwordCheck)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .padding(.leading)
            
        }
        .alert(pwVM.oneButtonAlert.title, isPresented: $pwVM.oneButtonAlert.isPresented) {
            OneButtonAlert.okButton
        } message: {
            Text(pwVM.oneButtonAlert.message)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray_F1F2F3))
        .padding(.horizontal, 20)
        .basicNavigationTitle(title: "비밀번호 변경")
        .onAppear {
            UITabBar.hideTabBar()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    pwVM.checkCondition()
                } label: {
                    Text("완료")
                }

            }
        }
        .avoidSafeArea()
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}
