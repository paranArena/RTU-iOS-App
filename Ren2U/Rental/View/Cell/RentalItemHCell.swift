//
//  RentalItemHCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/03.
//

import SwiftUI
import Kingfisher

struct RentalItemHCell: View {
    
    enum CancelOption {
        case `default`
        case none
        case yes
        case no
    }
    
    let rentalItemInfo: RentalItemInfo
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 5) {
                KFImage(URL(string: rentalItemInfo.imageSource)!)
                    .onFailure { err in
                        print(err.errorDescription ?? "KFImage Optional err")
                    }
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(20)
                
                VStack(alignment: .leading) {
                    Text(rentalItemInfo.itemName)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                    
                    Text("임시 그룹명")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(.Gray_ADB5BD)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 5) {
                    Text(self.itemStatusText)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                    Text("\(rentalItemInfo.remain)/\(rentalItemInfo.total)")
                        .font(.custom(CustomFont.RobotoMedium.rawValue, size: 16))
                }
                .foregroundColor(self.FGColor)
            }
            .padding(.horizontal, 10)
            Divider()
        }
    }
    
    @ViewBuilder
    private func RentalCancelButton() -> some View {
        Text("예약취소")
            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
            .foregroundColor(Color.Navy_1E2F97)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .overlay(Capsule().stroke(Color.Navy_1E2F97, lineWidth: 1))
    }
    
    private var itemStatusText: String {
        if rentalItemInfo.remain == 0 {
            return "대여불가"
        } else {
            return "남은 수량"
        }
    }
    
    private var FGColor: Color {
        if rentalItemInfo.remain == 0 {
            return Color.Red_EB1808
        } else {
            return Color.gray868E96
        }
    }
}

struct RentalItemHCell_Previews: PreviewProvider {
    static var previews: some View {
        RentalItemHCell(rentalItemInfo: .dummyRentalItem())
    }
}
