//
//  CouponDetailView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/21.
//

import SwiftUI

struct CouponDetailView: View {
    @ObservedObject var couponVM: CouponViewModel
    @ObservedObject var managementVM: ManagementViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 30) {
                CouponImage(url: couponVM.couponDetailData?.imagePath ?? "", size: 200)
                
                CouponCount()
                Period()
                Location()
                Information()
                GrantCoupon()
            }
            .padding(.horizontal)
        }
        .basicNavigationTitle(title: couponVM.couponDetailData?.name ?? "")
        .avoidSafeArea()
        .onDisappear {
            couponVM.couponDetailData = nil
        }
    }
    
    @ViewBuilder
    private func CouponCount() -> some View {
        Group {
            HStack {
                Text("발급 수")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                    .foregroundColor(.gray_495057)
                
                Spacer()
                
                Text("\(couponVM.couponDetailData?.allCouponCount ?? 0)장")
                    .font(.custom(CustomFont.RobotoMedium.rawValue, size: 14))
            }
            
            HStack {
                Text("미사용 쿠폰")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                    .foregroundColor(.gray_495057)
                
                Spacer()
                
                Text("\(couponVM.couponDetailData?.leftCouponCount ?? 0)장")
                    .font(.custom(CustomFont.RobotoMedium.rawValue, size: 14))
            }
        }
    }
    
    @ViewBuilder
    private func Period() -> some View {
        HStack {
            Text("사용가능 기한")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .foregroundColor(.gray_495057)
            
            Spacer()
            
            Text(couponVM.couponDetailData?.period ?? "")
                .font(.custom(CustomFont.RobotoMedium.rawValue, size: 14))
        }
    }
    
    @ViewBuilder
    private func Location() -> some View {
        HStack {
            Text("사용가능 위치")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .foregroundColor(.gray_495057)
            
            Spacer()
            
            Text(couponVM.couponDetailData?.location.name ?? "")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
        }
    }
    
    @ViewBuilder
    private func Information() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("세부정보")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .foregroundColor(.gray_495057)
            
            Text(couponVM.couponDetailData?.information ?? "")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .padding(.vertical, 5)
                .padding(.horizontal, 5)
                .background(RoundedCorner(radius: 15, corners: .allCorners).fill(Color.gray_E9ECEF))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func GrantCoupon() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("쿠폰 발급")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .foregroundColor(.gray_495057)
            
            NavigationLink {
                GrantCouponView(managementVM: managementVM, couponVM: couponVM)
            } label: {
                GrayRoundedRectangle(bgColor: Color.gray_F1F2F3, fgColor: Color.black, text: "멤버선택")
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//struct CouponDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        CouponDetailView()
//    }
//}
