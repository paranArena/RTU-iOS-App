//
//  NoticeManageCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/02.
//

import SwiftUI

struct ManageNoticeCell: View {
    
    let noticeInfo: NoticeData
    let groupName: String
    let groupID: Int
    @Binding var selectedCellID: Int
    
    @ObservedObject var managementVM: ManagementViewModel
    @EnvironmentObject var groupVM: GroupViewModel
  
    var body: some View {
        
        
        CellWithTwoSlideButton(okMessage: "비공개", cancelMessage: "삭제", cellID: noticeInfo.id, selectedID: $selectedCellID) {
            //  MARK: 공지사항 이미지 활성 화 이후 아래 주석 제거
//                if let imageSource = noticeInfo.noticeDto.imageSource {
//                    KFImage(URL(string: imageSource)).onFailure { err in
//                        print(err.errorDescription ?? "KFImage err")
//                        }
//                        .resizable()
//                        .cornerRadius(15)
//                        .frame(width: 80, height: 80)
//                }
            HStack {
                Image(AssetImages.DefaultGroupImage.rawValue)
                    .resizable()
                    .cornerRadius(15)
                    .frame(width: 80, height: 80)
                
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
                
                Text("\(noticeInfo.updatedAt)")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                    .foregroundColor(Color.gray_ADB5BD)
            }
        } okCallback: {
            print("비공개 임시 출력")
            print("cellID: \(noticeInfo.id)")
            print("selectedID: \(selectedCellID)")
        } cancelCallback: {
            managementVM.deleteNotificationTask(groupID: groupID, notificationID: noticeInfo.id)
            let index = groupVM.notices[groupID]?.firstIndex(where: { noticeData in
                noticeData.id == noticeInfo.id
            })
            groupVM.notices[groupID]?.remove(at: index!)
        }
    }
    
    func getDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let result = dateFormatter.string(from: date)
        return result
    }
}

//struct NoticeManageCell_Previews: PreviewProvider {
//    static var previews: some View {
//        NoticeManageCell
//    }
//}