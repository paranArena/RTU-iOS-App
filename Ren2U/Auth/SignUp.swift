//
//  SignUp.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/13.
//

import SwiftUI




struct SignUp: View {
    
    @State private var email: String = ""
    
    let password: [String] = ["Password", "Password 확인"]
    let type: [String] = ["이름", "학과", "학번"]
    @State private var passwordText: [String] = ["", ""]
    @State private var typeText: [String] = ["", "", ""]
    @State private var phoneNumber: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
    
            Text("아주대학교 이메일")
                .font(.system(size: 12))

            HStack {
                BottomLineTextfield(placeholder: "", placeholderLocation: .none, text: $email)

                Text("@ajou.ac.kr")
                    .font(.system(size: 16))

                Text("중복확인")
                    .padding(5)
                    .font(.system(size: 12))
                    .overlay(Capsule().stroke(email.isEmpty ? Color.GrayView : Color.NavyView, lineWidth: 1))
                    .foregroundColor(email.isEmpty ? .GrayView : .NavyView)
                    .padding(.leading, 19)
            }
            
            ForEach(password.indices) { index in
                Text(password[index])
                    .font(.system(size: 12))
                BottomLineTextfield(placeholder: "보기", placeholderLocation: .trailing, text: $passwordText[index])
            }
            
            ForEach(type.indices) { index in
                Text(type[index])
                    .font(.system(size: 12))
                BottomLineTextfield(placeholder: "", placeholderLocation: .trailing, text: $typeText[index])
            }
            
            Text("휴대폰 번호")
                .font(.system(size: 12))
            BottomLinePlaceholder(placeholder: Text("'-'를 제외한 숫자로 된 전화번호를 입력하세요"), text: $phoneNumber)
            
            
            HStack {
                Spacer()
                NavigationLink {
                    Certification()
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 86, height: 86)
                        .padding(.top, 49)
                        .foregroundColor(isAllEntered() ? Color.NavyView : Color.GrayView)
                }

                Spacer()
            }
            
            Spacer()
        }
        .navigationTitle("회원가입")
        .padding(.horizontal, 28)
    }
    
    func isAllEntered() -> Bool {
        
        return true
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
