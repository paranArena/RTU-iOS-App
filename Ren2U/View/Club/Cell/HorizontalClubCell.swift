//
//  HGroupCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import Kingfisher

struct HorizontalClubCell: View {
    
    @EnvironmentObject var groupModel: ClubViewModel
    let info: ClubAndRoleData
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 5) {
                if let thumnnailPath = info.thumbnailPath {
                    KFImage(URL(string: thumnnailPath))
                        .onFailure { err in
                            print(err.errorDescription ?? "KFImage Optional err")
                        }
                        .resizable()
                        .frame(width: 90, height: 90)
                        .cornerRadius(20)
                } else {
                    Image(AssetImages.DefaultGroupImage.rawValue)
                        .frame(width: 90, height: 90)
                        .cornerRadius(20)
                }
                
                
                VStack(alignment: .leading) {
                    Text(info.name)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                    
                    HStack(spacing: 0) {
                        ForEach(info.hashtags.indices, id: \.self) { i in
                            Text("#\(info.hashtags[i]) ")
                                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                                .foregroundColor(.gray_ADB5BD)
                                .lineLimit(1)
                        }
                    }
                }
            }
            .padding(.top, 10)
            .padding(.horizontal, 20)
            
            Divider()
        }
    }
}

//struct HGroupCell_Previews: PreviewProvider {
//    static var previews: some View {
//        JoinedGroupCell(info: GroupInfo.dummyGroupInfo())
//    }
//}