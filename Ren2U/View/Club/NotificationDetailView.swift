//
//  NotificationDetailView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/11.
//

import SwiftUI
import Kingfisher
import HidableTabView

struct NotificationDetailView: View {
    
    @StateObject var notificationVM: NotificationViewModel
    @Environment(\.isPresented) var isPresented
    
    // user mode
    init(clubId: Int, notificationId: Int, clubNotificaitonService: ClubNotificationServiceEnable) {
        self._notificationVM = StateObject(wrappedValue: NotificationViewModel(clubId: clubId, notificationId: notificationId,
            clubNotificationService: clubNotificaitonService))
    }
    
    
    var body: some View {
        ScrollView {
            VStack {
                Text(notificationVM.notificationDetailData.title)
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment: .bottom) {
                        SimpleLine(color: Color.gray_DEE2E6)
                    }
                
                Info()
                
                RepresentativeImage(url: notificationVM.notificationDetailData.imagePath)
                
                Text(notificationVM.notificationDetailData.content)
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
            }
        }
        .isHidden(hidden: notificationVM.isLoading)
        .avoidSafeArea()
        .controllTabbar(isPresented)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 20)
        .basicNavigationTitle(title: "공지사항")
        .alert(notificationVM.oneButtonAlert.title, isPresented: $notificationVM.oneButtonAlert.isPresented) {
            OneButtonAlert.noActionButton
        } message: {
            notificationVM.oneButtonAlert.message
        }

    }
    
    @ViewBuilder
    private func Info() -> some View {
        HStack {
            
            Text("")
                .frame(maxWidth: .infinity)
            
            Text(notificationVM.notificationDetailData.clubName)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                .foregroundColor(Color.gray_868E96)
                .frame(maxWidth: .infinity)
            
            Text("\(notificationVM.notificationDetailData.updatedAt.toYMDformat())")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                .foregroundColor(Color.gray_868E96)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        
    }
}

struct NotificationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationDetailView(clubId: -1, notificationId: -1, clubNotificaitonService: MockupClubNotificationService())
    }
}
