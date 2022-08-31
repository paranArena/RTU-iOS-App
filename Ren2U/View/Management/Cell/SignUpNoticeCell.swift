//
//  SignUpCell .swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/18.
//

import SwiftUI

struct SignUpNoticeCell: View {
    
    let userInfo: UserData
    @State private var isShowingRequestButton = false
    @State private var offset: CGFloat = .zero
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(userInfo.major) \(userInfo.name)님이 회원가입을 요청했습니다.")
                    .lineLimit(1)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                
                Text(getTime())
                    .font(.custom(CustomFont.RobotoRegular.rawValue, size: 12))
                    .foregroundColor(Color.gray_868E96)
            
            }
            
            Spacer()
            
            HStack(alignment: .center, spacing: 0) {
                Button {
                    self.offset = .zero
                    self.isShowingRequestButton = false
                } label: {
                    Text("확인")
                        .lineLimit(1)
                }
                .frame(width: 80, height: 80)
                .background(Color.navy_1E2F97)
                .foregroundColor(Color.white)
                
                Button {
                    self.offset = .zero
                    self.isShowingRequestButton = false
                } label: {
                    Text("거부")
                        .lineLimit(1)
                }
                .frame(width: 80, height: 80)
                .background(Color.red_FF6155)
                .foregroundColor(Color.white)
                .padding(0)
            }
            .offset(x : 180)
            .padding(.leading, -180)
            
        }
        .offset(x: isShowingRequestButton ? max(-160, offset) : max(-160, offset))
        .animation(.spring(), value: isShowingRequestButton)
        .animation(.spring(), value: offset)
        .gesture(
            DragGesture()
                .onChanged {
                    print(offset)
                    self.offset = $0.translation.width
                    if !self.isShowingRequestButton {
                        self.offset = min(offset, 0)
                    } else {
                        self.offset = max(-160 + offset, -160)
                    }
                }
                .onEnded {
                    if !isShowingRequestButton {
                        if $0.translation.width <= -80 {
                            self.isShowingRequestButton = true
                            self.offset = -160
                        } else {
                            self.offset = 0
                        }
                    } else {
                        if $0.translation.width >= 80 {
                            self.isShowingRequestButton = false
                            self.offset = 0
                        } else {
                            self.offset = -160
                        }
                    }
                }
        )
    }
    
    func getTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd"
        return formatter.string(from: Date.now)
    }
}

struct SignUpNoticeCell_Previews: PreviewProvider {
    static var previews: some View {
        SignUpNoticeCell(userInfo: UserData.dummyUserData())
    }
}
