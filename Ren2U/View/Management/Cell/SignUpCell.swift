//
//  SignUpCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/31.
//

import SwiftUI

struct SignUpCell: View {
    
    @ObservedObject var managementVM: ManagementViewModel
    let userData: UserData
    @State private var isShowingRequestButton = false
    @State private var offset: CGFloat = .zero
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(userData.name)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                
                Text("\(userData.major) \(userData.studentId.substring(from: 2, to: 3))")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                    .foregroundColor(.gray_868E96)
            }
            
            Spacer()
            
            HStack {
                Text("가입신청")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                    .foregroundColor(.navy_1E2F97)
            }
            
            HStack(alignment: .center, spacing: 0) {
                Button {
                    self.offset = .zero
                    self.isShowingRequestButton = false
                    managementVM.acceptClubJoinTask(userData: userData)
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
struct SignUpCell_Previews: PreviewProvider {
    static var previews: some View {
        SignUpCell(managementVM: ManagementViewModel(groupId: 1), userData: UserData.dummyUserData())
    }
}
