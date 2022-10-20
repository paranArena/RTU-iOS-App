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
    
    @StateObject var signUpVM = SignUpViewModel(memberSevice: MemberService(url: ServerURL.runningServer.url))
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
        .basicNavigationTitle(title: "회원가입")
        .background(NavigationLink(destination: Certification(isActive: $isActive, authModel: signUpVM), isActive: $signUpVM.isActiveCertificationView , label: {
            
        }))
        .animation(.spring(), value: focusedField)
        .interactiveDismissDisabled()
        .alert("회원가입 실패", isPresented: $signUpVM.isDuplicatedPhoneNumber) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("이미 가입된 휴대폰 번호입니다. 본인의 번호라면 개발자에게 문의해주세요.")
        }
        .alert("회원가입 실패", isPresented: $signUpVM.isDulpicatedStudentId) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("이미 가입된 학번입니다. 본인의 번호라면 개발자에게 문의해주세요.")
        }
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
                TextField("", text: $signUpVM.param.email)
                    .frame(maxWidth: .infinity)
                    .font(.custom(CustomFont.RobotoRegular.rawValue, size: 18))
                    .overlay(alignment: .bottom)  {
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: 1)
                            .foregroundColor(signUpVM.param.emailBottomLineColor)
                    }
                    .onChange(of: signUpVM.param.email) { _ in
                        signUpVM.emailTextChanged()
                    }

                Text("@ajou.ac.kr")
                    .font(.custom(CustomFont.RobotoRegular.rawValue, size: 16))
                
                Button {
                    Task { await signUpVM.checkDulicateButtonTapped() } 
                } label: {
                    Text("중복확인")
                        .padding(5)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .overlay(Capsule().stroke(signUpVM.param.emailButtonColor, lineWidth: 1))
                        .foregroundColor(signUpVM.param.emailButtonColor)
                        .padding(.leading, 19)
                }
                .disabled(signUpVM.param.isDisabledButton)
            }
            
            Text(signUpVM.param.wrongEmail)
                .foregroundColor(signUpVM.param.wrongEmailColor)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .padding(.bottom, -10)
                .padding(.bottom, -10)
        }
    }
    
    @ViewBuilder
    private func Password() -> some View {
        
        VStack(alignment: .leading, spacing: 0) {
            Group {
                TextField("", text: $signUpVM.param.password)
                    .isHidden(hidden: !signUpVM.param.isShowingPassword)
                
                SecureField("", text: $signUpVM.param.password)
                    .isHidden(hidden: signUpVM.param.isShowingPassword)
            }
            .font(.custom(CustomFont.RobotoRegular.rawValue, size: 18))
            .overlay(alignment: .trailing) {
                Button {
                    signUpVM.param.isShowingPassword.toggle()
                } label: {
                    Text("보기")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(.gray_ADB5BD)
                }

            }
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(signUpVM.param.passwordBottomeLineColor)
            }
            
            Text(signUpVM.param.wrongPassword)
                .foregroundColor(signUpVM.param.wrongPasswordColor)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .padding(.bottom, -10)
        }
    }
    
    @ViewBuilder
    private func PasswordCheck() -> some View {
        
        VStack(alignment: .leading, spacing: 0) {
            Group {
                TextField("", text: $signUpVM.param.passwordCheck)
                    .isHidden(hidden: !signUpVM.param.isShowingPasswordCheck)
                
                SecureField("", text: $signUpVM.param.passwordCheck)
                    .isHidden(hidden: signUpVM.param.isShowingPasswordCheck)
            }
            .font(.custom(CustomFont.RobotoRegular.rawValue, size: 18))
            .overlay(alignment: .trailing) {
                Button {
                    signUpVM.param.isShowingPasswordCheck.toggle()
                } label: {
                    Text("보기")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(.gray_ADB5BD)
                }

            }
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(signUpVM.param.passwordCheckBottomeLineColor)
            }
            
            Text(signUpVM.param.wrongPasswordCheck)
                .foregroundColor(signUpVM.param.wrongPasswordCheckColor)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .padding(.bottom, -10)
        }
    }
    
    @ViewBuilder
    private func Name() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField("", text: $signUpVM.param.name)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .foregroundColor(signUpVM.param.nameBottomLineColor)
                }
            
            Text(signUpVM.param.wrongName)
                .foregroundColor(signUpVM.param.wrongNameColor)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .padding(.bottom, -10)
        }
    }
    
    @ViewBuilder
    private func Major() -> some View {
        TextField("", text: $signUpVM.param.major)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(signUpVM.param.majorBottomLineColor)
            }
    }
    
    @ViewBuilder
    private func StudentId() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField("", text: $signUpVM.param.studentId)
                .keyboardType(.numberPad)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .foregroundColor(signUpVM.param.studentIdLineColor)
                }
            
            
            Text(signUpVM.param.wrongStudentId)
                .foregroundColor(signUpVM.param.wrongStudentIdColor)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .padding(.bottom, -10)
        }
    }
    
    @ViewBuilder
    private func PhoneNumber() -> some View {
        HStack {
            Text("010)")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
            
            TextField("'-'를 제외한 숫자로 된 8자리 전화번호를 입력하세요.", text: $signUpVM.param.phoneNumber)
                .keyboardType(.numberPad)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(signUpVM.param.phoneNumberColor)
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
                    .foregroundColor(signUpVM.param.checkAll ? .navy_1E2F97 : .gray_E9ECEF)
                    .padding(.top, 20)
            }
            .disabled(!signUpVM.param.checkAll)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

//struct SignUp_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUp()
//    }
//}
