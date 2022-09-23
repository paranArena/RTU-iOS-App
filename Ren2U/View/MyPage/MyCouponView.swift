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
                        myCouponVM.getCouponUser(clubId: cludId, couponId: couponId)
                    } label: {
                        MyCouponPreviewCell(data: myCouponVM.myCoupons[i])
                    }

                    NavigationLink {
                        UseCouponView(myCouponVM: myCouponVM)
                    } label: {
                        MyCouponPreviewCell(data: myCouponVM.myCoupons[i])
                    }
                    
                    Divider()
                        .padding(.horizontal, -10)
                }
            }
            .padding(.horizontal)
        }
        .basicNavigationTitle(title: "쿠폰함")
        .controllTabbar(isPresented)
        .avoidSafeArea()
    }
}

struct MyCouponView_Previews: PreviewProvider {
    static var previews: some View {
        MyCouponView()
    }
}
