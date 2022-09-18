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
                    
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

//struct HGroupCell_Previews: PreviewProvider {
//    static var previews: some View {
//        JoinedGroupCell(info: GroupInfo.dummyGroupInfo())
//    }
//}
