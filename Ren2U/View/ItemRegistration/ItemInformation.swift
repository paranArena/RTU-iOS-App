//
//  ItemInformation.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI

struct ItemInformation: View {
    
    @ObservedObject var itemVM: ItemViewModel
    @Binding var isActive: Bool
    let additionalPadding: CGFloat = 30
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("다음 사항을 입력해주세요.")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                .padding(.bottom, additionalPadding)
            
            Text("물품 이름")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
            
            TextField("", text: $itemVM.itemName)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .overlay(SimpleBottomLine(color: .gray_DEE2E6))
                .padding(.bottom, additionalPadding)
            
            Text("카테고리")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
            
            NavigationLink {
                ItemCategory(category: $itemVM.category)
            } label: {
                Text(itemVM.categoryString)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                    .frame(width: 150, height: 30)
                    .foregroundColor(.primary)
                    .background(Color.gray_F1F2F3)
                    .cornerRadius(5)
            }
            .padding(.bottom, additionalPadding)
            
            Text("물품 가치")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
            
            HStack {
                TextField("", text: $itemVM.price)
                    .keyboardType(.numberPad)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                    .overlay(SimpleBottomLine(color: .gray_DEE2E6))
                
                Button {
                    itemVM.isDonation.toggle()
                } label: {
                    Circle()
                        .fill(Color.gray_D9D9D9)
                        .frame(width: 20, height: 20)
                        .overlay(Image(systemName: "checkmark")
                            .foregroundColor(.primary)
                            .isHidden(hidden: !itemVM.isDonation))
                }
                
                Text("기부")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
            }
            .padding(.trailing, 40)
            .padding(.bottom, -10)
            
            Text("대여물품 파손 및 손상 시 이용자가 배상해야 할 금액입니다.")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .foregroundColor(.gray_868E96)
                .padding(.bottom, additionalPadding)
            
            Spacer() 
            
            NavigationLink {
                ItemInformation2(itemVM: itemVM, isActive: $isActive)
            } label: {
                RightArrow(isDisabled: !itemVM.isAllItemInformationFilled)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .disabled(!itemVM.isAllItemInformationFilled)

                
        }
        .padding(.horizontal, 20)
        .basicNavigationTitle(title: "물품 등록")
    }
}

struct ItemInformation_Previews: PreviewProvider {
    static var previews: some View {
        ItemInformation(itemVM: ItemViewModel(), isActive: .constant(true))
    }
}
