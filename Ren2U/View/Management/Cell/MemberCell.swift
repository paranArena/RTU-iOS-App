//
//  MemberCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/22.
//

import SwiftUI

struct MemberCell: View {
    
    let memberInfo: MemberPreviewData
    
    var body: some View {
        HStack {

            Image(AssetImages.DefaultGroupImage.rawValue)
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 0) {
                Text(memberInfo.name)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                Text(memberInfo.major)
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                    .foregroundColor(Color.gray_ADB5BD)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.BackgroundColor)
    }
}

//struct MemberCell_Previews: PreviewProvider {
//    static var previews: some View {
//        MemberCell()
//    }
//}
