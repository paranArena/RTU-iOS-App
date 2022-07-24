//
//  Certification.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/13.
//

import SwiftUI

struct Certification: View {
    
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var authModel: AuthModel
    @StateObject var model = CertificationModel()
    let user: User
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("이메일로\n인증번호가 발송되었습니다.")
                    .multilineTextAlignment(.center)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                
                Text("4자리 숫자를 입력해주세요.")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                    .foregroundColor(.Gray_495057)
                    .padding(.top, 50)
                
                CapsulePlaceholder(text: $model.certificationNum, placeholder: Text(""))
                    .keyboardType(.numberPad)
                    .font(.custom(CustomFont.RobotoMedium.rawValue, size: 36))
                    .multilineTextAlignment(.center)
                    .overlay(TimerOverlay())
                    .onTapGesture { model.certificationNum = "" }
                    .onChange(of: model.certificationNum) { _ in
                        model.endEditingIfLengthLimitReached()
                    }
                
                Text(model.isConfirmed ? " " : "인증번호가 일치하지 않습니다.")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                    .foregroundColor(.Red_EB1808)
                
                Button {
                    model.resetTimer()
                    model.certificationNum = ""
                } label: {Text("인증번호 재발송")}
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                    .foregroundColor(.Gray_495057)
                    .padding(.top, 50)
                
                Button {
                    model.isConfirmed = authModel.checkCertificationNum(num: model.certificationNum, user: user)
                    model.certificationNum = ""
                    if model.isConfirmed {
                        authModel.signUp(user: user)
                    }
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()    .frame(width: 86, height: 86)
                        .padding(.top, 49)
                        .foregroundColor(model.isReachedMaxLength(num: model.certificationNum)
                                         ? .Navy_1E2F97 : .Gray_E9ECEF)
                        .padding(.top, 50)
                }
                .disabled(!model.isReachedMaxLength(num: model.certificationNum))
            }
            .padding(.horizontal, 28)
            .padding(.top, 40)
        }
        .navigationTitle(" ")
        .onChange(of: scenePhase, perform: { scenePhsae in
            switch scenePhsae {
            case .active:
                model.setTimeRemaining()
            case .inactive:
                break
            case .background:
                break
            @unknown default:
                break
            }
        })
        .onAppear {
            model.startTimer()
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text("이메일 인증")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
            }
        }
    }
    
    
    @ViewBuilder
    func TimerOverlay() -> some View {
        HStack {
            Spacer()
            Text("\(model.getTimeString(time:model.timeRemaining))")
                .font(.custom(CustomFont.RobotoMedium.rawValue, size: 16))
                .padding(.trailing, 10)
                .foregroundColor(.Red_EB1808)
        }
    }
}

struct Certification_Previews: PreviewProvider {
    static var previews: some View {
        Certification(user: User.default)
    }
}
