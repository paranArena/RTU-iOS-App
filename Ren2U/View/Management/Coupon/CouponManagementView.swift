//
//  CouponManagementView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/20.
//

import SwiftUI

struct CouponManagementView: View {
    
    @ObservedObject var couponVM: CouponViewModel
    @ObservedObject var managementVM: ManagementViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                SwipeResettableView(selectedCellId: $couponVM.selectedCouponId) {
                    ForEach(couponVM.clubCoupons.indices, id: \.self) { i in
                        NavigationLink {
                            CouponDetailAdminView(managementVM: _managementVM, couponVM: _couponVM, clubId: couponVM.clubId, couponId: couponVM.clubCoupons[i].id)
                        } label: {
                            CouponPreviewCell(data: couponVM.clubCoupons[i], couponVM: couponVM)
                        }

                        Divider()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .alert(couponVM.callbackButton.title, isPresented: $couponVM.callbackButton.isPresented) {
            Button("취소", role: .cancel) {}
            Button("확인") { Task { await couponVM.callbackButton.callback() }}
        } message: {
            couponVM.callbackButton.message
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
                CreateCouponView(clubId: couponVM.clubId, couponVM: _couponVM, method: .post)
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
