//
//  NoticeManagement.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import SwiftUI
import HidableTabView
import Introspect

struct NoticeManagementView: View {
    
    @EnvironmentObject var clubVM: ClubViewModel
    @ObservedObject var managementVM: ManagementViewModel
    
    @State private var selectedCellId = -1
    @State private var maxY: CGFloat = .zero
    @State var uiTabarController: UITabBarController?
    
    
    @State private var isShowingAlert = false
    @State private var selectedNotificationId = -1
    
    var body: some View {
        ScrollView {
            SwipeResettableView(selectedCellId: $selectedCellId) {
                Group {
                    VStack {
                        ForEach(managementVM.notices.indices, id: \.self) { i in
                            let noticeInfo = managementVM.notices[i]
                            let clubName = managementVM.clubData.name
                            ManageNoticeCell(noticeInfo: noticeInfo, groupName: clubName, selectedCellID: $selectedCellId, isShowingAlert: $isShowingAlert, managementVM: managementVM)
                        }
                    }
                    .isHidden(hidden: managementVM.notices.isEmpty)
                    
                    Text("등록된 공지사항이 없습니다.")
                        .font(.custom(CustomFont.NSKRBold.rawValue, size: 20))
                        .foregroundColor(.gray_DEE2E6)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .isHidden(hidden: !managementVM.notices.isEmpty)
                }
            }
        }
        .alert("", isPresented: $isShowingAlert) {
            Button("Cancel", role: .cancel) { }
            Button("OK") {
                Task {
                    await managementVM.deleteNotification(groupID: managementVM.clubData.id, notificationID: selectedCellId)
                    managementVM.searchNotificationsAll()
                }
            }
        } message: {
            Text("공지사항을 삭제하시겠습니까?")
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .bottomTrailing) {
            NavigationLink {
                CreateNoticeView(managementVM: managementVM, notificationVM: NotificationViewModel(clubId: managementVM.clubData.id))
            } label: {
                PlusCircleImage()
            }
        }
        .avoidSafeArea()
        .animation(.spring(), value: clubVM.clubNotice)
        .basicNavigationTitle(title: "공지사항")
        .frame(maxWidth: .infinity, maxHeight: SCREEN_HEIGHT - 100)
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
