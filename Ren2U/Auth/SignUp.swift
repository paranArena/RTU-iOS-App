//
//  SignUp.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/13.
//

import SwiftUI
import Combine

struct SignUp: View {
    
    @StateObject var viewModel = SignUpViewModel()
    let password: [String] = ["Password", "Password 확인"]
    let normalKeyboard: [String] = ["이름", "학과"]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {

                Group {
                    email
                        .padding(.bottom, 0)
                    
                    PasswordTextField(textType: password[0], text: $viewModel.text[SignUpTextField.password.rawValue],
                                      isShowingPassword: $viewModel.isShowingPassword[0])
                    .overlay(bottomLine)
                    
                    PasswordTextField(textType: password[1], text: $viewModel.text[SignUpTextField.passwordCheck.rawValue],
                                      isShowingPassword: $viewModel.isShowingPassword[1])
                    .overlay(bottomLine)
                    .overlay(message)
                    
                }
                
                ForEach(normalKeyboard.indices) { index in
                    Text(normalKeyboard[index])
                        .font(.system(size: 12))
                    BottomLinePlaceholder(placeholder: Text(""), text: $viewModel.text[index + 3])
                }
                
                Text("학번")
                    .font(.system(size: 12))
                BottomLinePlaceholder(placeholder: Text(""), text: $viewModel.text[5])
                    .keyboardType(.numberPad)
                
                Text("휴대폰 번호")
                    .font(.system(size: 12))
                BottomLinePlaceholder(placeholder: Text("'-'를 제외한 숫자로 된 전화번호를 입력하세요"), text: $viewModel.text[6])
                    .keyboardType(.numberPad)
                
                
                nextViewButton
                Spacer()
            }
        .padding(.horizontal, 28)
        }
    }
    
    var email: some View {
        
        VStack(alignment: .leading) {
            Text("아주대학교 이메일")
                .font(.system(size: 12))

            HStack {
                BottomLineTextfield(placeholder: "", placeholderLocation: .none, isConfirmed: $viewModel.isOverlappedEmail, text: $viewModel.text[0])
                    .onChange(of: viewModel.text[0]) { _ in viewModel.isOverlappedEmail = false }

                Text("@ajou.ac.kr")
                    .font(.system(size: 16))
                
                Button {
                    viewModel.isOverlappedEmail.toggle()
                } label: {
                    Text("중복확인")
                        .padding(5)
                        .font(.system(size: 12))
                        .overlay(Capsule().stroke(viewModel.text[0].isEmpty ? Color.Gray_ADB5BD : Color.Navy_1E2F97, lineWidth: 1))
                        .foregroundColor(viewModel.text[0].isEmpty ? .Gray_ADB5BD : .Navy_1E2F97)
                        .padding(.leading, 19)
                }
            }
        }
    }
    
    var nextViewButton: some View {
        HStack {
            Spacer()
            NavigationLink {
                Certification()
                    .toolbar {
                        ToolbarItemGroup(placement: .principal) {
                            Text("이메일 인증")
                                .font(.system(size: 20, weight: .medium))
                        }
                    }
            } label: {
                Image(systemName: "arrow.right.circle.fill")
                    .resizable() .frame(width: 86, height: 86)
                    .padding(.top, 49)
                    .foregroundColor(viewModel.isFilledAll(textArray: viewModel.text) ? .Navy_1E2F97 : .Gray_E9ECEF)
                    .padding(.top, 50)
            }
            .disabled(!viewModel.isFilledAll(textArray: viewModel.text))
            
            Spacer()
        }
    }
    
    var bottomLine: some View {
        VStack {
            Spacer()
            Rectangle()
                .frame(height: 1)
                .foregroundColor(!viewModel.text[1].isEmpty && viewModel.text[1] == viewModel.text[2]
                                 ? .Navy_1E2F97 : .Gray_ADB5BD)
        }
    }
    
    var message: some View {
        HStack {
            if viewModel.isFilledAny(text1: viewModel.text[SignUpTextField.password.rawValue],
                                     text2: viewModel.text[SignUpTextField.passwordCheck.rawValue]) {
                Text(viewModel.isFilledAnyAndEqualText(text1: viewModel.text[SignUpTextField.password.rawValue],
                                           text2: viewModel.text[SignUpTextField.passwordCheck.rawValue])
                     ? "비밀번호가 일치합니다" : "비밀번호가 일치하지 않습니다.")
                .foregroundColor(viewModel.isFilledAnyAndEqualText(text1: viewModel.text[SignUpTextField.password.rawValue],
                                                       text2: viewModel.text[SignUpTextField.passwordCheck.rawValue])
                                 ? Color.Green_2CA900 : Color.Red_EB1808)
                .font(.system(size: 12))
                .offset(y: 30)
            }
            Spacer()
        }
    }
}

//struct SignUp_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUp()
//    }
//}
