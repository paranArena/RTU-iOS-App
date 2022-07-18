//
//  SignUp.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/13.
//

import SwiftUI
import Combine

struct SignUp: View {
    
    @StateObject var signUpModel = SignUpModel()
    @FocusState private var foucesField: SignUpField?
    let password: [String] = ["Password", "Password 확인"]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 25) {

                Group {
                    email
                        .onSubmit { foucesField = signUpModel.foucsChange(curIndex: SignUpField.email.rawValue)}

            
                    PasswordTextField(textType: password[0], text: $signUpModel.text[SignUpField.password.rawValue],
                                      isShowingPassword: $signUpModel.isShowingPassword)
                    .overlay(bottomLine)
                    .onSubmit { foucesField = signUpModel.foucsChange(curIndex: SignUpField.password.rawValue)}
                    .focused($foucesField, equals: .password)
                    
                    PasswordTextField(textType: password[1], text: $signUpModel.text[SignUpField.passwordCheck.rawValue],
                                      isShowingPassword: $signUpModel.isShowingPasswordCheck)
                    .overlay(bottomLine)
                    .overlay(message)
                    .onSubmit { foucesField = signUpModel.foucsChange(curIndex: SignUpField.passwordCheck.rawValue)}
                    .focused($foucesField, equals: .passwordCheck)
                }
                
                VStack(alignment: .leading) {
                    Section {
                        BottomLinePlaceholder(placeholder: Text(""), text: $signUpModel.text[3])
                            .onSubmit { foucesField = signUpModel.foucsChange(curIndex: SignUpField.name.rawValue)}
                            .focused($foucesField, equals: .name)
                    } header: {
                        Text("이름")
                            .font(.system(size: 12))
                    }
                }
                
                VStack(alignment: .leading) {
                    Section {
                        BottomLinePlaceholder(placeholder: Text(""), text: $signUpModel.text[4])
                            .onSubmit { foucesField = signUpModel.foucsChange(curIndex: SignUpField.department.rawValue)}
                            .focused($foucesField, equals: .department)
                        
                    } header: {
                        Text("학과")
                            .font(.system(size: 12))
                    }
                }
                
                VStack(alignment: .leading) {
                    Section {
                        BottomLinePlaceholder(placeholder: Text(""), text: $signUpModel.text[5])
                            .keyboardType(.numbersAndPunctuation)
                            .onSubmit { foucesField = signUpModel.foucsChange(curIndex: SignUpField.studentId.rawValue)}
                            .focused($foucesField, equals: .studentId)
                    } header: {
                        Text("학번")
                            .font(.system(size: 12))
                    }
                }
                
                VStack(alignment: .leading) {
                    Section {
                        BottomLinePlaceholder(placeholder: Text("'-'를 제외한 숫자로 된 전화번호를 입력하세요"), text: $signUpModel.text[6])
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
            .offset(y: CGFloat(foucesField?.rawValue ?? 0) * -40)
            .animation(.spring(), value: foucesField)
        }
    }
    
    var email: some View {
        
        VStack(alignment: .leading) {
            Section {
                HStack {
                    BottomLineTextfield(placeholder: "", placeholderLocation: .none, isConfirmed: $signUpModel.isOverlappedEmail, text: $signUpModel.text[0])
                        .onChange(of: signUpModel.text[SignUpField.email.rawValue]) { _ in signUpModel.isOverlappedEmail = false }

                    Text("@ajou.ac.kr")
                        .font(.system(size: 16))
                    
                    Button {
                        signUpModel.isOverlappedEmail.toggle()
                    } label: {
                        Text("중복확인")
                            .padding(5)
                            .font(.system(size: 12))
                            .overlay(Capsule().stroke(signUpModel.text[SignUpField.email.rawValue].isEmpty ? Color.Gray_ADB5BD : Color.Navy_1E2F97, lineWidth: 1))
                            .foregroundColor(signUpModel.text[SignUpField.email.rawValue].isEmpty ? .Gray_ADB5BD : .Navy_1E2F97)
                            .padding(.leading, 19)
                    }
                    
                    .disabled(signUpModel.isOverlappedEmail || signUpModel.text[SignUpField.email.rawValue].isEmpty)
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
                Certification(user: signUpModel.getUserInfo())
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
                    .foregroundColor(signUpModel.isFilledAll(textArray: signUpModel.text) ? .Navy_1E2F97 : .Gray_E9ECEF)
                    .padding(.top, 20)
            }
            .disabled(!signUpModel.isFilledAll(textArray: signUpModel.text))
            
            Spacer()
        }
    }
    
    var bottomLine: some View {
        VStack {
            Spacer()
            Rectangle()
                .frame(height: 1)
                .foregroundColor(!signUpModel.text[SignUpField.password.rawValue].isEmpty
                                 && signUpModel.text[SignUpField.password.rawValue] == signUpModel.text[SignUpField.passwordCheck.rawValue]
                                 ? .Navy_1E2F97 : .Gray_ADB5BD)
        }
    }
    
    var message: some View {
        HStack {
            if signUpModel.isFilledAny(text1: signUpModel.text[SignUpField.password.rawValue],
                                     text2: signUpModel.text[SignUpField.passwordCheck.rawValue]) {
                Text(signUpModel.isFilledAnyAndEqualText(text1: signUpModel.text[SignUpField.password.rawValue],
                                           text2: signUpModel.text[SignUpField.passwordCheck.rawValue])
                     ? "비밀번호가 일치합니다" : "비밀번호가 일치하지 않습니다.")
                .foregroundColor(signUpModel.isFilledAnyAndEqualText(text1: signUpModel.text[SignUpField.password.rawValue],
                                                       text2: signUpModel.text[SignUpField.passwordCheck.rawValue])
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
