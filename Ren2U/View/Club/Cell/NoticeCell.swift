//
//  NoticeHCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/10.
//

import SwiftUI
import Kingfisher

struct NoticeCell: View {
    

    let noticeInfo: NoticeCellData
    let groupName: String
    
    var body: some View {
        
        VStack {
            HStack {
                KFImage(URL(string: noticeInfo.imagePath)).onFailure { err in
                    print(err.errorDescription ?? "KFImage err")
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(15)
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
                
                Text("\(noticeInfo.updateText)")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                    .foregroundColor(Color.gray_ADB5BD)
          
            }
            .padding(.horizontal)
            
            Divider()
        }
        .frame(height: 110)
    }
}


//struct NoticeHCell_Previews: PreviewProvider {
//    static var previews: some View {
//        NoticeHCell()
//    }
//}
