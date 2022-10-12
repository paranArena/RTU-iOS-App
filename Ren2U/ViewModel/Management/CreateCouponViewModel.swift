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
    
    let method: Method
    let clubId: Int
    var couponId: Int?
    
    @Published var coupon = CouponParam()
    
    @Published var isShowingLocationPicker = false
    
    @Published var oneButtonAlert = OneButtonAlert()
    @Published var callbackAlert = CallbackAlert()
    
    var couponService = CouponService.shared
    
    init(clubId: Int, method: Method) {
        self.clubId = clubId
        self.method = method
    }
    
    init(clubId: Int, couponId: Int, couponDetailAdminData: CouponDetailAdminData, method: Method) {
        self.clubId = clubId
        self.couponId = couponId
        self.method = method
        coupon.name = couponDetailAdminData.name
        coupon.actDate = couponDetailAdminData.actDate.toDateType3()
        coupon.expDate = couponDetailAdminData.expDate.toDateType3()
        coupon.location = couponDetailAdminData.location.name
        coupon.information = couponDetailAdminData.information
        coupon.imagePath = couponDetailAdminData.imagePath
        coupon.longitude = couponDetailAdminData.location.longitude
        coupon.latitude = couponDetailAdminData.location.latitude
    }
    
    //  MARK: ALERT
    
    @MainActor
    func showMethodAlert() {
        
        if !coupon.isFilledAllParams {
            showAlertNeedMoreInformation()
            return
        }
        
        self.setAlert()
    }
    
    private func setAlert() {
        if self.method == .post {
            callbackAlert.title = "쿠폰 생성"
            callbackAlert.messageText = "쿠폰을 생성하시겠습니까?"
            callbackAlert.isPresented = true
            callbackAlert.callback = { await self.postCouponAdmin()}
        } else {
            callbackAlert.title = "쿠폰 변경"
            callbackAlert.messageText = "쿠폰을 변경하시겠습니까?"
            callbackAlert.isPresented = true
            callbackAlert.callback = { await self.updateCouponAdmin()}
        }
    }
    
    private func showAlertNeedMoreInformation() {
        oneButtonAlert.title = "쿠폰 생성 실패"
        oneButtonAlert.messageText = "모든 정보를 입력해주세요."
        oneButtonAlert.isPresented = true
    }
    
    
    @MainActor
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError.localizedDescription : error.serverError!.message
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
            "actDate": coupon.actDate!.toJsonForamtAddingNineHours(),
            "expDate": coupon.expDate!.toJsonForamtAddingNineHours()
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
    
    //  MARK: PUT
    
    private func updateCouponAdmin() async {
        
        let param: [String: Any] = [
            "name": coupon.name,
            "locationName": coupon.location,
            "latitude": coupon.latitude!,
            "longitude": coupon.longitude!,
            "information": coupon.information,
            "imagePath": coupon.imagePath,
            "actDate": coupon.actDate!.toJsonFormat(),
            "expDate": coupon.expDate!.toJsonFormat()
        ]
        
        let response = await couponService.updateCouponAdmin(clubId: clubId, couponId: couponId!, param: param)

        if let error = response.error {
           print(response.debugDescription)
           await self.showAlert(with: error)
       } else {
           print("updateCouponAdmin success")
       }
    }
}
