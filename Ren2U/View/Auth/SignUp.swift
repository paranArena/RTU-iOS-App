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
    
    @StateObject var signUpVM = SignUpViewModel()
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
                            .onSubmit { focusedField = signUpVM.changeFocus(curIndex: focusedField?.rawValue ?? 0) }
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
        .background(NavigationLink(destination: Certification(isActive: $isActive, authModel: signUpVM), isActive: $signUpVM.isActive , label: {
            
        }))
        .animation(.spring(), value: focusedField)
        .interactiveDismissDisabled()
        .navigationTitle(" ")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text("회원가입").font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))}}
    }
    
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
                TextField("", text: $signUpVM.authField.email)
                    .frame(maxWidth: .infinity)
                    .font(.custom(CustomFont.RobotoRegular.rawValue, size: 18))
                    .overlay(alignment: .bottom)  {
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: 1)
                            .foregroundColor(signUpVM.authField.emailBottomLineColor)
                    }
                    .onChange(of: signUpVM.authField.email) { _ in
                        signUpVM.authField.emailDuplication = .none
                    }

                Text("@ajou.ac.kr")
                    .font(.custom(CustomFont.RobotoRegular.rawValue, size: 16))
                
                Button {
                    Task {
                        await signUpVM.checkEmailDuplicate()
                    }
                } label: {
                    Text("중복확인")
                        .padding(5)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .overlay(Capsule().stroke(signUpVM.authField.emailButtonColor, lineWidth: 1))
                        .foregroundColor(signUpVM.authField.emailButtonColor)
                        .padding(.leading, 19)
                }
                .disabled(signUpVM.authField.isDisabledButton)
            }
            
            Text(signUpVM.authField.wrongEmail)
                .foregroundColor(signUpVM.authField.wrongEmailColor)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .padding(.bottom, -10)
                .padding(.bottom, -10)
        }
    }
    
    @ViewBuilder
    private func Password() -> some View {
        
        VStack(alignment: .leading, spacing: 0) {
            Group {
                TextField("", text: $signUpVM.authField.password)
                    .isHidden(hidden: !signUpVM.authField.isShowingPassword)
                
                SecureField("", text: $signUpVM.authField.password)
                    .isHidden(hidden: signUpVM.authField.isShowingPassword)
            }
            .font(.custom(CustomFont.RobotoRegular.rawValue, size: 18))
            .overlay(alignment: .trailing) {
                Button {
                    signUpVM.authField.isShowingPassword.toggle()
                } label: {
                    Text("보기")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(.gray_ADB5BD)
                }

            }
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(signUpVM.authField.passwordBottomeLineColor)
            }
            
            Text(signUpVM.authField.wrongPassword)
                .foregroundColor(signUpVM.authField.wrongPasswordColor)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .padding(.bottom, -10)
        }
    }
    
    @ViewBuilder
    private func PasswordCheck() -> some View {
        
        VStack(alignment: .leading, spacing: 0) {
            Group {
                TextField("", text: $signUpVM.authField.passwordCheck)
                    .isHidden(hidden: !signUpVM.authField.isShowingPasswordCheck)
                
                SecureField("", text: $signUpVM.authField.passwordCheck)
                    .isHidden(hidden: signUpVM.authField.isShowingPasswordCheck)
            }
            .font(.custom(CustomFont.RobotoRegular.rawValue, size: 18))
            .overlay(alignment: .trailing) {
                Button {
                    signUpVM.authField.isShowingPasswordCheck.toggle()
                } label: {
                    Text("보기")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(.gray_ADB5BD)
                }

            }
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(signUpVM.authField.passwordCheckBottomeLineColor)
            }
            
            Text(signUpVM.authField.wrongPasswordCheck)
                .foregroundColor(signUpVM.authField.wrongPasswordCheckColor)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .padding(.bottom, -10)
        }
    }
    
    @ViewBuilder
    private func Name() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField("", text: $signUpVM.authField.name)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .foregroundColor(signUpVM.authField.nameBottomLineColor)
                }
            
            Text(signUpVM.authField.wrongName)
                .foregroundColor(signUpVM.authField.wrongNameColor)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .padding(.bottom, -10)
        }
    }
    
    @ViewBuilder
    private func Major() -> some View {
        TextField("", text: $signUpVM.authField.major)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(signUpVM.authField.majorBottomLineColor)
            }
    }
    
    @ViewBuilder
    private func StudentId() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField("", text: $signUpVM.authField.studentId)
                .keyboardType(.numberPad)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .foregroundColor(signUpVM.authField.studentIdLineColor)
                }
            
            
            Text(signUpVM.authField.wrongStudentId)
                .foregroundColor(signUpVM.authField.wrongStudentIdColor)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .padding(.bottom, -10)
        }
    }
    
    @ViewBuilder
    private func PhoneNumber() -> some View {
        HStack {
            Text("010)")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
            
            TextField("'-'를 제외한 숫자로 된 8자리 전화번호를 입력하세요.", text: $signUpVM.authField.phoneNumber)
                .keyboardType(.numberPad)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(signUpVM.authField.phoneNumberColor)
                .frame(maxHeight: 1)
        }
    }
    
    @ViewBuilder
    private func CertificatinoViewButton() -> some View {
        HStack {
            Button {
                Task {
                    await signUpVM.checkPhoneStudentIdDuplicate()
                }
            } label: {
                Image(systemName: "arrow.right.circle.fill")
                    .resizable() .frame(width: 86, height: 86)
                    .padding(.top, 49)
                    .foregroundColor(signUpVM.authField.checkAll ? .navy_1E2F97 : .gray_E9ECEF)
                    .padding(.top, 20)
            }
            .disabled(!signUpVM.authField.checkAll)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

//struct SignUp_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUp()
//    }
//}
