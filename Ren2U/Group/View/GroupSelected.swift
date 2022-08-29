//
//  GroupSelected.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

struct GroupSelected: View {
    
    @EnvironmentObject var groupModel: GroupViewModel
    @State private var offset: CGFloat = 0 
    @Binding var tabSelection: Int
    let refreshThreshold: CGFloat
    
    @State private var isActive = false
    @State private var groupInfo: GroupInfo = GroupInfo.dummyGroup()
    
    var body: some View {
        RefreshScrollView(threshold: refreshThreshold) {
            VStack(alignment: .leading) {
                GroupFavorites()
                JoinedGroup()
            }
        }
        .background(
            NavigationLink(isActive: $isActive, destination: {
                GroupPage(tabSelection: $tabSelection, groupInfo: $groupInfo)
            }, label: { })
        )
        .refreshable {
            await groupModel.unlikesGroups()
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
                    ForEach(groupModel.joinedGroups.indices, id: \.self) { index in
                        let compareGroupId = groupModel.joinedGroups[index].groupDto.groupId
                        Button {
                            groupModel.joinedGroups[index].isActive.toggle()
                        } label: {
                            FavoriteGroupCell(info: $groupModel.joinedGroups[index])
                        }
                        .isHidden(hidden: !groupModel.likesGroupId.contains(where: { $0.groupId == compareGroupId }))
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.bottom, 30)
        .isHidden(hidden: groupModel.likesGroupId.isEmpty)
    }
    
    @ViewBuilder
    private func JoinedGroup() -> some View {
        VStack(alignment: .leading) {
            Text("가입된 그룹 목록")
                .foregroundColor(.LabelColor)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .padding(.horizontal, 20)
            VStack(alignment: .center, spacing: 0) {
                ForEach(groupModel.joinedGroups.indices, id: \.self) { index in
                    Button {
                        self.groupInfo = groupModel.joinedGroups[index]
                        self.isActive = true
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
