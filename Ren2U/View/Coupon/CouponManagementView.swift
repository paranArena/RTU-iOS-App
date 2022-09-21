//
//  CouponManagementView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/20.
//

import SwiftUI

struct CouponManagementView: View {
    
    @ObservedObject var couponVM: CouponViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(couponVM.clubCoupons.indices) { i in
                    CouponPreviewCell(data: couponVM.clubCoupons[i])
                    Divider()
                        .padding(.horizontal, -10)
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .alert(couponVM.oneButtonAlert.title, isPresented: $couponVM.oneButtonAlert.isPresented) {
            OneButtonAlert.noActionButton
        } message: {
            couponVM.oneButtonAlert.message
        }
        .basicNavigationTitle(title: "쿠폰 관리")
        .avoidSafeArea()
        .onAppear {
            UITabBar.hideTabBar()
        }
        .overlay(alignment: .bottomTrailing) {
            NavigationLink {
                CreateCouponView(couponVM: couponVM)
            } label: {
                PlusCircleImage()
            }
        }
    }
}
//
//struct CouponManagementView_Previews: PreviewProvider {
//    static var previews: some View {
//        CouponManagementView()
//    }
//}
