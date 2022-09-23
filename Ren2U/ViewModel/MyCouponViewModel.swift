//
//  MyCouponViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/23.
//

import SwiftUI

class MyCouponViewModel: ObservableObject {
    
    @Published var myCoupons = [CouponPreviewData]()
    @Published var myCouponHistories = [CouponPreviewData]()
    
    //UserCoupon View
    @Published var couponDetailUserData: CouponDetailUserData?
    
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
