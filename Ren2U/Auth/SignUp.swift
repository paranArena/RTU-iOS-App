//
//  SignUp.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/13.
//

import SwiftUI
import Combine

struct SignUp: View {
    
    @StateObject var viewModel = SignUpModel()
    @FocusState private var foucesField: SignUpTextField?
    
    let password: [String] = ["Password", "Password 확인"]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 25) {

                Group {
                    email
                        .onSubmit { if viewModel.isNextFieldIsEmpty(curIndex: SignUpTextField.email.rawValue) { foucesField = .password } }

            
                    PasswordTextField(textType: password[0], text: $viewModel.text[SignUpTextField.password.rawValue],
                                      isShowingPassword: $viewModel.isShowingPassword[0])
                    .overlay(bottomLine)
                    .onSubmit { if viewModel.isNextFieldIsEmpty(curIndex: SignUpTextField.password.rawValue) { foucesField = .passwordCheck } }
                    .focused($foucesField, equals: .password)
                    
                    PasswordTextField(textType: password[1], text: $viewModel.text[SignUpTextField.passwordCheck.rawValue],
                                      isShowingPassword: $viewModel.isShowingPassword[1])
                    .overlay(bottomLine)
                    .overlay(message)
                    .onSubmit { if viewModel.isNextFieldIsEmpty(curIndex: SignUpTextField.passwordCheck.rawValue) { foucesField = .name } }
                    .focused($foucesField, equals: .passwordCheck)
                }
                
                VStack(alignment: .leading) {
                    Section {
                        BottomLinePlaceholder(placeholder: Text(""), text: $viewModel.text[3])
                            .onSubmit { if viewModel.isNextFieldIsEmpty(curIndex: SignUpTextField.name.rawValue) { foucesField = .department } }
                            .focused($foucesField, equals: .name)
                    } header: {
                        Text("이름")
                            .font(.system(size: 12))
                    }
                }
                
                VStack(alignment: .leading) {
                    Section {
                        BottomLinePlaceholder(placeholder: Text(""), text: $viewModel.text[4])
                            .onSubmit { if viewModel.isNextFieldIsEmpty(curIndex: SignUpTextField.department.rawValue) { foucesField = .studentId }}
                            .focused($foucesField, equals: .department)
                        
                    } header: {
                        Text("학과")
                            .font(.system(size: 12))
                    }
                }
                
                VStack(alignment: .leading) {
                    Section {
                        BottomLinePlaceholder(placeholder: Text(""), text: $viewModel.text[5])
                            .keyboardType(.numbersAndPunctuation)
                            .onSubmit { if viewModel.isNextFieldIsEmpty(curIndex: SignUpTextField.studentId.rawValue) { foucesField = .phoneNumber }}
                            .focused($foucesField, equals: .studentId)
                    } header: {
                        Text("학번")
                            .font(.system(size: 12))
                    }
                }
                
                VStack(alignment: .leading) {
                    Section {
                        BottomLinePlaceholder(placeholder: Text("'-'를 제외한 숫자로 된 전화번호를 입력하세요"), text: $viewModel.text[6])
                            .keyboardType(.numbersAndPunctuation)
                            .focused($foucesField, equals: .phoneNumber)
                    } header: {
                        Text("휴대폰 번호")
                            .font(.system(size: 12))
                    }
                }
                
                nextViewButton
                Spacer()
            }
            .padding(.horizontal, 28)
            .offset(y: CGFloat(foucesField?.rawValue ?? 0) * -30)
            .animation(.spring(), value: foucesField)
        }
    }
    
    var email: some View {
        
        VStack(alignment: .leading) {
            Section {
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
                    
                    .disabled(viewModel.isOverlappedEmail || viewModel.text[0].isEmpty)
                }
            } header: {
                Text("아주대학교 이메일")
                    .font(.system(size: 12))
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
                    .padding(.top, 20)
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
