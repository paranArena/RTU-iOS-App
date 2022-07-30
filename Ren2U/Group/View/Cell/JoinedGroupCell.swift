//
//  HGroupCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import Kingfisher

struct JoinedGroupCell: View {
    
    @EnvironmentObject var groupModel: GroupModel
    let info: GroupInfo
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 5) {
                KFImage(URL(string: info.groupDto.imageSource)!)
                    .onFailure { err in
                        print(err.errorDescription ?? "KFImage Optional err")
                    }
                    .resizable()
                    .frame(width: 90, height: 90)
                    .cornerRadius(20)
                
                VStack(alignment: .leading) {
                    Text(info.groupDto.groupName)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                    
                    Text(groupModel.makeFavoritesGroupTag(tags: info.groupDto.tags))
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(.Gray_ADB5BD)
                        .lineLimit(1)
                }
            }
            
            .padding(.horizontal, 20)
            
            Divider()
        }
    }
}

struct HGroupCell_Previews: PreviewProvider {
    static var previews: some View {
        JoinedGroupCell(info: GroupInfo.dummyGroup())
    }
}
