//
//  NoticeManagement.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import SwiftUI
import HidableTabView

struct NoticeManagement: View {
    
    @EnvironmentObject var groupVM: GroupViewModel
    @ObservedObject var managementVM: ManagementViewModel
    
    var body: some View {
        ScrollView {
            ForEach(groupVM.notices[managementVM.groupId]?.indices ?? 0..<0, id: \.self) { i in
                NoticeCell(noticeInfo: groupVM.notices[managementVM.groupId]![i], groupName: groupVM.getGroupNameByGroupId(groupId: managementVM.groupId))
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
            print(managementVM.groupId)
            
        }
    }
}

//struct NoticeManagement_Previews: PreviewProvider {
//    static var previews: some View {
//        NoticeManagement()
//    }
//}
