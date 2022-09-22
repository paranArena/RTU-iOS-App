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
                
            }
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
