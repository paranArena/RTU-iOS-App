//
//  SwiftUIView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/12.
//

import SwiftUI

struct Login: View {
    
    @EnvironmentObject var authModel: AuthModel
    @StateObject var viewModel = ViewModel()
    @FocusState var focus: Field?
    @State private var isActive = false
    
    var body: some View {
    
        NavigationView {
            VStack {
                GreetingText()
                Email()
                Password()
                MissInput()
                LoginButton()
                AuthHelp()
            }
            .navigationTitle(" ")
            .navigationBarHidden(true)
            .padding(.horizontal, 40)
            .onAppear {
                viewModel.initTextFields()
                authModel.hello()
            }
        }
    }
    
    @ViewBuilder
    private func GreetingText() -> some View {
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
    private func Email() -> some View {
        CapsulePlaceholder(text: $viewModel.account.email, placeholder: Text("E-mail"),
                           color: .Gray_ADB5BD)
            .font(.custom(CustomFont.RobotoRegular.rawValue, size: 16))
            .padding(.top, 46)
            .onSubmit { focus = .password }
    }
    
    @ViewBuilder
    private func Password() -> some View {
        CapsuleSecurePlaceholder(text: $viewModel.account.password, placeholder: Text("Password"))
            .font(.custom(CustomFont.RobotoRegular.rawValue, size: 16))
            .padding(.top, 19)
            .focused($focus, equals: .password)
    }
    
    @ViewBuilder
    private func MissInput() -> some View {
        HStack {
            Text(viewModel.isWroungAccount ? "이메일 또는 비밀번호를 잘못 입력했습니다" : " ")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .foregroundColor(.Red_EB1808)
            Spacer()
        }
        .padding(.leading)
        .padding(.top, 0)
    }
    
    @ViewBuilder
    private func LoginButton() -> some View {
        Button {
            authModel.login(account: viewModel.account)
        } label: {
            Image(systemName: "arrow.right.circle.fill")
                .resizable()
                .frame(width: 86, height: 86)
                .padding(.top, 21)
                .foregroundColor(!viewModel.account.email.isEmpty && !viewModel.account.password.isEmpty ? .Navy_1E2F97 : .Gray_E9ECEF)
        }
        .disabled(viewModel.account.email.isEmpty || viewModel.account.password.isEmpty)
    }
    
    @ViewBuilder
    func AuthHelp() -> some View {
        HStack {
            Text("비밀번호 찾기")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                .foregroundColor(Color.Gray_495057)
            
            Text("|")
                .foregroundColor(Color.Gray_E9ECEF)
            
            NavigationLink(isActive: $isActive) {
                SignUp(isActive: $isActive)
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
