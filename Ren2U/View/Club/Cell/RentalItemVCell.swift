//
//  RentalItemCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/25.
//

import SwiftUI
import Kingfisher

struct RentalItemVCell: View {
    
    let rentalItem: ProductResponseData
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            KFImage(URL(string: rentalItem.imagePath ?? "")).onFailure { err in
                print(err.errorDescription ?? "")
                }
                .resizable()
                .scaledToFill()
                .frame(width: 110, height: 110)
                .cornerRadius(15)
            
            Text(rentalItem.name)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
            
            Text("남은 수량 \(rentalItem.left)/\(rentalItem.max)")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                .foregroundColor(Color.gray_495057)

            
        }
    }
}

//struct RentalItemCell_Previews: PreviewProvider {
//    static var previews: some View {
//        RentalItemVCell(rentalItem: RentalItemInfo.dummyRentalItem())
//    }
//}
