//
//  UseCouponView .swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/23.
//

import SwiftUI

struct UseCouponView: View {
    
    @ObservedObject var myCouponVM: MyCouponViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            CouponImage(url: myCouponVM.couponDetailUserData?.imagePath ?? "", size: 200)
            
            UsePeriod()
        }
        .basicNavigationTitle(title: myCouponVM.couponDetailUserData?.name ?? "")
        .onDisappear {
            myCouponVM.couponDetailUserData = nil 
        }
    }
    
//    @ViewBuilder
//    private func IssuedGroup() {
//        HStack {
//            Text("발급그룹")
//                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
//
//            Text(myCouponVM.couponDetailUserData.)
//        }
//    }
    
    @ViewBuilder
    private func UsePeriod() -> some View{
        HStack {
           Text("사용가능 기한")
               .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
               .foregroundColor(.gray_495057)

            Text(myCouponVM.couponDetailUserData?.period ?? "")
                .font(.custom(CustomFont.RobotoMedium.rawValue, size: 14))
       }
    }
    
    @ViewBuilder
    private func Information() -> some View {
        
    }
}

//struct UseCouponView_Previews: PreviewProvider {
//    static var previews: some View {
//        UseCouponView()
//    }
//}
