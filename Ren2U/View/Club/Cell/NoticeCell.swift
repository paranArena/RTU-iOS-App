//
//  NoticeCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/25.
//

import SwiftUI
import Kingfisher

struct NoticeCell: View {
    
    let noticeInfo: NoticeData
    let groupName: String 
    
    var body: some View {
        VStack {
            HStack {
                KFImage(URL(string: noticeInfo.imagePath)).onFailure { err in
                    print(err.errorDescription ?? "KFImage err")
                    }
                    .resizable()
                    .cornerRadius(15)
                    .frame(width: 80, height: 80)
                    .isHidden(hidden: noticeInfo.imagePath.isEmpty)
                
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
                
//                Image(systemName: "n.circle.fill")
//                    .foregroundStyle(noticeInfo.isShown ? Color.BackgroundColor : Color.red_EB1808,
//                                     noticeInfo.isShown ? Color.BackgroundColor : Color.gray_ADB5BD)
          
            }
            .padding(.horizontal)
            
            Divider()
        }
        .frame(height: 110)
    }
    
    func getDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let result = dateFormatter.string(from: date)
        return result
    }
}

//struct NoticeCell_Previews: PreviewProvider {
//    static var previews: some View {
//        NoticeCell(noti)
//    }
//}
