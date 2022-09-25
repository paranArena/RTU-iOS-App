//
//  MyCouponView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/23.
//

import SwiftUI

struct MyCouponView: View {
    
    @StateObject var myCouponVM = MyCouponViewModel()
    @Environment(\.isPresented) var isPresented
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(myCouponVM.myCoupons.indices, id: \.self) { i in
                    let cludId = myCouponVM.myCoupons[i].clubId
                    let couponId = myCouponVM.myCoupons[i].id
                    
                    Button {
                        myCouponVM.selectedClubId = cludId
                        myCouponVM.selectedCouponId = couponId
                        myCouponVM.isActiveUseCouponView = true
                    } label: {
                        MyCouponPreviewCell(data: myCouponVM.myCoupons[i])
                    }
                    
                    Divider()
                        .padding(.horizontal, -10)
                }
                
                NavigationLink(isActive: $myCouponVM.isActiveUseCouponView) {
                    UseCouponView(myCouponDetailVM: MyCouponDetailViewModel(clubId: myCouponVM.selectedClubId, couponId: myCouponVM.selectedCouponId), myCouponVM: myCouponVM)
                } label: { }
            }
            .padding(.horizontal)
        }
        .basicNavigationTitle(title: "쿠폰함")
        .controllTabbar(isPresented)
        .avoidSafeArea()
        .alert(myCouponVM.oneButtonAlert.title, isPresented: $myCouponVM.oneButtonAlert.isPresented) {
            OneButtonAlert.noActionButton
        } message: {
            myCouponVM.oneButtonAlert.message
        }
        .alert("", isPresented: $myCouponVM.alert.isPresented) {
            Button("취소", role: .cancel) {}
            Button("확인") { Task { await myCouponVM.alert.callback() }}
        } message: {
            myCouponVM.alert.message
        }
    }
}

struct MyCouponView_Previews: PreviewProvider {
    static var previews: some View {
        MyCouponView()
    }
}
