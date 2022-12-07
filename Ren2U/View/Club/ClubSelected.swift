//
//  GroupSelected.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

struct ClubSelected: View {
    
    @EnvironmentObject var groupVM: ClubViewModel
    @State private var offset: CGFloat = 0 
    @Binding var tabSelection: Int
    let refreshThreshold: CGFloat
    
    @State private var isActive = false
    @State private var clubData: ClubAndRoleData = ClubAndRoleData.dummyClubAndRoleData()
    
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
                
                NavigationLink(isActive: $isActive, destination: {
                    ClubPage(tabSelection: $tabSelection, clubData: $clubData, clubActive: $isActive)
                }, label: { })
            }
        }
        .frame(maxWidth: .infinity)
        .refreshable {
            groupVM.getMyClubs()
            groupVM.getMyNotifications()
            await groupVM.getMyProducts()
        }
    }
    
    @ViewBuilder
    private func JoinedGroup() -> some View {
        VStack(alignment: .leading) {
            Text("가입된 그룹 목록")
                .foregroundColor(.LabelColor)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .padding(.horizontal, 20)
            
            VStack(alignment: .center, spacing: 10) {
                ForEach(groupVM.joinedClubs.indices, id: \.self) { index in
                    Button {
                        self.clubData = groupVM.joinedClubs[index]
                        self.isActive = true
                    } label: {
                        HorizontalClubCell(clubData: groupVM.joinedClubs[index])
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
