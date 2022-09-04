//
//  Group.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import HidableTabView

struct GroupTab: View {
    
    @StateObject private var vm = ViewModel()
    @Binding var tabSelection: Int 
    @EnvironmentObject var groupViewModel: GroupViewModel
    @State private var offset: CGFloat = .zero
    let spacing: CGFloat = 10
    
    var body: some View {
        // horizontal padding 주지 말것! 즐겨찾기 이미지를 좌우 폭에 못 맞추게 된다.
        
        VStack(alignment: .center, spacing: spacing) {
            
            SearchBar(text: $vm.searchText, isFoucsed: $vm.isSearchBarFocused)
                .padding(.horizontal, 20)

            GroupSearch(search: $vm.searchText, tabSelection: $tabSelection)
                .padding(.bottom, -10)
                .isHidden(hidden: !vm.isSearchBarFocused)
            
            Group {
                GroupSelectionButton()
                    .background(GeometryReader { gp -> Color in
                        offset = gp.frame(in: .global).maxY + spacing
                        return Color.clear
                    })
                
                ZStack {
                    GroupSelected(tabSelection: $tabSelection, refreshThreshold: offset)
                        .overlay(CreateGroupButton())
                        .offset(x: vm.groupSelection == Selection.group ? 0 : -SCREEN_WIDTH)
                    NoticeSelected()
                        .offset(x: vm.groupSelection == Selection.notice ? 0 : SCREEN_WIDTH)
                }
                .padding(.bottom, -10)
            }
            .isHidden(hidden: vm.isSearchBarFocused)
        }
        .overlay(ShadowRectangle())
        .showTabBar(animated: false)
        .navigationTitle("")
        .navigationBarHidden(true)
        .animation(.spring(), value: vm.groupSelection)
    }
    
    @ViewBuilder
    private func GroupSelectionButton() -> some View {
        HStack {
            ForEach(Selection.allCases, id: \.rawValue) {  option in
                Button {
                    self.vm.groupSelection  = option
                } label: {
                    Text(option.title)
                        .frame(maxWidth: .infinity)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 18))
                        .foregroundColor(self.vm.groupSelection == option ? .navy_1E2F97 : .gray_ADB5BD)
                }

            }
        }
    }
    
    @ViewBuilder
    private func CreateGroupButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink {
                    CreateGroupView()
                } label: {
                    PlusCircle()
                }
            }
        }
    }
    
    @ViewBuilder
    private func NoticeSelected() -> some View {
        RefreshableScrollView(threshold: offset) {
            VStack {
                ForEach(groupViewModel.joinedClubs.indices, id: \.self) { i in
                    let id = groupViewModel.joinedClubs[i].id
                    ForEach(groupViewModel.notices[id]?.indices ?? 0..<0, id: \.self) { j in
                        NoticeCell(noticeInfo: groupViewModel.notices[id]![j], groupName: groupViewModel.getGroupNameByGroupId(groupId: id))
                    }
                }
            }
        }
        .refreshable {
            groupViewModel.getMyClubsTask()
        }
    }
}



//struct Group_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupMain()
//    }
//}
