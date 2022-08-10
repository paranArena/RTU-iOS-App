//
//  GroupSelected.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

struct GroupSelected: View {
    
    @EnvironmentObject var groupModel: GroupViewModel
    @Binding var tabSelection: Int
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            RefreshableView {
                VStack(alignment: .leading) {
                    GroupFavorites()
                    JoinedGroup()
                        .padding(.top, 30)
                }
            }
        }
    }
    
    @ViewBuilder
    private func GroupFavorites() -> some View {
        VStack(alignment: .leading) {
            Text("즐겨찾기")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .padding(.horizontal, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(groupModel.likesGroups.indices, id: \.self) { index in
                        NavigationLink {
                            GroupPage(tabSelection: $tabSelection, groupInfo: $groupModel.likesGroups[index])
                        } label: {
                            FavoriteGroupCell(info: $groupModel.likesGroups[index])
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    @ViewBuilder
    private func JoinedGroup() -> some View {
        VStack(alignment: .leading) {
            Text("가입된 그룹 목록")
                .foregroundColor(.LabelColor)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .padding(.horizontal, 20)
            VStack {
                ForEach(groupModel.joinedGroups.indices, id: \.self) { index in
                    NavigationLink {
                        GroupPage(tabSelection: $tabSelection, groupInfo: $groupModel.joinedGroups[index])
                    } label: {
                        JoinedGroupCell(info: groupModel.joinedGroups[index])
                    }
                }
            }
        }
    }
    
}
//
//struct GroupSelected_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupSelected()
//    }
//}
