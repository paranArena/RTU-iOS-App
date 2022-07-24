//
//  SwiftUIView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/12.
//

import SwiftUI

struct Login: View {
    
    @EnvironmentObject var authModel: AuthModel
    @StateObject var loginModel = LoginModel()
    @FocusState var focus: LoginField?
    
    var body: some View {
        NavigationView {
            VStack {

                GreetingText
                
                CapsulePlaceholder(text: $loginModel.account.email, placeholder: Text("E-mail"),
                                   color: .Gray_ADB5BD)
                    .font(.custom(CustomFont.RobotoRegular.rawValue, size: 16))
                    .padding(.top, 46)
                    .onSubmit { focus = .password }
                
                CapsuleSecurePlaceholder(text: $loginModel.account.password, placeholder: Text("Password"))
                    .font(.custom(CustomFont.RobotoRegular.rawValue, size: 16))
                    .padding(.top, 19)
                    .focused($focus, equals: .password)
                    
                
                HStack {
                    Text(loginModel.isWroungAccount ? "이메일 또는 비밀번호를 잘못 입력했습니다" : " ")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                        .foregroundColor(.Red_EB1808)
                    Spacer()
                }
                .padding(.leading)
                .padding(.top, 0)
                
                Button {
                    authModel.login(account: loginModel.account)
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 86, height: 86)
                        .padding(.top, 21)
                        .foregroundColor(!loginModel.account.email.isEmpty && !loginModel.account.password.isEmpty ? .Navy_1E2F97 : .Gray_E9ECEF)
                }
                .disabled(loginModel.account.email.isEmpty || loginModel.account.password.isEmpty)
                
                AuthHelp()
            }
            .navigationTitle(" ")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal, 40)
            .onAppear {
                loginModel.initTextFields()
                authModel.hello()
            }
        }
    }
    
    var GreetingText: some View {
        VStack {
            HStack {
                Text("Welcome!")
                    .font(.custom(CustomFont.RobotoBlack.rawValue, size: 36))
                Spacer()
            }
            
            HStack {
                Text("로그인 후 다양한 '가치'를 누려보세요!")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func AuthHelp() -> some View {
        HStack {
            Text("비밀번호 찾기")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                .foregroundColor(Color.Gray_495057)
            
            Text("|")
                .foregroundColor(Color.Gray_E9ECEF)
            
            NavigationLink {
                SignUp()
            } label: {
                Text("회원 가입")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                    .foregroundColor(Color.Gray_495057)
            }
        }
        .padding(.top, 21)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
