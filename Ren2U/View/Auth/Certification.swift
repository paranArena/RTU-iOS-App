//
//  Certification.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/13.
//

import SwiftUI

struct Certification: View {
    
    let email: String
    @Binding var isActive: Bool
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var authModel: AuthViewModel
    @StateObject var viewModel = ViewModel()
    
    let user: User
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("이메일로\n인증번호가 발송되었습니다.")
                    .multilineTextAlignment(.center)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                
                Text("4자리 숫자를 입력해주세요.")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                    .foregroundColor(.gray_495057)
                    .padding(.top, 50)
                
                CertificationTextField()
                
                Text(viewModel.isConfirmed ? " " : "인증번호가 일치하지 않습니다.")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                    .foregroundColor(.red_EB1808)
                
                ResendButton()
                GoSignUpSuccessButton()
                
                NavigationLink(isActive: $viewModel.isSingUpSeccussActive) {
                    SignUpSuccess(isActive: $isActive)
                } label: { }

                
            }
            .padding(.horizontal, 28)
            .padding(.top, 40)
        }
        .navigationTitle(" ")
        .onChange(of: scenePhase, perform: { scenePhsae in
            switch scenePhsae {
            case .active:
                viewModel.setTimeRemaining()
            case .inactive:
                break
            case .background:
                break
            @unknown default:
                break
            }
        })
        .onAppear {
            authModel.requestEmailCode(email: email)
            viewModel.startTimer()
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text("이메일 인증")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
            }
        }
    }
    
    @ViewBuilder
    private func CertificationTextField() -> some View {
        CapsulePlaceholder(text: $viewModel.certificationNum, placeholder: Text(""), color: .gray_ADB5BD)
            .keyboardType(.numberPad)
            .font(.custom(CustomFont.RobotoMedium.rawValue, size: 36))
            .multilineTextAlignment(.center)
            .overlay(TimerOverlay())
            .onTapGesture { viewModel.certificationNum = "" }
            .onChange(of: viewModel.certificationNum) { _ in
                viewModel.endEditingIfLengthLimitReached()
            }
    }
    
    @ViewBuilder
    private func ResendButton() -> some View {
        Button {
            viewModel.resetTimer()
            viewModel.certificationNum = ""
        } label: {Text("인증번호 재발송")}
            .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
            .foregroundColor(.gray_495057)
            .padding(.top, 50)
    }
    
    @ViewBuilder
    private func GoSignUpSuccessButton() -> some View {
        Button {
            viewModel.isConfirmed = authModel.checkCertificationNum(num: viewModel.certificationNum, user: user)
            viewModel.certificationNum = ""
            if viewModel.isConfirmed {
                Task {
                    viewModel.isSingUpSeccussActive = await authModel.signUp(user: user)
                }
            }
        } label: {
            Image(systemName: "arrow.right.circle.fill")
                .resizable().frame(width: 86, height: 86)
                .padding(.top, 49)
                .foregroundColor(viewModel.isReachedMaxLength(num: viewModel.certificationNum)
                                 ? .navy_1E2F97 : .gray_E9ECEF)
                .padding(.top, 50)
        }
        .disabled(!viewModel.isReachedMaxLength(num: viewModel.certificationNum))
    }
    
    @ViewBuilder
    private func TimerOverlay() -> some View {
        HStack {
            Spacer()
            Text("\(viewModel.getTimeString(time: viewModel.timeRemaining))")
                .font(.custom(CustomFont.RobotoMedium.rawValue, size: 16))
                .padding(.trailing, 10)
                .foregroundColor(.red_EB1808)
        }
    }
}

struct Certification_Previews: PreviewProvider {
    static var previews: some View {
        Certification(email: "email", isActive: .constant(true), user: User.dummyUser())
    }
}
