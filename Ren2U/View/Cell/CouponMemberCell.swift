//
//  CouponMemberCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/23.
//

import SwiftUI

struct CouponMemberCell: View {
    

    let data: MemberPreviewDto
 
    
    var body: some View {
        HStack {
            Image(AssetImages.DefaultGroupImage.rawValue)
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 0) {
                Text(data.name)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                
                HStack(alignment: .center, spacing: 5) {
                    Text(data.major)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(Color.gray_ADB5BD)
                    
                    Text(data.year)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(Color.gray_ADB5BD)
                }
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.BackgroundColor)
    }
}

//struct CouponMemberCell_Previews: PreviewProvider {
//    static var previews: some View {
//        CouponMemberCell()
//    }
//}
