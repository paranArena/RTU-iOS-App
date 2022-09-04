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
    @State private var searchDelay = 0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("검색된 그룹 목록")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .padding(.horizontal, 20)
            
            BounceControllScrollView(baseOffset: 100, offset: $offset) {
                VStack {
                    ForEach(groupInfo, id: \.self) { searchCLubData in
                        Button {
                            print("???")
                            isActive = true
                        } label: {
                            //  MARK: API 변경 후 임시코드. 수정 필요
                            HorizontalClubCell(info: ClubAndRoleData.dummyClubAndRoleData())
                                .overlay(alignment: .trailing) { OverlayFinder(clubId: searchCLubData.id) }
                        }
                    }
                }
            }
        }
        
        .frame(maxWidth: .infinity, alignment: .leading)
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
            self.searchDelay = 0
        }
        .onReceive(timer) { _ in
            searchDelay += 1
            if searchDelay == 10 && !search.isEmpty {
                Task {
                    groupInfo = await groupVM.searchClubsWithHashTag(hashTag: search)
                    if let groupSearchedByName = await groupVM.searchClubsWithName(groupName: search) {
                        groupInfo.append(groupSearchedByName)
                    }
                }
            }
        }
        
    }
    
    @ViewBuilder
    private func OverlayFinder(clubId: Int) -> some View {
        
        if groupVM.joinedClubs.contains(where: { $0.id == clubId }) {
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
