//
//  ReturnNoticeCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/18.
//

import SwiftUI
import Kingfisher

struct ReturnNoticeCell: View {
    let userInfo: User
    let rentalItemInfo: ReturnInfo
    
    @State private var isShowingRequestButton = false
    @State private var offset: CGSize = .zero
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
                        .foregroundColor(Color.gray868E96)
                    
                    Text("\(rentalItemInfo.itemName)을 반납 완료했습니다.")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                    
                    
                    Text(getTime())
                        .font(.custom(CustomFont.RobotoRegular.rawValue, size: 12))
                        .foregroundColor(Color.gray868E96)
                }
            }
            .simultaneousGesture(TapGesture().onEnded {
                self.isShowingSheet = true
            })
                
            Spacer()
            
            HStack(alignment: .center, spacing: 0) {
                Button {
                    self.isShowingRequestButton = false
                } label: {
                    Text("확인")
                }
                .frame(width: 80, height: 80)
                .background(Color.Navy_1E2F97)
                .foregroundColor(Color.white)
            }
            .offset(x: 90)
        }
        .offset(x: isShowingRequestButton ? -90 : 0)
        .padding(.vertical, 10)
        .animation(.spring(), value: isShowingRequestButton)
        .simultaneousGesture(
            DragGesture()
                .onChanged {
                    self.offset = $0.translation
                }
                .onEnded {
                    if $0.translation.width < -50 {
                        self.isShowingRequestButton = true
                    } else if $0.translation.width > 50 {
                        self.isShowingRequestButton = false
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
        ReturnNoticeCell(userInfo: User.dummyUser(), rentalItemInfo: ReturnInfo.dummyReturnInfo())
    }
}
