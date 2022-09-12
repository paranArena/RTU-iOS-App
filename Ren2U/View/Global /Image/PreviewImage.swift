//
//  SwiftUIView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/12.
//

import SwiftUI
import Kingfisher

struct PreviewImage: View {
    
    let imagePath: String?
    
    var body: some View {
        if let imagePath = imagePath {
            KFImage(URL(string: imagePath))
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(20)
                .clipped()
                .isHidden(hidden: imagePath.isEmpty)
        }
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        PreviewImage()
//    }
//}
