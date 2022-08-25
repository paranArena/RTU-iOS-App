//
//  ItemInformation2.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI

struct ItemInformation2: View {
    
    @ObservedObject var itemVM: ItemViewModel
    @Binding var isActive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("다음 사항을 입력해주세요")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
            
            HStack(alignment: .center, spacing: 20) {
                Text("수량")
                Spacer()
                
                Button {
                    itemVM.downCount()
                } label: {
                    Image(systemName: "minus.circle")
                        .foregroundColor(itemVM.isCountZero ? .gray_ADB5BD : .navy_1E2F97)
                }
                .disabled(itemVM.isCountZero)
                
                Text("\(itemVM.count)")
                    .font(.custom(CustomFont.RobotoMedium.rawValue, size: 24))
                    .foregroundColor(.primary)
                    .padding(.trailing, -30)
                
                Text("개")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                    .foregroundColor(.primary)
                
                Button {
                    itemVM.upCount()
                } label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.navy_1E2F97)
                }
                


            }
            
            Text("물품목록")
            
            Spacer()
            
            NavigationLink {
                PickUpLocation(itemVM: itemVM, isActive: $isActive)
            } label: {
                RightArrow(isDisabled: false)
            }
            
        }
        .padding(.horizontal, 20)
        .basicNavigationTitle(title: "물품 등록")
    }
}

struct ItemInformation2_Previews: PreviewProvider {
    static var previews: some View {
        ItemInformation2(itemVM: ItemViewModel(), isActive: .constant(true))
    }
}
