//
//  NoticeManagement.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import SwiftUI
import HidableTabView
import Introspect

struct NoticeManagement: View {
    
    @EnvironmentObject var clubVM: ClubViewModel
    @ObservedObject var managementVM: ManagementViewModel
    
    @State private var selectedCellId = -1
    @State private var maxY: CGFloat = .zero
    
    var body: some View {
        SlideResettableScrollView(selectedCellId: $selectedCellId) {
            VStack {
                let clubId = managementVM.clubData.id
                ForEach(clubVM.notices[clubId]?.indices ?? 0..<0, id: \.self) { i in
                    let noticeInfo = clubVM.notices[clubId]![i]
                    let groupName = clubVM.getGroupNameByGroupId(groupId: clubId)
                    HStack {
                        ManageNoticeCell(noticeInfo: noticeInfo, groupName: groupName, groupID: clubId, selectedCellID: $selectedCellId, managementVM: managementVM)
                    }
                }
            }
        }
        .animation(.spring(), value: clubVM.notices[managementVM.clubData.id])
        .basicNavigationTitle(title: "공지사항")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink {
                        CreateNoticeView(managementVM: managementVM)
                    } label: {
                        PlusCircle()
                    }
                    .padding(.bottom, SAFE_AREA_BOTTOM_HEIGHT)
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .onAppear {
            UITabBar.hideTabBar()
        }
    }
}

//struct NoticeManagement_Previews: PreviewProvider {
//    static var previews: some View {
//        NoticeManagement()
//    }
//}
