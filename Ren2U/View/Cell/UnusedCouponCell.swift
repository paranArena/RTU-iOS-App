//
//  UnusedCouponCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/25.
//

import SwiftUI

struct UnusedCouponCell: View {
    
    @ObservedObject var couponDetailAdminVM: CouponDetailAdminViewModel
    let data: CouponMembersData
    @State private var isShowingRequestButton = false
    @State private var offset: CGFloat = .zero
    
    var body: some View {
        SwipeCell(cellId: data.id, selectedCellId: $couponDetailAdminVM.selectedUnsedCouponId, buttonWidthSize: 80, isShowingRequestButton: $isShowingRequestButton, offset: $offset) {
            HStack {
                Image(AssetImages.DefaultGroupImage.rawValue)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 0) {
                    Text(data.memberPreviewDto.name)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                    
                    HStack(alignment: .center, spacing: 5) {
                        Text(data.memberPreviewDto.major)
                            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                            .foregroundColor(Color.gray_ADB5BD)
                        
                        Text(data.memberPreviewDto.year)
                            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                            .foregroundColor(Color.gray_ADB5BD)
                    }
                }

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.BackgroundColor)
        } button: {
            HStack(spacing: 0) {
                Button {
                    withAnimation {
                        self.offset = .zero
                        self.isShowingRequestButton = false
                    }
                    couponDetailAdminVM.showDeleteCouponAdminAlert(couponMemberId: data.id)
                } label: {
                    Text("삭제")
                }
                .frame(width: 80, height: 80)
                .background(Color.red_FF6155)
                .foregroundColor(Color.white)
            }
        }
    }
}
//
//
//struct UnusedCouponCell_Previews: PreviewProvider {
//    static var previews: some View {
//        UnusedCouponCell()
//    }
//}
