//
//  RentalItemHCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/03.
//

import SwiftUI
import Kingfisher

struct RentalItemHCell: View {
    
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
                    Text("남은 수량")
                        .foregroundColor(Color.Gray_ADB5BD)
                    Text("\(rentalItemInfo.remain)/\(rentalItemInfo.total)")
                        .foregroundColor(Color.Gray_ADB5BD)
                }
            }
            .padding(.horizontal, 10)
            
            Divider()
        }
    }
}

struct RentalItemHCell_Previews: PreviewProvider {
    static var previews: some View {
        RentalItemHCell(rentalItemInfo: .dummyRentalItem())
    }
}
