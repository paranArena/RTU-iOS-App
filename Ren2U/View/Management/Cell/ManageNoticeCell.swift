//
//  NoticeManageCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/02.
//

import SwiftUI
import Kingfisher

struct ManageNoticeCell: View {
    
    let noticeInfo: NotificationPreview
    let groupName: String
    @Binding var selectedCellID: Int
    @Binding var isShowingAlert: Bool
    @ObservedObject var managementVM: ManagementViewModel
    
    var body: some View {
        
        CellWithOneSlideButton(okMessage: "삭제", cellID: noticeInfo.id, selectedID: $selectedCellID) {
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
        } callback: {
            isShowingAlert = true
        }
    }
}

//struct NoticeManageCell_Previews: PreviewProvider {
//    static var previews: some View {
//        NoticeManageCell
//    }
//}
