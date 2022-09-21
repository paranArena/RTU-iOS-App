//
//  CouponLocationView .swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/21.
//

import SwiftUI
import CoreLocation
import MapKit

struct CouponLocationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var locationManager: LocationManager
    @ObservedObject var couponVM: CouponViewModel
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $locationManager.region, showsUserLocation: false, userTrackingMode: .constant(.none))
                .overlay(Image(systemName: "checkmark").foregroundColor(.navy_1E2F97))

            
            Button {
                couponVM.coupon.latitude = locationManager.region.center.latitude
                couponVM.coupon.longitude = locationManager.region.center.longitude
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("선택된 장소로 설정")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                    .foregroundColor(locationManager.fgColor)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(locationManager.bgColor))
            }
            .padding(.horizontal, 20)
        }
        .basicNavigationTitle(title: "픽업장소 선택")
        .onAppear {
            locationManager.resetRegion()
        }
    }
}

//struct CouponLocationView__Previews: PreviewProvider {
//    static var previews: some View {
//        CouponLocationView_()
//    }
//}
