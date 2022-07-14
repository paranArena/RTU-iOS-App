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
    
    @State private var isConfirmed = [Bool](repeating: false, count: 7)
    @State private var passwordText: [String] = ["", ""]
    @State private var isShowingPassword = [Bool](repeating: false, count: 2)
    @State private var typeText: [String] = ["", "", ""]
    @State private var phoneNumber: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
        
                Text("아주대학교 이메일")
                    .font(.system(size: 12))

                HStack {
                    BottomLineTextfield(placeholder: "", placeholderLocation: .none, isConfirmed: $isConfirmed[0], text: $email)

                    Text("@ajou.ac.kr")
                        .font(.system(size: 16))
                    
                    Button {
                        isConfirmed[0].toggle()
                    } label: {
                        Text("중복확인")
                            .padding(5)
                            .font(.system(size: 12))
                            .overlay(Capsule().stroke(email.isEmpty ? Color.Gray_ADB5BD : Color.Navy_1E2F97, lineWidth: 1))
                            .foregroundColor(email.isEmpty ? .Gray_ADB5BD : .Navy_1E2F97)
                            .padding(.leading, 19)
                    }
                }
                
                ForEach(password.indices) { index in
                    Text(password[index])
                        .font(.system(size: 12))
                    
                    Group {
                        if isShowingPassword[index] {
                            TextField("", text: $passwordText[index])
                        } else {
                            SecureField("", text: $passwordText[index])
                        }
                    }
                    .font(.system(size: 16))
                    .overlay(
                        VStack {
                            Spacer()
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(!passwordText[0].isEmpty && passwordText[0] == passwordText[1] ? .Navy_1E2F97 : .Gray_ADB5BD)
                        }
                    )
                    .overlay(
                        HStack {
                            Spacer()
                            Button {
                                isShowingPassword[index].toggle()
                            } label: {
                                Text("보기").font(.system(size: 14)).foregroundColor(.Gray_ADB5BD)
                            }
                        }
                    )
                }
                
                ForEach(type.indices) { index in
                    Text(type[index])
                        .font(.system(size: 12))
                    BottomLinePlaceholder(placeholder: Text(""), text: $typeText[index])
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
                    }

                    Spacer()
                }
                
                Spacer()
            }
        .padding(.horizontal, 28)
        }
    }
}

//struct SignUp_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUp()
//    }
//}
