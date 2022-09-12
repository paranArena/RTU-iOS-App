//
//  Group.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import HidableTabView

struct ClubTab: View {
    
    @StateObject private var vm = ViewModel()
    @Binding var tabSelection: Int 
    @EnvironmentObject var clubVM: ClubViewModel
    @State private var offset: CGFloat = .zero
    let spacing: CGFloat = 10
    
    @State private var isShowingAlert = false
    @State private var selectedId = -1
    @State private var altertTitle = "" 
    @State private var callback: () -> () = { print("callback")}
    
    
    @State private var isActiveNotificationDetail = false
    @State private var selectedNotificationLinkIndex = 0
    var body: some View {
        // horizontal padding 주지 말것! 즐겨찾기 이미지를 좌우 폭에 못 맞추게 된다.
        
        VStack(alignment: .center, spacing: spacing) {
            
            SearchBar(text: $vm.searchText, isFoucsed: $vm.isSearchBarFocused)
                .padding(.horizontal, 20)

            ClubSearch(search: $vm.searchText, tabSelection: $tabSelection)
                .padding(.bottom, -10)
                .isHidden(hidden: !vm.isSearchBarFocused || vm.groupSelection == .notice)
            
            Group {
                GroupSelectionButton()
                    .isHidden(hidden: vm.isSearchBarFocused)
                    .background(GeometryReader { gp -> Color in
                        offset = gp.frame(in: .global).maxY + spacing
                        return Color.clear
                    })
                
                ZStack {
                    GroupSelected(tabSelection: $tabSelection, refreshThreshold: offset)
                        .isHidden(hidden: vm.isSearchBarFocused)
                        .overlay(CreateGroupButton())
                        .offset(x: vm.groupSelection == Selection.group ? 0 : -SCREEN_WIDTH)
                    NoticeSelected()
                        .offset(x: vm.groupSelection == Selection.notice ? 0 : SCREEN_WIDTH)
                        .isHidden(hidden: vm.isSearchBarFocused && vm.groupSelection == .group)
                }
                .padding(.bottom, -10)
            }
        }
        .background(
            NavigationLink(isActive: $isActiveNotificationDetail , destination: {
                let clubId = clubVM.notices[selectedNotificationLinkIndex].clubId
                let notificationId = clubVM.notices[selectedNotificationLinkIndex].id
                NotificationDetailView(clubId: clubId, notificationId: notificationId)
            }, label: { })
        )
        .overlay(ShadowRectangle())
        .showTabBar(animated: false)
        .navigationTitle("")
        .navigationBarHidden(true)
        .animation(.spring(), value: vm.groupSelection)
        .alert(altertTitle, isPresented: $isShowingAlert) {
            Button("아니요", role: .cancel) {}
            Button("예") { callback() }
        }
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
                    ClubProfile(viewModel: ClubProfile.ViewModel(mode: .post))
                } label: {
                    PlusCircle()
                }
            }
        }
    }
    
    @ViewBuilder
    private func NoticeSelected() -> some View {
        RefreshableScrollView(threshold: offset) {
            Group {
                VStack {       
                    ForEach(clubVM.notices.indices, id: \.self) { j in
                        let title = clubVM.notices[j].title
                        let groupName = clubVM.getGroupNameByGroupId(groupId: clubVM.notices[j].clubId)
                        Button {
                            isActiveNotificationDetail = true
                            selectedNotificationLinkIndex = j
                        } label: {
                            ReportableNoticeHCell(noticeInfo: clubVM.notices[j], groupName: groupName, selectedId: $selectedId, isShowingAlert: $isShowingAlert, title: $altertTitle, callback: $callback)
                                .isHidden(hidden: vm.isSearchBarFocused && !vm.searchText.isEmpty && !groupName.contains(vm.searchText) && !title.contains(vm.searchText))
                        }
                    }
                }
            }
        }
        .refreshable {
            clubVM.getMyClubs()
            clubVM.getMyNotifications()
            await clubVM.getMyProducts()
        }
    }
}



//struct Group_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupMain()
//    }
//}
