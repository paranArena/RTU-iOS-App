//
//  RepresentativeImage.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/12.
//

import SwiftUI
import Kingfisher

struct RepresentativeImage: View {
    
    let url: String?
    
    var body: some View {
        if let url = url {
            KFImage(URL(string: url))
                .resizable()
                .scaledToFill()
                .frame(width: SCREEN_WIDTH - 40, height: SCREEN_WIDTH - 40)
                .cornerRadius(20)
                .isHidden(hidden: url.isEmpty)
        } else {
            Image(AssetImages.DefaultGroupImage.rawValue)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
        }
    }
}
//
//struct RepresentativeImage_Previews: PreviewProvider {
//    static var previews: some View {
//        RepresentativeImage()
//    }
//}
