//
//  GroupSelected.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

struct GroupSelected: View {
    
    @EnvironmentObject var groupVM: ClubViewModel
    @State private var offset: CGFloat = 0 
    @Binding var tabSelection: Int
    let refreshThreshold: CGFloat
    
    @State private var isActive = false
    @State private var groupInfo: ClubAndRoleData = ClubAndRoleData.dummyClubAndRoleData()
    
    var body: some View {
        RefreshableScrollView(threshold: refreshThreshold) {
            Group {
                VStack(alignment: .leading) {
    //                GroupFavorites()
                    JoinedGroup()
                }
                .isHidden(hidden: groupVM.joinedClubs.isEmpty)
                
                Text("가입된 그룹이 없습니다.")
                    .font(.custom(CustomFont.NSKRBold.rawValue, size: 20))
                    .foregroundColor(.gray_DEE2E6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .isHidden(hidden: !groupVM.joinedClubs.isEmpty)
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            NavigationLink(isActive: $isActive, destination: {
                ClubPage(tabSelection: $tabSelection, clubData: $groupInfo, clubActive: $isActive)
            }, label: { })
        )
        .refreshable {
            groupVM.getMyClubs()
            groupVM.getMyNotifications()
            await groupVM.getMyProducts()
        }
    }
//
//    @ViewBuilder
//    private func GroupFavorites() -> some View {
//        VStack(alignment: .leading) {
//            Text("즐겨찾기")
//                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
//                .padding(.horizontal, 20)
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 15) {
//                    ForEach(groupVM.joinedClubs.indices, id: \.self) { index in
//                        let compareGroupId = groupVM.joinedClubs[index].id
//                        Button {
//                            self.groupInfo = groupVM.joinedClubs[index]
//                            self.isActive = true
//                        } label: {
//                            FavoriteGroupCell(info: $groupVM.joinedClubs[index])
//                        }
//                        .isHidden(hidden: !groupVM.likesGroupId.contains(where: { Int($0.groupId)! == compareGroupId }))
//                    }
//                }
//                .padding(.horizontal, 20)
//            }
//        }
//        .padding(.bottom, 30)
//        .isHidden(hidden: groupVM.likesGroupId.isEmpty)
//    }
    
    @ViewBuilder
    private func JoinedGroup() -> some View {
        VStack(alignment: .leading) {
            Text("가입된 그룹 목록")
                .foregroundColor(.LabelColor)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .padding(.horizontal, 20)
            
            VStack(alignment: .center, spacing: 0) {
                ForEach(groupVM.joinedClubs.indices, id: \.self) { index in
                    Button {
                        self.groupInfo = groupVM.joinedClubs[index]
                        self.isActive = true
                    } label: {
                        HorizontalClubCell(info: groupVM.joinedClubs[index])
                    }
                    .padding(.bottom, 10)
                    
                    Divider()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}
//
//struct GroupSelected_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupSelected()
//    }
//}
