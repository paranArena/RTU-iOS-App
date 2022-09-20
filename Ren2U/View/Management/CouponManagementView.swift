//
//  CouponManagementView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/20.
//

import SwiftUI

struct CouponManagementView: View {
    
    @ObservedObject var managementVM: ManagementViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                
            }
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
