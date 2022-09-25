//
//  CouponPreviewCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/21.
//

import SwiftUI
import Kingfisher

struct CouponPreviewCell: View {
    
    let data: CouponPreviewData
    @ObservedObject var couponVM: CouponViewModel
    @State private var isShowingRequestButton = false
    @State private var offset: CGFloat = .zero
    
    var body: some View {
        
        SwipeCell(cellId: data.id, selectedCellId: $couponVM.selectedCouponId, buttonWidthSize: 80, isShowingRequestButton: $isShowingRequestButton, offset: $offset) {
            HStack(alignment: .center, spacing: 10) {
                CouponImage(url: data.imagePath, size: 60)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(data.name)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                    
                    Text("\(data.actDate) ~ \(data.expDate)")
                        .font(.custom(CustomFont.RobotoRegular.rawValue, size: 12))
                        .foregroundColor(.gray_868E96)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.BackgroundColor)
            .padding(.leading)
        } button: {
            HStack(spacing: 0) {
                Button {
                    withAnimation {
                        self.offset = .zero
                        self.isShowingRequestButton = false
                    }
                    couponVM.showDeleteCouponAdminAlert(clubId: data.clubId, couponId: data.id)
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

//struct CouponPreviewCell_Previews: PreviewProvider {
//    static var previews: some View {
//        CouponPreviewCell()
//    }
//}
