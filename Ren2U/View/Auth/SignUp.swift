//
//  SignUp.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/13.
//

import SwiftUI
import Combine


extension SignUp {
    
    enum Field: Int, CaseIterable, Hashable {
        case email
        case password
        case passwordCheck
        case name
        case major
        case studentId
        case phoneNumber
        
        var title: String {
            switch self {
            case .email:
                return "아주대학교 이메일 "
            case .password:
                return "Password"
            case .passwordCheck:
                return "Password 확인"
            case .name:
                return "이름"
            case .major:
                return "학과"
            case .studentId:
                return "학번"
            case .phoneNumber:
                return "휴대폰 번호"
            }
        }
    }
}


struct SignUp: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel = ViewModel()
    @FocusState private var focusedField: SignUp.Field?
    @Binding var isActive: Bool
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack(alignment: .leading, spacing: 10) {
                
                Spacer()
                ForEach(Field.allCases, id: \.rawValue) { field in
                    Section {
                        Content(field: field)
                            .padding(.bottom, 10)
                            .focused($focusedField, equals: field)
                            .submitLabel(field != Field.phoneNumber ? .next : .done)
                            .onSubmit { focusedField = viewModel.changeFocus(curIndex: focusedField?.rawValue ?? 0) }
                    } header: {
                        Text(field.title).font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                    }
                    .isHidden(hidden: (field.rawValue) + 2 < focusedField?.rawValue ?? 0)
                }

                CertificatinoViewButton()
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .animation(.spring(), value: focusedField)
        .interactiveDismissDisabled()
        .navigationTitle(" ")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text("회원가입").font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))}}
    } // body
    
    @ViewBuilder
    private func Content(field: Field) -> some View {
        switch field {
        case .email:
            Email()
        case .password:
            Password()
        case .passwordCheck:
            PasswordCheck()
        case .name:
            Name()
        case .major:
            Major()
        case .studentId:
            StudentId()
        case .phoneNumber:
            PhoneNumber()
        }
    }
    
    @ViewBuilder
    private func Email() -> some View {
        
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                let emailIndex = Field.email.rawValue
                
                BottomLineTextfield(placeholder: "", placeholderLocation: .none, placeholderSize: 14, isConfirmed: $viewModel.isOverlappedEmail, text: $viewModel.text[emailIndex])
                    .onChange(of: viewModel.text[emailIndex]) { _ in
                        viewModel.isOverlappedEmail = false
                        authViewModel.isCheckEmailDuplicate = false
                    }

                Text("@ajou.ac.kr")
                    .font(.custom(CustomFont.RobotoRegular.rawValue, size: 16))
                
                Button {
                    Task {
                        let email = viewModel.text[emailIndex]
                        viewModel.isOverlappedEmail = await !authViewModel.checkEmailDuplicate(email: email)
                    }
                } label: {
                    Text("중복확인")
                        .padding(5)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .overlay(Capsule().stroke(viewModel.text[Field.email.rawValue].isEmpty ? Color.gray_ADB5BD : Color.navy_1E2F97, lineWidth: 1))
                        .foregroundColor(viewModel.text[Field.email.rawValue].isEmpty ? .gray_ADB5BD : .navy_1E2F97)
                        .padding(.leading, 19)
                }
                .disabled(viewModel.isOverlappedEmail || viewModel.text[Field.email.rawValue].isEmpty)
            }
            
            Group {
                if authViewModel.isCheckEmailDuplicate && !viewModel.isOverlappedEmail {
                    Text("이미 가입된 이메일입니다.")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                        .foregroundColor(.red_EB1808)
                } else if authViewModel.isCheckEmailDuplicate && viewModel.isOverlappedEmail {
                    Text("사용할 수 있는 이메일입니다.")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                        .foregroundColor(.green_2CA900)
                } else {
                    Text("")
                }
            }
            .padding(.bottom, -10)
            
        }
    }
    
    @ViewBuilder
    private func Password() -> some View {
        PasswordTextField(text: $viewModel.text[Field.password.rawValue], isShowingPassword: $viewModel.isShowingPassword)
            .overlay(BottomLine())
    }
    
    @ViewBuilder
    private func PasswordCheck() -> some View {
        
        VStack(alignment: .leading, spacing: 0) {
            PasswordTextField(text: $viewModel.text[Field.passwordCheck.rawValue], isShowingPassword: $viewModel.isShowingPasswordCheck)
                .overlay(BottomLine())
            Message()
        }
    }
    
    @ViewBuilder
    private func Name() -> some View {
        BottomLinePlaceholder(placeholder: "", text: $viewModel.text[Field.name.rawValue])
    }
    
    @ViewBuilder
    private func Major() -> some View {
        BottomLinePlaceholder(placeholder: "", text: $viewModel.text[Field.major.rawValue])
    }
    
    @ViewBuilder
    private func StudentId() -> some View {
        BottomLinePlaceholder(placeholder: "", text: $viewModel.text[Field.studentId.rawValue])
    }
    
    @ViewBuilder
    private func PhoneNumber() -> some View {
        BottomLinePlaceholder(placeholder: "'-'를 제외한 숫자로 된 전화번호를 입력하세요", text: $viewModel.text[Field.phoneNumber.rawValue])
            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
    }
    
    @ViewBuilder
    private func CertificatinoViewButton() -> some View {
        HStack {
            Spacer()

            NavigationLink {
                Certification(email: viewModel.text[Field.email.rawValue], isActive: $isActive, user: viewModel.getUserInfo())
            } label: {
                Image(systemName: "arrow.right.circle.fill")
                    .resizable() .frame(width: 86, height: 86)
                    .padding(.top, 49)
                    .foregroundColor(viewModel.isFilledAll(textArray: viewModel.text) ? .navy_1E2F97 : .gray_E9ECEF)
                    .padding(.top, 20)
            }
            .disabled(!viewModel.isFilledAll(textArray: viewModel.text))
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func BottomLine() ->  some View {
        VStack {
            Spacer()
            Rectangle()
                .frame(height: 1)
                .foregroundColor(!viewModel.text[Field.password.rawValue].isEmpty
                                 && viewModel.text[Field.password.rawValue] == viewModel.text[Field.passwordCheck.rawValue]
                                 ? .navy_1E2F97 : .gray_ADB5BD)
        }
    }
    
    @ViewBuilder
    private func Message() -> some View {
        HStack {
            if viewModel.isFilledAny(text1: viewModel.text[Field.password.rawValue],
                                     text2: viewModel.text[Field.passwordCheck.rawValue]) {
                Text(viewModel.isFilledAnyAndEqualText(text1: viewModel.text[Field.password.rawValue],
                                           text2: viewModel.text[Field.passwordCheck.rawValue])
                     ? "비밀번호가 일치합니다" : "비밀번호가 일치하지 않습니다.")
                .foregroundColor(viewModel.isFilledAnyAndEqualText(text1: viewModel.text[Field.password.rawValue],
                                                       text2: viewModel.text[Field.passwordCheck.rawValue])
                                 ? Color.green_2CA900 : Color.red_EB1808)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .padding(.bottom, -10)
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
