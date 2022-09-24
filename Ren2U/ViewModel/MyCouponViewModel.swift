//
//  MyCouponViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/23.
//

import SwiftUI
import CoreLocation
import MapKit

class MyCouponViewModel: ObservableObject {
    
    @Published var myCoupons = [CouponPreviewData]()
    @Published var myCouponHistories = [CouponPreviewData]()
    
    //UseCoupon View
    @Published var couponDetailUserData: CouponDetailUserData?
    @Published var mapRegion = MKCoordinateRegion(center: DEFA, span: DEFAULT_SPAN)
    @Published var isActiveUseCouponView = false
    
    @Published var alert = Alert()
    @Published var oneButtonAlert = OneButtonAlert()
    @Published var callbackButton = CallbackAlert()
    
    var myService = MyService.shared
    var couponService = CouponeService.shared
    
    init() {
        Task {
            await getMyCouponsAll()
            await getMyCouponHistoriesAll()
        }
    }
    
    func alertUseCouponUser() {
        alert.message = Text("쿠폰을 사용하시겠습니까?\n 쿠폰 사용 시 관계자에게 보여주세요")
        alert.callback = {
            self.useCouponUser() 
        }
        alert.isPresented = true
    }
    
    @MainActor
    func getMyCouponsAll() {
        Task {
            let response = await myService.getMyCouponsAll()
            if let error = response.error {
                print(response.debugDescription)
                self.showAlert(with: error)
            } else {
                self.myCoupons = response.value?.data ?? [CouponPreviewData]()
            }
        }
    }
    
    @MainActor
    func getMyCouponHistoriesAll() {
        Task {
            let response = await myService.getMyCouponHistoriesAll()
            if let error = response.error {
                print(response.debugDescription)
                self.showAlert(with: error)
            } else {
                self.myCouponHistories = response.value?.data ?? [CouponPreviewData]()
            }
        }
    }
    
    @MainActor
    func getCouponUser(clubId: Int, couponId: Int) {
        Task {
            let response = await couponService.getCouponUser(clubId: clubId, couponId: couponId)
            if let error = response.error {
                print(response.debugDescription)
                self.showAlert(with: error)
            } else {
                self.couponDetailUserData = response.value?.data
                
                if let location = couponDetailUserData?.location {
                    let region = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                    mapRegion = MKCoordinateRegion(center: region, span: DEFAULT_SPAN)
                }
            }
        }
    }
    
    
    //  MARK: PUT
    func useCouponUser() {
        Task {
            if let data = self.couponDetailUserData {
                let response = await couponService.useCouponUser(clubId: data.clubId, couponId: data.id)
                if let error = response.error {
                    print(response.debugDescription)
                    await self.showAlert(with: error)
                } else {
                    print("useCouponUser success")
                }
            }
        }
    }
    
    @MainActor
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
}
