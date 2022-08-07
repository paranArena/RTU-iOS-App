//
//  SignUp.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/13.
//

import SwiftUI
import Combine

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
                            .onSubmit { focusedField = viewModel.foucsChange(curIndex: focusedField?.rawValue ?? 0) }
                    } header: {
                        Text(field.title).font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                    }
                    .isHidden(hidden: field.rawValue < focusedField?.rawValue ?? 0)
                }

                CertificatinoViewButton()
                    .isHidden(hidden: focusedField != nil)
                
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
        
        VStack(alignment: .leading) {
            HStack {
                BottomLineTextfield(placeholder: "", placeholderLocation: .none, placeholderSize: 14, isConfirmed: $viewModel.isOverlappedEmail, text: $viewModel.text[Field.email.rawValue])
                    .onChange(of: viewModel.text[Field.email.rawValue]) { _ in viewModel.isOverlappedEmail = false }

                Text("@ajou.ac.kr")
                    .font(.custom(CustomFont.RobotoRegular.rawValue, size: 16))
                
                Button {
                    viewModel.isOverlappedEmail.toggle()
                } label: {
                    Text("중복확인")
                        .padding(5)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .overlay(Capsule().stroke(viewModel.text[Field.email.rawValue].isEmpty ? Color.Gray_ADB5BD : Color.Navy_1E2F97, lineWidth: 1))
                        .foregroundColor(viewModel.text[Field.email.rawValue].isEmpty ? .Gray_ADB5BD : .Navy_1E2F97)
                        .padding(.leading, 19)
                }
                .disabled(viewModel.isOverlappedEmail || viewModel.text[Field.email.rawValue].isEmpty)
            }
        }
    }
    
    @ViewBuilder
    private func Password() -> some View {
        PasswordTextField(text: $viewModel.text[Field.password.rawValue], isShowingPassword: $viewModel.isShowingPassword)
            .overlay(BottomLine())
    }
    
    @ViewBuilder
    private func PasswordCheck() -> some View {
        PasswordTextField(text: $viewModel.text[Field.passwordCheck.rawValue], isShowingPassword: $viewModel.isShowingPasswordCheck)
        .overlay(BottomLine())
        .overlay(Message())
    }
    
    @ViewBuilder
    private func Name() -> some View {
        BottomLinePlaceholder(placeholder: Text(""), text: $viewModel.text[Field.name.rawValue])
    }
    
    @ViewBuilder
    private func Major() -> some View {
        BottomLinePlaceholder(placeholder: Text(""), text: $viewModel.text[Field.major.rawValue])
    }
    
    @ViewBuilder
    private func StudentId() -> some View {
        BottomLinePlaceholder(placeholder: Text(""), text: $viewModel.text[Field.studentId.rawValue])
    }
    
    @ViewBuilder
    private func PhoneNumber() -> some View {
        BottomLinePlaceholder(placeholder: Text("'-'를 제외한 숫자로 된 전화번호를 입력하세요"), text: $viewModel.text[Field.phoneNumber.rawValue])
            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
    }
    
    @ViewBuilder
    private func CertificatinoViewButton() -> some View {
        HStack {
            Spacer()

            NavigationLink {
                Certification(isActive: $isActive, user: viewModel.getUserInfo())
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
    
    @ViewBuilder
    private func BottomLine() ->  some View {
        VStack {
            Spacer()
            Rectangle()
                .frame(height: 1)
                .foregroundColor(!viewModel.text[Field.password.rawValue].isEmpty
                                 && viewModel.text[Field.password.rawValue] == viewModel.text[Field.passwordCheck.rawValue]
                                 ? .Navy_1E2F97 : .Gray_ADB5BD)
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
