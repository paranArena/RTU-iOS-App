//
//  ClubNotifications.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/12.
//

import SwiftUI

struct ClubNotifications: View {
    
    @EnvironmentObject var clubVM: ClubViewModel
    
    @State private var selectedCellId = -1
    @State private var alert = Alert()
    
    var body: some View {
        RefreshableScrollView(threshold: 20) {
            Group {
                SwipeResettableView(selectedCellId: $selectedCellId) {
                    VStack {
                        ForEach(clubVM.clubNotice.indices, id: \.self) { i in
                            let groupName = clubVM.getGroupNameByGroupId(groupId: clubVM.clubNotice[i].clubId)
                            NavigationLink {
                                NotificationDetailView(clubId: clubVM.clubNotice[i].clubId, notificationId: clubVM.clubNotice[i].id)
                            } label: {
                                ReportableNoticeHCell(noticeInfo: clubVM.clubNotice[i], groupName: groupName, selectedId: $selectedCellId, isShowingAlert: $alert.isPresented, message: $alert.message, callback: $alert.callback)
                            }
                        }
                    }
                }
                .isHidden(hidden: clubVM.clubNotice.isEmpty)
                
                Text("공지사항이 없습니다.")
                    .font(.custom(CustomFont.NSKRBold.rawValue, size: 20))
                    .foregroundColor(.gray_DEE2E6)
                    .padding(.horizontal)
                    .isHidden(hidden: !clubVM.clubNotice.isEmpty)
            }
        }
        .alert("", isPresented: $alert.isPresented) {
            Button("취소", role: .cancel) {}
            Button("확인") { Task { await alert.callback() }}
        } message: {
            alert.message
        }
        .basicNavigationTitle(title: "공지사항")
        .overlay(alignment: .bottom) {
            ShadowRectangle()
        }
    }
}

//struct ClubNotifications_Previews: PreviewProvider {
//    static var previews: some View {
//        ClubNotifications()
//    }
//}
