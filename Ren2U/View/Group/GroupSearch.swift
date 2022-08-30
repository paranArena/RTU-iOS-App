//
//  Search.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/28.
//

import SwiftUI

struct GroupSearch: View {
    
    @EnvironmentObject var groupVM: GroupViewModel
    @Binding var search: String
    @Binding var tabSelection: Int
    
    @State private var groupInfo = [ClubData]()
    @State private var isActive = false
    @State private var offset: CGFloat = .zero
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("검색된 그룹 목록")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .padding(.horizontal, 20)
            
            BounceControllScrollView(offset: $offset) {
                VStack {
                    ForEach(groupInfo, id: \.self) { searchCLubData in
                        Button {
                            print("???")
                            isActive = true
                        } label: {
                            HorizontalClubCell(info: ClubAndRoleData(id: 1, club: searchCLubData, role: ClubAndRoleData.GroupRole.owner.rawValue))
                                .overlay(alignment: .trailing) { OverlayFinder(clubId: searchCLubData.id) }
                        }
                    }
                }
            }
        }
//        .background {
//            NavigationLink(isActive: $isActive) {
//                GroupPage(tabSelection: $tabSelection)
//            } label: { }
//        }
        .onAppear {
            Task {
                groupInfo = await groupVM.searchClubsAll()
            }
        }
        .onChange(of: search) { newValue in
            
        }
    }
    
    @ViewBuilder
    private func OverlayFinder(clubId: Int) -> some View {
        
        if groupVM.joinedClubs.contains(where: { $0.club.id == clubId }) {
            JoindeClubOverlay()
        } else {
            NoneOverlay(clubId: clubId)
        }
    }
    
    @ViewBuilder
    private func JoindeClubOverlay() -> some View {
        Text("가입된 그룹")
            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
            .foregroundColor(Color.gray_868E96)
            .padding()
    }
    
    @ViewBuilder
    private func ApplicatedGroupOverlay() -> some View {
        HStack {
            Spacer()
            Text("요청완료")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                .foregroundColor(Color.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Capsule().fill(Color.navy_1E2F97))
        }
        .padding()
    }
    
    @ViewBuilder
    private func NoneOverlay(clubId: Int) -> some View {
        Button {
            groupVM.requestClubJoinTask(cludId: clubId)
        } label: {
            Text("가입 요청")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                .foregroundColor(Color.navy_1E2F97)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .overlay(
                    Capsule()
                        .strokeBorder(Color.navy_1E2F97, lineWidth: 1)
                )
        }
        .padding()
    }
}


//struct Search_Previews: PreviewProvider {
//    static var previews: some View {
//        Search()
//    }
//}