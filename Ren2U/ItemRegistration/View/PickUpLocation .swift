//
//  PickUpLocation .swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI

struct PickUpLocation: View {
    
    @ObservedObject var itemVM: ItemViewModel
    @Binding var isActive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Spacer()
            
            Text("물건을 픽업할 장소를 정해주세요.")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                .padding(.bottom, 40)
            
            Text("지도에서 픽업장소를 표시해주세요.")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .foregroundColor(.Gray_495057)
            
            Text("표시 완료")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                .foregroundColor(.white)
                .isHidden(hidden: itemVM.isSelectedLocation)
            
            NavigationLink {
                PickUpLocationMap(itemVM: itemVM)
            } label: {
                Group {
                    Text("지도에서 장소 표시")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.gray_F1F2F3)
                        .cornerRadius(5)
                        .isHidden(hidden: itemVM.isSelectedLocation)
                    
                    Text("표시 완료")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.navy_1E2F97)
                        .cornerRadius(5)
                        .isHidden(hidden: !itemVM.isSelectedLocation)
                }
            }
            .padding(.bottom, 40)
            
            
            Text("건물명과 호수까지 입력해주세요.")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .foregroundColor(.Gray_495057)
            
            TextField("", text: $itemVM.locationDetail)
                .overlay(SimpleBottomLine(color: .gray_DEE2E6))
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
            
            Spacer()
            
            NavigationLink {
                ItemCaution(itemVM: itemVM, isActive: $isActive)
            } label: {
                RightArrow(isDisabled: !itemVM.isItemCautionAbleToGo)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .disabled(!itemVM.isItemCautionAbleToGo)

                

        }
        .basicNavigationTitle(title: "물품 등록")
        .padding(.horizontal, 20)
        .onAppear {
            print("\(isActive.description)")
        }
    }
}

struct PickUpLocation_Previews: PreviewProvider {
    static var previews: some View {
        PickUpLocation(itemVM: ItemViewModel(), isActive: .constant(true))
    }
}