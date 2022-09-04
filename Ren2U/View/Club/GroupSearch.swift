//
//  Search.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/28.
//

import SwiftUI
import CoreAudio

struct GroupSearch: View {
    
    @EnvironmentObject var groupVM: ClubViewModel
    @Binding var search: String
    @Binding var tabSelection: Int
    
    @State private var groupInfo = [ClubAndRoleData]()
    @State private var isActive = false
    @State private var offset: CGFloat = .zero
    @State private var searchDelay = 0
    @State private var groupInfoIndex: Int?
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 10) {
            Text("검색된 그룹 목록")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .padding(.horizontal, 20)
            
            BounceControllScrollView(baseOffset: 100, offset: $offset) {
                VStack {
                    ForEach(groupInfo.indices, id: \.self) { i in
                        Button {
                            groupInfoIndex = i
                            isActive = true
                        } label: {
                            HorizontalClubCell(info: groupInfo[i])
                                .overlay(alignment: .trailing) {
                                    OverlayFinder(index: i)
                                }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            NavigationLink(isActive: $isActive) {
                if let index = groupInfoIndex {
                    GroupPage(tabSelection: $tabSelection, groupInfo: $groupInfo[index])
                }
            } label: { }
        }
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
    private func OverlayFinder(index: Int) -> some View {
        
        switch groupInfo[index].clubRole {
        case GroupRole.admin.rawValue, GroupRole.owner.rawValue, GroupRole.user.rawValue:
            JoindeClubOverlay()
        case GroupRole.wait.rawValue:
            ApplicatedGroupOverlay()
        case GroupRole.none.rawValue:
            NoneOverlay(index: index)
        default:
            Text("Group Role Err")
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
    private func NoneOverlay(index: Int) -> some View {
        Button {
            groupVM.requestClubJoinTask(cludId: groupInfo[index].id)
            groupInfo[index].clubRole = GroupRole.wait.rawValue
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
