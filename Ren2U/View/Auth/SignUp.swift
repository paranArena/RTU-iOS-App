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
                TextField("", text: $viewModel.authField.email)
                    .frame(maxWidth: .infinity)
                    .font(.custom(CustomFont.RobotoRegular.rawValue, size: 18))
                    .overlay(alignment: .bottom)  {
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: 1)
                            .foregroundColor(viewModel.authField.emailBottomLineColor)
                    }
                    .onChange(of: viewModel.authField.email) { _ in
                        viewModel.authField.isDuplicatedEmail = false
                        viewModel.authField.isCheckedEmailDuplicate = false
                    }

                Text("@ajou.ac.kr")
                    .font(.custom(CustomFont.RobotoRegular.rawValue, size: 16))
                
                Button {
                    Task {
                        let email = viewModel.authField.email
                        viewModel.authField.isCheckedEmailDuplicate = true
                        viewModel.authField.isDuplicatedEmail = await authViewModel.checkEmailDuplicate(email: email)
                    }
                } label: {
                    Text("중복확인")
                        .padding(5)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .overlay(Capsule().stroke(viewModel.authField.checkEmailButtonCondition ? Color.navy_1E2F97 : Color.gray_ADB5BD, lineWidth: 1))
                        .foregroundColor(viewModel.authField.checkEmailButtonCondition ? .navy_1E2F97 : .gray_ADB5BD)
                        .padding(.leading, 19)
                }
                .disabled(viewModel.authField.isCheckedEmailDuplicate || !viewModel.authField.checkEmailButtonCondition)
            }
            
            Group {
                if viewModel.authField.isCheckedEmailDuplicate && viewModel.authField.isDuplicatedEmail {
                    Text("이미 가입된 이메일입니다.")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                        .foregroundColor(.red_EB1808)
                } else if viewModel.authField.isCheckedEmailDuplicate && !viewModel.authField.isDuplicatedEmail {
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
        
        Group {
            TextField("", text: $viewModel.authField.password)
                .isHidden(hidden: !viewModel.authField.isShowingPassword)
            
            SecureField("", text: $viewModel.authField.password)
                .isHidden(hidden: viewModel.authField.isShowingPassword)
        }
        .font(.custom(CustomFont.RobotoRegular.rawValue, size: 18))
        .overlay(alignment: .trailing) {
            Button {
                viewModel.authField.isShowingPassword.toggle()
            } label: {
                Text("보기")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                    .foregroundColor(.gray_ADB5BD)
            }

        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(viewModel.authField.passwordBottomeLineColor)
        }
            
    }
    
    @ViewBuilder
    private func PasswordCheck() -> some View {
        
        VStack(alignment: .leading, spacing: 0) {
            Group {
                TextField("", text: $viewModel.authField.passwordCheck)
                    .isHidden(hidden: !viewModel.authField.isShowingPasswordCheck)
                
                SecureField("", text: $viewModel.authField.passwordCheck)
                    .isHidden(hidden: viewModel.authField.isShowingPasswordCheck)
            }
            .font(.custom(CustomFont.RobotoRegular.rawValue, size: 18))
            .overlay(alignment: .trailing) {
                Button {
                    viewModel.authField.isShowingPasswordCheck.toggle()
                } label: {
                    Text("보기")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(.gray_ADB5BD)
                }

            }
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(viewModel.authField.passwordCheckBottomeLineColor)
            }
        }
    }
    
    @ViewBuilder
    private func Name() -> some View {
        TextField("", text: $viewModel.authField.name)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(viewModel.authField.nameBottomLineColor)
            }
    }
    
    @ViewBuilder
    private func Major() -> some View {
        TextField("", text: $viewModel.authField.major)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(viewModel.authField.majorBottomLineColor)
            }
    }
    
    @ViewBuilder
    private func StudentId() -> some View {
        TextField("", text: $viewModel.authField.studentId)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(viewModel.authField.studentIdLineColor)
            }
    }
    
    @ViewBuilder
    private func PhoneNumber() -> some View {
        BottomLinePlaceholder(placeholder: "'-'를 제외한 숫자로 된 전화번호를 입력하세요", text: $viewModel.authField.phoneNumber)
            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
    }
    
    @ViewBuilder
    private func CertificatinoViewButton() -> some View {
        HStack {
            Spacer()

            NavigationLink {
                Certification(email: viewModel.authField.email, isActive: $isActive, user: viewModel.getUserInfo())
            } label: {
                Image(systemName: "arrow.right.circle.fill")
                    .resizable() .frame(width: 86, height: 86)
                    .padding(.top, 49)
                    .foregroundColor(viewModel.authField.checkAll ? .navy_1E2F97 : .gray_E9ECEF)
                    .padding(.top, 20)
            }
            .disabled(!viewModel.authField.checkAll)
            
            Spacer()
        }
    }
}

//struct SignUp_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUp()
//    }
//}
