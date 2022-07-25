//
//  RentalItemCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/25.
//

import SwiftUI
import Kingfisher

struct RentalItemCell: View {
    
    let rentalItem: RentalItemInfo
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            KFImage(URL(string: rentalItem.imageSource)).onFailure { err in
                print(err.errorDescription ?? "")
                }
                .resizable()
                .cornerRadius(15)
                .frame(width: 110, height: 110)
            
            Text(rentalItem.itemName)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
            
            Text("남은 수량 \(rentalItem.remain)/\(rentalItem.total)")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                .foregroundColor(Color.Gray_495057)

            
        }
    }
}

struct RentalItemCell_Previews: PreviewProvider {
    static var previews: some View {
        RentalItemCell(rentalItem: RentalItemInfo.dummyRentalItem())
    }
}
