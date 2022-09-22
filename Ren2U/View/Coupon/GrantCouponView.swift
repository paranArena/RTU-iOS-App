//
//  GrantCouponView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/22.
//

import SwiftUI

struct GrantCouponView: View {
    
    @ObservedObject var managementVM: ManagementViewModel
    @ObservedObject var couponVM: CouponViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                TopButton()
                ForEach(managementVM.members.indices) { i in
                    HStack(alignment: .center, spacing: 10) {
                        Button {
                            managementVM.members[i].isSelected.toggle()
                        } label: {
                            Circle()
                                .stroke(managementVM.members[i].selectButtonStrokeColor)
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.BackgroundColor)
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color.navy_1E2F97)
                                        .isHidden(hidden: !managementVM.members[i].isSelected)
                                )

                        }
                        MemberCell(memberInfo: managementVM.members[i].data)
                    }
                }
                
                Divider()
                    .padding(.horizontal, -10)
            }
        }
        .padding(.horizontal, 10)
        .basicNavigationTitle(title: "멤버 선택")
        .avoidSafeArea()
        .onDisappear {
            managementVM.unselectAllMembers()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    couponVM.grantCouponAdmin(param: managementVM.getSelectedMembersId()) { dismiss() }
                } label: {
                    Text("발급")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 18))
                }
            }
        }
    }
    
    @ViewBuilder
    private func TopButton() -> some View {
        HStack {
            Text("\(managementVM.selectedMemberCount)개 선택")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 15))
            
            Spacer()
            
            Button {
                managementVM.selectAllMembers()
            } label: {
                Text("전체선택")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 15))
            }
            
            Button {
                managementVM.unselectAllMembers()
            } label: {
                Text("선택해제")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 15))
            }

        }
    }
}

//struct GrantCouponView_Previews: PreviewProvider {
//    static var previews: some View {
//        GrantCouponView()
//    }
//}
