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
    
    @EnvironmentObject var groupVM: ClubViewModel
    @ObservedObject var managementVM: ManagementViewModel
    
    @State private var selectedCellId = -1
    @State private var maxY: CGFloat = .zero
    
    var body: some View {
        SlideResettableScrollView(selectedCellId: $selectedCellId) {
            VStack {
                ForEach(groupVM.notices[managementVM.clubData.id]?.indices ?? 0..<0, id: \.self) { i in
                    HStack {
                        ManageNoticeCell(noticeInfo: groupVM.notices[managementVM.clubData.id]![i], groupName: groupVM.getGroupNameByGroupId(groupId: managementVM.clubData.id), groupID: managementVM.clubData.id, selectedCellID: $selectedCellId, managementVM: managementVM)
                    }
                }
            }
        }
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
