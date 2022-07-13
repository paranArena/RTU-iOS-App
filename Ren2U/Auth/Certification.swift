//
//  Certification.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/13.
//

import SwiftUI

struct Certification: View {
    
    @ObservedObject var viewModel = CertificationViewModel()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView {
            VStack {
                Text("이메일로\n인증번호가 발송되었습니다.")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20, weight: .medium))
                
                Text("4자리 숫자를 입력해주세요.")
                    .foregroundColor(.Gray_ADB5BD)
                    .padding(.top, 50)
                
                CapsulePlaceholder(text: $viewModel.certificationNum, placeholder: Text(""))
                    .font(.system(size: 36))
                    .multilineTextAlignment(.center)
                    .overlay(TimerOverlay)
                
                Text(viewModel.isWrongInput ? "인증번호가 일치하지 않습니다." : " ")
                    .font(.system(size: 14))
                    .foregroundColor(.RedText)
                
                
                Text("인증번호 재발송")
                    .padding(.top, 50)
                
                Button {
                    viewModel.isWrongInput.toggle()
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 86, height: 86)
                        .padding(.top, 49)
                        .foregroundColor(viewModel.certificationNum.isEmpty ? .GrayDivider : .NavyView)
                        .padding(.top, 50)
                }
            }
            .padding(.horizontal, 28)
        }
    }
    
    var TimerOverlay: some View {
        HStack {
            Spacer()
            Text("\(viewModel.timeString(time:viewModel.timeRemaining))")
                .font(.system(size: 16))
                .padding(.trailing, 10)
                .foregroundColor(.RedText)
                .onReceive(timer) { _ in
                    if viewModel.timeRemaining > 0 {
                        viewModel.timeRemaining -= 1
                    } else {
                        self.timer.upstream.connect().cancel()
                    }
                }
        }
    }
}

struct Certification_Previews: PreviewProvider {
    static var previews: some View {
        Certification()
    }
}
