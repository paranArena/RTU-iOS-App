//
//  CouponPreviewCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/21.
//

import SwiftUI
import Kingfisher

struct CouponPreviewCell: View {
    
    let data: CouponPreviewData
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            CouponImage(url: data.imagePath, size: 60)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(data.name)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                
                Text("\(data.actDate) ~ \(data.expDate)")
                    .font(.custom(CustomFont.RobotoRegular.rawValue, size: 12))
                    .foregroundColor(.gray_868E96)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//struct CouponPreviewCell_Previews: PreviewProvider {
//    static var previews: some View {
//        CouponPreviewCell()
//    }
//}
