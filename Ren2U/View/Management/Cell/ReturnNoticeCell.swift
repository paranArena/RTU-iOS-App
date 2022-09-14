//
//  ReturnNoticeCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/18.
//

import SwiftUI
import Kingfisher

struct ReturnNoticeCell: View {
    let userInfo: UserData
    let rentalItemInfo: ReturnInfo
    
    @State private var isShowingRequestButton = false
    @State private var offset: CGFloat = .zero
    @State private var isShowingSheet = false
    
    var body: some View {
        
        HStack {
            
            HStack {
                KFImage(URL(string: rentalItemInfo.imageSource)!).onFailure { err in
                    print(err.errorDescription ?? "KFImage err")
                }
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(15)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(userInfo.name)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(Color.gray_868E96)
                    
                    Text("\(rentalItemInfo.itemName)을 반납 완료했습니다.")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                    
                    
                    Text(getTime())
                        .font(.custom(CustomFont.RobotoRegular.rawValue, size: 12))
                        .foregroundColor(Color.gray_868E96)
                }
            }
            .gesture(TapGesture().onEnded {
                self.isShowingSheet = true
            })
                
            Spacer()
            
            HStack(alignment: .center, spacing: 0) {
                Button {
                    self.isShowingRequestButton = false
                    self.offset = .zero
                } label: {
                    Text("확인")
                }
                .frame(width: 80, height: 80)
                .background(Color.navy_1E2F97)
                .foregroundColor(Color.white)
            }
            .offset(x: 90)
        }
        .offset(x: isShowingRequestButton ? max(-90, offset) : max(-90, offset))
        .animation(.spring(), value: isShowingRequestButton)
        .animation(.spring(), value: offset)
        .simultaneousGesture(
            DragGesture()
                .onChanged {
                    print(offset)
                    self.offset = $0.translation.width
                    if !self.isShowingRequestButton {
                        self.offset = min(offset, 0)
                    } else {
                        self.offset = max(-90 + offset, -90)
                    }
                }
                .onEnded {
                    if !isShowingRequestButton {
                        if $0.translation.width <= -80 {
                            self.isShowingRequestButton = true
                            self.offset = -90
                        } else {
                            self.offset = 0
                        }
                    } else {
                        if $0.translation.width >= 80 {
                            self.isShowingRequestButton = false
                            self.offset = 0
                        } else {
                            self.offset = -90
                        }
                    }
                }
        )
        .sheet(isPresented: $isShowingSheet) {
            ReturnManagement(userInfo: userInfo, returnInfo: rentalItemInfo)
        }
    }
    
    func getTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd"
        return formatter.string(from: Date.now)
    }
}

struct ReturnNoticeCell_Previews: PreviewProvider {
    static var previews: some View {
        ReturnNoticeCell(userInfo: UserData.dummyUserData(), rentalItemInfo: ReturnInfo.dummyReturnInfo())
    }
}
