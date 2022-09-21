//
//  CouponManagementView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/20.
//

import SwiftUI

struct CouponManagementView: View {
    
    @ObservedObject var managementVM: ManagementViewModel
    @StateObject var couponVM = CouponViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                Text("tmp")
                Text("tmp")
                Text("tmp")
                Text("tmp")
                Text("tmp")
                Text("tmp")
                Text("tmp")
                Text("tmp")
                Text("tmp")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottomTrailing) {
                NavigationLink {
                    CreateCouponView(couponVM: couponVM)
                } label: {
                    PlusCircleImage()
                }
            }
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
    }
}
//
//struct CouponManagementView_Previews: PreviewProvider {
//    static var previews: some View {
//        CouponManagementView()
//    }
//}
