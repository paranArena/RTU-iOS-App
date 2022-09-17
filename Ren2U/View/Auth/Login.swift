//
//  SwiftUIView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/12.
//

import SwiftUI


struct Login: View {
    
    @EnvironmentObject var loginManager: MyPageViewModel
    @EnvironmentObject var authModel: MyPageViewModel
    @StateObject var loginVM = LoginViewModel() 
    @FocusState var focus: Field?
    
    enum Field: Int, CaseIterable {
        case email
        case password
    }
    
    var body: some View {
    
        NavigationView {
            VStack(alignment: .center, spacing: 10) {
                GreetingText()
                Email()
                Password()
                MissInput()
                LoginButton()
                AuthHelp()
                DeveloperContact()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .navigationTitle(" ")
            .navigationBarHidden(true)
            .padding(.horizontal, 40)
            .onAppear {
                loginVM.clearFields()
            }
        }
        .navigationViewStyle(.stack)
    }
    
    @ViewBuilder
    private func GreetingText() -> some View {
        VStack {
            Text("Welcome!")
                .font(.custom(CustomFont.RobotoBlack.rawValue, size: 36))
            
            Text("로그인 후 다양한 '가치'를 누려보세요!")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
    }
    
    @ViewBuilder
    private func Email() -> some View {
        CapsulePlaceholder(text: $loginVM.account.email , placeholder: Text("E-mail"),
                           color: .gray_ADB5BD)
            .font(.custom(CustomFont.RobotoRegular.rawValue, size: 16))
            .padding(.top, 46)
            .keyboardType(.emailAddress)
            .onSubmit { focus = .password }
    }
    
    @ViewBuilder
    private func Password() -> some View {
        CapsuleSecurePlaceholder(text: $loginVM.account.password, placeholder: Text("Password"))
            .font(.custom(CustomFont.RobotoRegular.rawValue, size: 16))
            .padding(.top, 19)
            .focused($focus, equals: .password)
    }
    
    @ViewBuilder
    private func MissInput() -> some View {
        HStack {
            Text(loginVM.missInput.rawValue)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .foregroundColor(.red_EB1808)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading)
        .padding(.top, 0)
    }
    
    @ViewBuilder
    private func LoginButton() -> some View {
        Button {
            Task {
                loginManager.isLogined = await loginVM.login()
            }
        } label: {
            Image(systemName: "arrow.right.circle.fill")
                .resizable()
                .frame(width: 86, height: 86)
                .padding(.top, 21)
                .foregroundColor(loginVM.account.buttonFGColor)
        }
        .disabled(loginVM.account.isDisable)
    }
    
    @ViewBuilder
    private func AuthHelp() -> some View {
        HStack {
            
            NavigationLink {
                ResetPassWordWithCode()
            } label: {
                Text("비밀번호 찾기")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                    .foregroundColor(Color.gray_495057)
            }
            
            Text("|")
                .foregroundColor(Color.gray_E9ECEF)
            
            NavigationLink(isActive: $loginVM.isActiveSignUpView) {
                SignUp(isActive: $loginVM.isActiveSignUpView)
            } label: {
                Text("회원 가입")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                    .foregroundColor(Color.gray_495057)
            }
        }
        .padding(.top, 21)
    }
    
    @ViewBuilder
    private func DeveloperContact() -> some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text("개발자 연락처")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .foregroundColor(.gray_868E96)
            
            Text("nou0ggid@gmail.com")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .tint(Color.navy_1E2F97)
        }
        .padding(.horizontal, -30)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        Login()
//    }
//}
