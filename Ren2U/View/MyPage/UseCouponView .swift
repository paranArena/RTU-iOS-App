//
//  UseCouponView .swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/23.
//

import SwiftUI
import HidableTabView
import MapKit
import CoreLocation

struct UseCouponView: View {
    
    @ObservedObject var myCouponVM: MyCouponViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 30) {
                CouponImage(url: myCouponVM.couponDetailUserData?.imagePath ?? "", size: 200)
                
                IssuedClub()
                UsePeriod()
                UseLocation()
                Information()
                UseCouponButton()
                
                Map(coordinateRegion: $myCouponVM.mapRegion, showsUserLocation: true, userTrackingMode: .none)
            }
            .padding(.horizontal)
        }
        .basicNavigationTitle(title: myCouponVM.couponDetailUserData?.name ?? "")
        .onDisappear {
            myCouponVM.couponDetailUserData = nil 
        }
        .onAppear {
            UITabBar.hideTabBar()
        }
        .avoidSafeArea()
    }
    
    @ViewBuilder
    private func IssuedClub() -> some View {
        HStack {
            Text("발급그룹")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
            
            Spacer()
            
            Text(myCouponVM.couponDetailUserData?.clubName ?? "" )
                .font(.custom(CustomFont.RobotoMedium.rawValue, size: 14))
        }
    }
    
    @ViewBuilder
    private func UsePeriod() -> some View{
        HStack {
           Text("사용가능 기한")
               .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
               .foregroundColor(.gray_495057)
            
            Spacer()

            Text(myCouponVM.couponDetailUserData?.period ?? "")
                .font(.custom(CustomFont.RobotoMedium.rawValue, size: 14))
       }
    }
    
    @ViewBuilder
    private func UseLocation() -> some View {
        HStack {
           Text("사용가능 위치")
               .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
               .foregroundColor(.gray_495057)
            
            Spacer()

            Text(myCouponVM.couponDetailUserData?.location.name ?? "")
                .font(.custom(CustomFont.RobotoMedium.rawValue, size: 14))
            
            Image(AssetImages.MapMarker.rawValue)
                .resizable()
                .frame(width: 15, height: 20)
       }
    }
    
    @ViewBuilder
    private func Information() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("세부정보")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .foregroundColor(.gray_495057)
            
            Text(myCouponVM.couponDetailUserData?.information ?? "")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .frame(maxWidth: .infinity, minHeight: 200, alignment: .topLeading)
                .padding(.horizontal, 5)
                .padding(.vertical, 6)
                .background(RoundedCorner(radius: 5, corners: .allCorners).fill(Color.gray_E9ECEF))
        }
        .frame(alignment: .leading)
    }
    
    @ViewBuilder
    private func UseCouponButton() -> some View {
        Button {
            myCouponVM.alertUseCouponUser()
        } label: {
            VStack {
                Text("쿠폰 사용 시\n 관계자에게 보여주세요.")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 15))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 80)
        .padding(.vertical, 6)
        .background(Capsule().fill(Color.navy_1E2F97))
    }
}

//struct UseCouponView_Previews: PreviewProvider {
//    static var previews: some View {
//        UseCouponView()
//    }
//}
