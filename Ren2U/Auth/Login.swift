//
//  SwiftUIView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/12.
//

import SwiftUI

struct Auth: View {
    
    @State var email = ""
    @State var password = ""
    @State var isWrong = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Welcome!")
                        .font(.system(size: 30, weight: .bold))
                    Spacer()
                }
                
                HStack {
                    Text("로그인 후 다양한 '가치'를 누려보세요!")
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                }
                
                CapsuleBorderPlaceholder(text: $email, placeholder: Text("Email"))
                    .padding(.top, 46)
                CapsuleBorderSecurePlaceholder(text: $password, placeholder: Text("Password"))
                    .padding(.top, 19)
                
                HStack {
                    
                    Text("이메일 또는 비밀번호를 잘못 입력했습니다")
                        .font(.system(size: 10))
                        .foregroundColor(isWrong ? .RedText : .white)
                    Spacer()
                }
                .padding(.leading)
                .padding(.top, 0)
                
                Button {
                    isWrong.toggle()
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 86, height: 86)
                        .padding(.top, 21)
                        .foregroundColor(!email.isEmpty && !password.isEmpty ? .NavyView : .GrayDivider)
                }
                
                HStack {
                    Text("비밀번호 찾기")
                        .font(.system(size: 16))
                        .foregroundColor(Color.GrayText)
                    
                    Text("|")
                        .foregroundColor(Color.GrayDivider)
                    
                    NavigationLink {
                        SignUp()
                    } label: {
                        Text("회원 가입")
                            .font(.system(size: 16))
                            .foregroundColor(Color.GrayText)
                    }
                }
                .padding(.top, 21)
            }
            .padding(.horizontal, 40)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Auth()
    }
}
