//
//  GroupFavoriteCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import Kingfisher

struct FavoriteGroupCell: View {
    
    @EnvironmentObject var groupModel: GroupModel
    let info: GroupInfo
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            KFImage(URL(string: info.imageSource)!)
                .onFailure { err in
                    print(err.errorDescription)
                }
                .resizable()
                .frame(width: 140, height: 140)
                .cornerRadius(20)
                .overlay { LikeStar() }
            
            Text(info.groupName)
                .font(.custom(CustomFont.NotoSansKR.rawValue, size: 16))
                .padding(.top, 5)
            
            Text(groupModel.makeFavoritesGroupTag(tags: info.tags))
                .font(.custom(CustomFont.NotoSansKR.rawValue, size: 12))
                .foregroundColor(.Gray_ADB5BD)
                .multilineTextAlignment(.leading)
                .padding(.top, 0)
                .lineLimit(2)
        }
    }
    
    @ViewBuilder
    func LikeStar() -> some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    print("Star clicked!")
                } label: {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                .padding(5)

            }
            Spacer()
        }
    }
}

struct GroupFavoriteCell_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteGroupCell(info: GroupInfo.dummyGroup())
    }
}
