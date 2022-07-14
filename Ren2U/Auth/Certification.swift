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
                    .multilineTextAlignment(.center) .font(.system(size: 20, weight: .medium))
                
                Text("4자리 숫자를 입력해주세요.")
                    .foregroundColor(.Gray_495057) .padding(.top, 50)
                
                CapsulePlaceholder(text: $viewModel.certificationNum, placeholder: Text(""))
                    .keyboardType(.numberPad)   .font(.system(size: 36))
                    .multilineTextAlignment(.center)    .overlay(TimerOverlay)
                    .onTapGesture { viewModel.certificationNum = "" }
                    .onReceive(viewModel.certificationNum.publisher.collect()) { _ in
                        viewModel.endEditing()
                    }
                
                Text(viewModel.isWroungNum ? "인증번호가 일치하지 않습니다." : " ")
                    .font(.system(size: 14))
                    .foregroundColor(.Red_EB1808)
                
                Button {
                    viewModel.resetTimer()
                } label: {Text("인증번호 재발송")}
                    .foregroundColor(.Gray_495057) .padding(.top, 50)
                
                Button {
                    viewModel.isWroungNum.toggle()
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()    .frame(width: 86, height: 86)
                        .padding(.top, 49)
                        .foregroundColor(viewModel.changeColor(num: viewModel.certificationNum)
                                         ? .Navy_1E2F97 : .Gray_E9ECEF)
                        .padding(.top, 50)
                }
                .disabled(!viewModel.changeColor(num: viewModel.certificationNum))
                
            }
            .padding(.horizontal, 28)
        }
    }
    
    var TimerOverlay: some View {
        HStack {
            Spacer()
            Text("\(viewModel.timeString(time:viewModel.timeRemaining))")
                .font(.system(size: 16)) .padding(.trailing, 10)
                .foregroundColor(.Red_EB1808)
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
