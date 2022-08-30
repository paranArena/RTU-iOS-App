//
//  GroupFavoriteCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import Kingfisher

struct FavoriteGroupCell: View {
    
    @EnvironmentObject var groupModel: GroupViewModel
    @Binding var info: ClubAndRoleData
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if let thumbnaulPath = info.club.thumbnailPath {
                KFImage(URL(string: thumbnaulPath))
                    .onFailure { err in
                        print(err.errorDescription ?? "KFImage Optional err")
                    }
                    .resizable()
                    .frame(width: 90, height: 90)
                    .cornerRadius(20)
            }
            
            Text(info.club.name)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .padding(.top, 5)
            
            Text(groupModel.makeFavoritesGroupTag(tags: info.club.hashtags))
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                .foregroundColor(.gray_ADB5BD)
                .multilineTextAlignment(.center)
                .padding(.top, 0)
                .lineLimit(2)
        }
    }
    
    @ViewBuilder
    private func LikeStar() -> some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "star")
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
        ContentView()
    }
}
