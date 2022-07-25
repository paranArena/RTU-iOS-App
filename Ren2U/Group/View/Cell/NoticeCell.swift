//
//  NoticeCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/25.
//

import SwiftUI
import Kingfisher

struct NoticeCell: View {
    
    let noticeInfo: NoticeInfo
    let dateFormatter: () = DateFormatter().dateFormat = "yyyy-MM-dd"
    
    var body: some View {
        VStack {
            HStack {
                if let imageSource = noticeInfo.noticeDto.imageSource {
                    KFImage(URL(string: imageSource)).onFailure { err in
                            print(err.errorDescription)
                        }
                        .resizable()
                        .cornerRadius(15)
                        .frame(width: 80, height: 80)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(noticeInfo.noticeDto.title)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                    Text(noticeInfo.groupName)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(Color.Gray_ADB5BD)
                }
                
                Spacer()
                
                
                
                Image(systemName: "n.circle.fill")
                    .clipShape(Circle())
                    .foregroundColor(noticeInfo.isShown ? Color.BackgroundColor : Color.Gray_ADB5BD)
                    .background(noticeInfo.isShown ? Color.BackgroundColor : Color.Red_EB1808)
          
            }
            .padding(.horizontal)
            
            Divider()
        }
        .frame(height: 110)
    }
}

//struct NoticeCell_Previews: PreviewProvider {
//    static var previews: some View {
//        NoticeCell(noti)
//    }
//}
