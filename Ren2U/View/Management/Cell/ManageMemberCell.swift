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
    @Binding var isShowingAlert: Bool
    
    @ObservedObject var managementVM: ManagementViewModel
  
    var body: some View {
        
        CellWithOneSlideButton(okMessage: "삭제", cellID: memberInfo.id, selectedID: $selectedCellID) {
            HStack {

                Image(AssetImages.DefaultGroupImage.rawValue)
                    .resizable()
                    .cornerRadius(15)
                    .frame(width: 80, height: 80)
                
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
        } callback: {
            isShowingAlert = true 
        }
    }
}

//struct ManageMemberCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ManageMemberCell()
//    }
//}
