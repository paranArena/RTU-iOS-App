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
                    ForEach(0..<5, id: \.self) { index in
                        NavigationLink {
                            GroupPage(tabSelection: $tabSelection, groupInfo: GroupInfo.dummyGroup())
                        } label: {
                            FavoriteGroupCell(info: GroupInfo.dummyGroup())
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
                ForEach(groupModel.joinedGroups) { group in
                    NavigationLink {
                        GroupPage(tabSelection: $tabSelection, groupInfo: group)
                    } label: {
                        JoinedGroupCell(info: group)
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
