//
//  NoticeCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/25.
//

import SwiftUI
import Kingfisher

struct ReportableNoticeHCell: View {
    
    
    let noticeInfo: NotificationPreviewData
    let groupName: String
    
    @EnvironmentObject var clubVM: ClubViewModel
    @Binding var selectedId: Int
    
    @Binding var isShowingAlert: Bool
    @Binding var message: Text
    @Binding var callback: () async -> ()
    
    var body: some View {
        
        CellWithOneSlideButton(okMessage: "신고", cellID: noticeInfo.id, selectedID: $selectedId) {
            VStack {
                HStack {
                    
                    if let imagePath = noticeInfo.imagePath {
                        KFImage(URL(string: imagePath)).onFailure { err in
                            print(err.errorDescription ?? "KFImage err")
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .cornerRadius(15)
                            .isHidden(hidden: imagePath.isEmpty)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                        Text(noticeInfo.title)
                            .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                        Text(groupName)
                            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                            .foregroundColor(Color.gray_ADB5BD)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Text("\(noticeInfo.updateText)")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(Color.gray_ADB5BD)
              
                }
            }
        } callback: {
            isShowingAlert = true
            message = Text(NotificationPreviewData.reportTitle)
            callback = { clubVM.reportNotification(clubId: noticeInfo.clubId, notificationId: noticeInfo.id) }
        }

    }
}

//struct NoticeCell_Previews: PreviewProvider {
//    static var previews: some View {
//        NoticeCell(noti)
//    }
//}
