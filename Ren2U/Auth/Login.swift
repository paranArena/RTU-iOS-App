//
//  SwiftUIView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/12.
//

import SwiftUI

struct Login: View {
    
    private enum Field: Int, Hashable {
        case email
        case password
    }
    
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var account = Account(email: "", password: "")
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationView {
            VStack {

                GreetingText
                
                CapsulePlaceholder(text: $account.email, placeholder: Text("Email"))
                    .padding(.top, 46)
                    .onSubmit { focusedField = .password }
                
                passwordTextFiled
                    .focused($focusedField, equals: .password)
                    
                
                HStack {
                    Text(viewModel.isWrong ? "이메일 또는 비밀번호를 잘못 입력했습니다" : " ")
                        .font(.system(size: 10))
                        .foregroundColor(.Red_EB1808)
                    Spacer()
                }
                .padding(.leading)
                .padding(.top, 0)
                
                Button {
                    viewModel.login(account: account)
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 86, height: 86)
                        .padding(.top, 21)
                        .foregroundColor(!account.email.isEmpty && !account.password.isEmpty ? .Navy_1E2F97 : .Gray_E9ECEF)
                }
                .disabled(account.email.isEmpty || account.password.isEmpty)
                
                AuthHelp()
            }
            .navigationTitle(" ")
            .padding(.horizontal, 40)
        }
    }
    
    var passwordTextFiled: some View {
        CapsuleSecurePlaceholder(text: $account.password, placeholder: Text("Password"))
            .padding(.top, 19)
    }
    
    var GreetingText: some View {
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
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

struct AuthHelp: View {
    var body: some View {
        HStack {
            Text("비밀번호 찾기")
                .font(.system(size: 16))
                .foregroundColor(Color.Gray_495057)
            
            Text("|")
                .foregroundColor(Color.Gray_E9ECEF)
            
            NavigationLink {
                SignUp()
                    .navigationTitle("")
                    .toolbar {
                        ToolbarItemGroup(placement: .principal) {
                            Text("회원가입")
                                .font(.system(size: 20, weight: .medium))
                        }
                    }
            } label: {
                Text("회원 가입")
                    .font(.system(size: 16))
                    .foregroundColor(Color.Gray_495057)
            }
        }
        .padding(.top, 21)
    }
}
