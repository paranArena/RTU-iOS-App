//
//  ManageMemberCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/04.
//

import SwiftUI

struct ManageMemberCell: View {
    
    let memberInfo: MemberPreviewData
    @Binding var selectedCellID: Int
    
    @ObservedObject var managementVM: ManagementViewModel
  
    var body: some View {
        
        CellWithTwoSlideButton(okMessage: memberInfo.grantButtonText, cancelMessage: "삭제", okButtonHidden: memberInfo.grantButtonHidden, cellID: memberInfo.id, selectedID: $selectedCellID) {
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
        } okCallback: {
            managementVM.alertGrant(memberAndRoleData: memberInfo)
        } cancelCallback: {
            managementVM.alertDeleteMember(memberId: memberInfo.id)
        }
    }
}

//struct ManageMemberCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ManageMemberCell()
//    }
//}
