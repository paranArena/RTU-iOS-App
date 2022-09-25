//
//  MyCouponPreviewCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/23.
//

import SwiftUI

struct MyCouponPreviewCell: View {
    
    let data: CouponPreviewData
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            CouponImage(url: data.imagePath, size: 60)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(data.clubName)
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                
                Text(data.name)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                
                Text("\(data.actDate) ~ \(data.expDate)")
                    .font(.custom(CustomFont.RobotoRegular.rawValue, size: 12))
                    .foregroundColor(.gray_868E96)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Text("미사용")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                .foregroundColor(Color.navy_1E2F97)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.BackgroundColor)
    }
}

//struct MyCouponPreviewCell_Previews: PreviewProvider {
//    static var previews: some View {
//        MyCouponPreviewCell()
//    }
//}
