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
    @Binding var info: GroupInfo
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            KFImage(URL(string: info.groupDto.imageSource)!)
                .onFailure { err in
                    print(err.errorDescription ?? "KFImage err")
                }
                .resizable()
                .frame(width: 120, height: 120)
                .cornerRadius(20)
                .overlay { LikeStar() }
            
            Text(info.groupDto.groupName)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .padding(.top, 5)
            
            Text(groupModel.makeFavoritesGroupTag(tags: info.groupDto.tags))
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
                    info.didLike.toggle()
                } label: {
                    Image(systemName: info.didLike ? "star.fill" : "star")
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