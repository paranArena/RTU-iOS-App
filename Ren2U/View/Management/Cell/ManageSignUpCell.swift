//
//  SignUpCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/31.
//

import SwiftUI

struct ManageSignUpCell: View {
    
    
    let userData: UserData
    @Binding var selectedCellID: Int
    @ObservedObject var managementVM: ManagementViewModel

    
    var body: some View {
        
        CellWithTwoSlideButton(okMessage: "확인", cancelMessage: "거부", cellID: userData.id, selectedID: $selectedCellID) {
            HStack {
                VStack(alignment: .leading) {
                    Text(userData.name)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                    
                    Text("\(userData.major) \(userData.studentId.substring(from: 2, to: 3))")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(.gray_868E96)
                }
                
                Spacer()
                
                Text("가입신청")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                    .foregroundColor(.navy_1E2F97)
            }
        } okCallback: {
            managementVM.acceptClubJoinTask(userData: userData)
        } cancelCallback: {
            print("회원가입 거절 임시 출력 함수")
        }
    }
    
    func getTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd"
        return formatter.string(from: Date.now)
    }
}
//
//struct SignUpCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ManageSignUpCell(managementVM: ManagementViewModel(groupId: 1), userData: UserData.dummyUserData())
//    }
//}
