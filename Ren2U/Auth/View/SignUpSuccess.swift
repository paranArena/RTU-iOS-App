//
//  SignUpSuccess.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/26.
//

import SwiftUI

struct SignUpSuccess: View {
    
    @Binding var isActive: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 160) {
            SuccessText()
            GoLoginViewButton()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text("이메일 인증")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
            }
        }
    }
    
    @ViewBuilder
    private func SuccessText() -> some View {
        VStack(alignment: .center, spacing: 30) {
            Text("회원가입이 완료되었습니다!")
                .font(.custom(CustomFont.RobotoBold.rawValue, size: 22))
            
            Text("로그인 후 Ren2U에서\n다양한 가치를 누려보세요!")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 18))
                .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder
    private func GoLoginViewButton() -> some View {
        Button {
            self.isActive = false
        } label: {
            Image(systemName: "arrow.right.circle.fill")
                .resizable()
                .frame(width: 86, height: 86)
                .foregroundColor(Color.Navy_1E2F97)
        }
    }
}

struct SignUpSuccess_Previews: PreviewProvider {
    static var previews: some View {
        SignUpSuccess(isActive: .constant(true))
    }
}
