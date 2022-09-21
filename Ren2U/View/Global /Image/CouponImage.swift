//
//  CouponImage.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/21.
//

import SwiftUI
import Kingfisher

struct CouponImage: View {
    
    let url: String
    
    var body: some View {
        
        Group {
            Image(AssetImages.DefaultCouponImage.rawValue)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .clipShape(RoundedCorner(radius: 15, corners: .allCorners))
                .isHidden(hidden: !url.isEmpty)
            
            
            KFImage(URL(string: url))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .clipShape(RoundedCorner(radius: 15, corners: .allCorners))
                .isHidden(hidden: url.isEmpty)
        }
    }
}

//struct CouponImage_Previews: PreviewProvider {
//    static var previews: some View {
//        CouponImage()
//    }
//}
