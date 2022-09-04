//
//  ManageMemberCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/04.
//

import SwiftUI

struct ManageMemberCell: View {
    let memberInfo: UserAndRoleData
    @Binding var selectedCellID: Int
    
    @ObservedObject var managementVM: ManagementViewModel
    @EnvironmentObject var groupVM: GroupViewModel
  
    var body: some View {
        
        
        CellWithTwoSlideButton(okMessage: "수정", cancelMessage: "삭제", cellID: memberInfo.id, selectedID: $selectedCellID) {
            
            HStack {
                
                //  MARK: 유저 프로필 추가 후 주석 제거
//                if let imageSource = noticeInfo.imagePath {
//                    KFImage(URL(string: imageSource)).onFailure { err in
//                        print(err.errorDescription ?? "KFImage err")
//                        }
//                        .resizable()
//                        .cornerRadius(15)
//                        .frame(width: 80, height: 80)
//                } else {
                    Image(AssetImages.DefaultGroupImage.rawValue)
                        .resizable()
                        .cornerRadius(15)
                        .frame(width: 80, height: 80)
//                }
                
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
        } okCallback: {
            print("okCallback")
        } cancelCallback: {
            print("cancelCallback")
        }
    }
}

//struct ManageMemberCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ManageMemberCell()
//    }
//}
