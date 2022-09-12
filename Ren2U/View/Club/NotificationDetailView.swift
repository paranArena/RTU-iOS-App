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
    
    
    let clubId: Int
    let notificationId: Int
    @StateObject var notificationVM: NotificationViewModel
    @Environment(\.isPresented) var isPresented
    
    init(clubId: Int, notificationId: Int) {
        self.clubId = clubId
        self.notificationId = notificationId
        _notificationVM = StateObject(wrappedValue: NotificationViewModel(clubId: clubId, notificationId: notificationId))
    }
    
    
    var body: some View {
        ScrollView {
            VStack {
                Text(notificationVM.notificationDetail.title)
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment: .bottom) {
                        SimpleLine(color: Color.gray_DEE2E6)
                    }
                
                HStack {
                    
                    Text("")
                        .frame(maxWidth: .infinity)
                    
                    Text(notificationVM.notificationDetail.clubName)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(Color.gray_868E96)
                        .frame(maxWidth: .infinity)
                    
                    Text("\(notificationVM.notificationDetail.updatedAt.toYMDformat())")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(Color.gray_868E96)
                        .frame(maxWidth: .infinity)
                }
                
//                if !notificationVM.notificationDetail.imagePath.isEmpty {
//                    KFImage(URL(string: notificationVM.notificationDetail.imagePath))
//                        .resizable()
//                        .scaledToFill()
//                        .frame(maxWidth: SCREEN_WIDTH - 40, maxHeight: SCREEN_WIDTH - 40)
//                        .cornerRadius(15)
//                        .clipped()
//                }
                RepresentativeImage(url: notificationVM.notificationDetail.imagePath)
                
                Text(notificationVM.notificationDetail.content)
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
    }
}

//struct NotificationDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotificationDetailView()
//    }
//}
