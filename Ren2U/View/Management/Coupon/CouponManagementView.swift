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
                ForEach(couponVM.clubCoupons.indices, id: \.self) { i in
                    NavigationLink {
                        CouponDetailView(couponVM: couponVM, managementVM: managementVM)
                            .onAppear {
                                couponVM.getCouponAdmin(couponId: couponVM.clubCoupons[i].id)
                                couponVM.couponId = couponVM.clubCoupons[i].id
                                couponVM.getCouponMembersAdmin(couponId: couponVM.couponId)
                                couponVM.getCouponMembersHistoriesAdmin(couponId: couponVM.couponId)
                            }
                    } label: {
                        CouponPreviewCell(data: couponVM.clubCoupons[i], managementVM: managementVM)
                    }
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
