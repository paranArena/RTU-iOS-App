//
//  Certification.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/13.
//

import SwiftUI

struct Certification: View {
    
    @Binding var isActive: Bool
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var authModel: SignUpViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                
                Guide()
                CertificationTextField()
                
                Text(authModel.isConfirmed ? " " : "인증번호가 일치하지 않습니다.")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                    .foregroundColor(.red_EB1808)
                
                ResendButton()
                GoSignUpSuccessButton()
                
                NavigationLink(isActive: $authModel.isActiveSignUpSuccess) {
                    SignUpSuccess(isActive: $isActive)
                } label: { }

                
            }
            .padding(.horizontal, 28)
            .padding(.top, 40)
        }
        .basicNavigationTitle(title: "이메일 인증")
        .onChange(of: scenePhase, perform: { scenePhsae in
            switch scenePhsae {
            case .active:
                authModel.setTimeRemaining()
            case .inactive:
                break
            case .background:
                break
            @unknown default:
                break
            }
        })
        .onAppear {
            authModel.startTimer()
        }
    }
    
    @ViewBuilder
    private func Guide() -> some View {
        Text("이메일로\n인증번호가 발송되었습니다.")
            .multilineTextAlignment(.center)
            .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
        
        Text("6자리 숫자를 입력해주세요.")
            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
            .foregroundColor(.gray_495057)
            .padding(.top, 50)
    }
    
    @ViewBuilder
    private func CertificationTextField() -> some View {
        CapsulePlaceholder(text: $authModel.authField.code, placeholder: Text(""), color: .gray_ADB5BD)
            .keyboardType(.numberPad)
            .font(.custom(CustomFont.RobotoMedium.rawValue, size: 36))
            .multilineTextAlignment(.center)
            .overlay(TimerOverlay())
            .onTapGesture { authModel.authField.clearCode() }
            .onChange(of: authModel.authField.code ) { _ in
                authModel.endEditingIfLengthLimitReached()
            }
    }
    
    @ViewBuilder
    private func ResendButton() -> some View {
        Button {
            authModel.resend()
        } label: {Text("인증번호 재발송")}
            .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
            .foregroundColor(.gray_495057)
            .padding(.top, 50)
    }
    
    @ViewBuilder
    private func GoSignUpSuccessButton() -> some View {
        Button {
            Task {
                await authModel.signUp()
            }
        } label: {
            Image(systemName: "arrow.right.circle.fill")
                .resizable().frame(width: 86, height: 86)
                .padding(.top, 49)
                .foregroundColor(authModel.isReachedMaxLength(num: authModel.authField.code)
                                 ? (authModel.timeRemaining <= 0 ? .gray_E9ECEF : .navy_1E2F97) : .gray_E9ECEF)
                .padding(.top, 50)
        }
        .disabled(!authModel.isReachedMaxLength(num: authModel.authField.code) || authModel.timeRemaining <= 0)
    }
    
    @ViewBuilder
    private func TimerOverlay() -> some View {
        HStack {
            Spacer()
            Text("\(authModel.getTimeString(time: authModel.timeRemaining))")
                .font(.custom(CustomFont.RobotoMedium.rawValue, size: 16))
                .padding(.trailing, 10)
                .foregroundColor(.red_EB1808)
        }
    }
}

//struct Certification_Previews: PreviewProvider {
//    static var previews: some View {
//        Certification(email: "email", isActive: .constant(true), user: User.dummyUser())
//    }
//}
