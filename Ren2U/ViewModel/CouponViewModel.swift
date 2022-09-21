//
//  CouponViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/20.
//

import SwiftUI
import Alamofire
import Combine

class CouponViewModel: ObservableObject {
    
    let clubId: Int
    var couponId = 0 
    
    @Published var coupon = CouponParam()
    
    // CouponPreviewCell
    @Published var clubCoupons = [CouponPreviewData]()
    
    // CouponDetailView
    
    @Published var isShowingLocationPikcer = false
    
    @Published var alert = Alert()
    @Published var oneButtonAlert = OneButtonAlert()
    
    private var cancellableSet: Set<AnyCancellable> = []
    var couponService = CouponeService.shared
    var imageService = ImageService.shared
    
    init(clubId: Int) {
        print("Coupon view model init")
        self.clubId = clubId
        getClubCouponsAdmin()
    }
    
    @MainActor
    func showAlertPostCouponAdmin() {
        
        if !coupon.isFilledAllParams {
            showAlertNeedMoreInformation()
            return
        }
        
        alert.title = "쿠폰을 생성하시겠습니까?"
        alert.isPresented = true
        alert.callback = { self.postCouponAdmin(clubId: 42)}
    }
    
    func clearCouponParam() {
        coupon.clearAll()
    }
    
    func getClubCouponsAdmin() {
        couponService.getClubCouponsAdmin(clubId: self.clubId)
            .sink { dataResponse in
                if let error = dataResponse.error {
                    self.showAlert(with: error)
                    print(dataResponse.debugDescription)
                } else {
                    self.clubCoupons = dataResponse.value?.data ?? [CouponPreviewData]()
                }
            }
            .store(in: &cancellableSet)
    }
    
    func postCouponAdmin(clubId: Int) {
        
        let testParam: [String: Any] = [
            "name": coupon.name,
            "locationName": coupon.location,
            "latitude": coupon.latitude!,
            "longitude": coupon.longitude!,
            "information": coupon.information,
            "imagePath": coupon.imagePath,
            "actDate": coupon.actDate!.toJsonValue(),
            "expDate": coupon.expDate!.toJsonValue()
        ]
        
        couponService.createCouponAdmin(clubId: clubId, param: testParam)
            .sink { dataResponse in
                if let error = dataResponse.error {
                    self.showAlert(with: error)
                    print(dataResponse.debugDescription)
                } else {
                    print(dataResponse.value?.responseMessage ?? "")
                }
            }.store(in: &cancellableSet)
    }
    
    func grantCouponAdmin(param: [Int]) {
        let param = ["membersId" : param]
        couponService.grantCouponAdmin(clubId: clubId, couponId: couponId, param: param)
            .sink { dataResponse in
                if let error = dataResponse.error {
                    self.showAlert(with: error)
                    print(dataResponse.debugDescription)
                } else {
                    print(dataResponse.value?.responseMessage ?? "")
                }
            }.store(in: &cancellableSet)
    }
    
    private func showAlertNeedMoreInformation() {
        oneButtonAlert.title = "쿠폰 생성 실패"
        oneButtonAlert.messageText = "모든 정보를 입력해주세요."
        oneButtonAlert.isPresented = true
    }
    
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
}
