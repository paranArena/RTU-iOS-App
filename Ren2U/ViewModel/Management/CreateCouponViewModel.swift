//
//  CreateCouponViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/24.
//

import SwiftUI
import CoreLocation
import Alamofire

class CreateCouponViewModel: ObservableObject {
    
    let clubId: Int
    var couponId: Int?
    
    @Published var coupon = CouponParam()
    
    @Published var dates: Set<DateComponents> = [] 
    
    @Published var isShowingLocationPicker = false
    
    @Published var oneButtonAlert = OneButtonAlert()
    @Published var callbackAlert = CallbackAlert()
    
    var couponService = CouponeService.shared
    
    init(clubId: Int) {
        self.clubId = clubId
    }
    
    init(clubId: Int, couponId: Int) {
        self.clubId = clubId
        self.couponId = couponId
    }
    
    @MainActor
    func showAlertPostCouponAdmin() {
        
        if !coupon.isFilledAllParams {
            showAlertNeedMoreInformation()
            return
        }
        
        callbackAlert.title = "쿠폰 생성"
        callbackAlert.messageText = "쿠폰을 생성하시겠습니까?"
        callbackAlert.isPresented = true
        callbackAlert.callback = { await self.postCouponAdmin()}
    }
    
    private func showAlertNeedMoreInformation() {
        oneButtonAlert.title = "쿠폰 생성 실패"
        oneButtonAlert.messageText = "모든 정보를 입력해주세요."
        oneButtonAlert.isPresented = true
    }
    
    func postCouponAdmin() async {
        
        let param: [String: Any] = [
            "name": coupon.name,
            "locationName": coupon.location,
            "latitude": coupon.latitude!,
            "longitude": coupon.longitude!,
            "information": coupon.information,
            "imagePath": coupon.imagePath,
            "actDate": coupon.actDate.toJsonValue(),
            "expDate": coupon.expDate.toJsonValue()
        ]
        
        let response = await couponService.createCouponAdmin(clubId: clubId, param: param)
        
        print(response.debugDescription)
        if let error = response.error {
           print(response.debugDescription)
           await self.showAlert(with: error)
       } else {
           print("createCouponAdmin success")
       }
    }
    
    @MainActor
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
}
