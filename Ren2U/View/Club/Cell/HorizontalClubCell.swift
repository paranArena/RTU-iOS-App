//
//  HGroupCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import Kingfisher

struct HorizontalClubCell: View {
    
    let clubData: ClubAndRoleData
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 5) {
                if let thumnnailPath = clubData.thumbnailPath {
                    KFImage(URL(string: thumnnailPath))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .cornerRadius(20)
                } else {
                    Image(AssetImages.DefaultGroupImage.rawValue)
                        .frame(width: 90, height: 90)
                        .cornerRadius(20)
                }
                
                
                VStack(alignment: .leading) {
                    Text(clubData.name)
                        .lineLimit(1)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(clubData.oneLineHashtag)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(.gray_ADB5BD)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
//                    HStack(spacing: 0) {
//                        ForEach(info.hashtags.indices, id: \.self) { i in
//                            Text("#\(info.hashtags[i]) ")
//                                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
//                                .foregroundColor(.gray_ADB5BD)
//                                .lineLimit(0)
//                        }
//                    }
//                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 10)
            .padding(.horizontal, 20)
        }
        .frame(maxHeight: 110)
    }
}

//struct HGroupCell_Previews: PreviewProvider {
//    static var previews: some View {
//        JoinedGroupCell(info: GroupInfo.dummyGroupInfo())
//    }
//}
