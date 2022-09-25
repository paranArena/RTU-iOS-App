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
    
//    @Published var coupon = CouponParam()
    
    // CouponPreviewCell
    @Published var clubCoupons = [CouponPreviewData]()
    
    // CouponDetailView
    @Published var couponMembers = [CouponMembersData]()
    @Published var couponeMebersHistories = [CouponMembersData]()
    @Published var couponDetailData: CouponDetailAdminData?
    @Published var isShowingLocationPikcer = false
    let couponTitle = CouponTitle()
    @Published var selectedTitle = ""
    
    @Published var alert = Alert()
    @Published var oneButtonAlert = OneButtonAlert()
    @Published var callbackButton = CallbackAlert()
    
    private var cancellableSet: Set<AnyCancellable> = []
    var couponService = CouponeService.shared
    var imageService = ImageService.shared
    
    init(clubId: Int) {
        print("Coupon view model init")
        self.clubId = clubId
        self.selectedTitle = couponTitle.title[0]
        Task { await getClubCouponsAdmin() }
    }
//
//    @MainActor
//    func showAlertPostCouponAdmin() {
//
//        if !coupon.isFilledAllParams {
//            showAlertNeedMoreInformation()
//            return
//        }
//
//        alert.message = Text("쿠폰을 생성하시겠습니까?")
//        alert.isPresented = true
//        alert.callback = { self.postCouponAdmin(clubId: 42)}
//    }
//
//    func clearCouponParam() {
//        coupon.clearAll()
//    }
//
    
    //  MARK: GET
    
    @MainActor
    func getClubCouponsAdmin() {
        Task {
            let response = await couponService.getClubCouponsAdmin(clubId: self.clubId)
            if let error = response.error {
                print(response.debugDescription)
                self.showAlert(with: error)
            } else {
                self.clubCoupons = response.value?.data ?? [CouponPreviewData]()
            }
        }
    }
    
    @MainActor
    func getCouponAdmin(couponId: Int) {
        Task {
            let response = await couponService.getCouponAdmin(clubId: clubId, couponId: couponId)
            if let error = response.error {
                print(response.debugDescription)
                self.showAlert(with: error)
            } else {
                print("getCouponAdmin success")
                self.couponDetailData = response.value?.data ?? nil
            }
        }
    }
    
    @MainActor
    func getCouponMembersAdmin(couponId: Int) {
        Task {
            let response = await couponService.getCouponMembersAdmin(clubId: clubId, couponId: couponId)
            if let error = response.error {
                print(response.debugDescription)
                self.showAlert(with: error)
            } else {
                print("getCouponMembersAdmin success")
                print(response.value?.data)
                self.couponMembers = response.value?.data ?? [CouponMembersData]()
            }
        }
    }
    
    @MainActor
    func getCouponMembersHistoriesAdmin(couponId: Int) {
        Task {
            let response = await couponService.getCouponMembersHistoriesAdmin(clubId: clubId, couponId: couponId)
            if let error = response.error {
                print(response.debugDescription)
                self.showAlert(with: error)
            } else {
                print("getCouponMembersHistoriesAdmin success")
                self.couponeMebersHistories = response.value?.data ?? [CouponMembersData]()
            }
        }
    }
    
    
    //  MARK: POST
//
//    func postCouponAdmin(clubId: Int) {
//
//        let param: [String: Any] = [
//            "name": coupon.name,
//            "locationName": coupon.location,
//            "latitude": coupon.latitude!,
//            "longitude": coupon.longitude!,
//            "information": coupon.information,
//            "imagePath": coupon.imagePath,
//            "actDate": coupon.actDate!.toJsonValue(),
//            "expDate": coupon.expDate!.toJsonValue()
//        ]
//
//        Task {
//            let response = await couponService.grantCouponAdmin(clubId: clubId, couponId: couponId, param: param)
//            if let error = response.error {
//                print(response.debugDescription)
//                await self.showAlert(with: error)
//            } else {
//                print("postCouponAdmin success")
//            }
//        }
//    }
    
    @MainActor
    func grantCouponAdmin(param: [Int], dismiss: @escaping () -> ()) {
        let param = ["memberIds" : param]
        
        Task {
            let response = await couponService.grantCouponAdmin(clubId: clubId, couponId: couponId, param: param)
            
            print(response.debugDescription)
            if let error = response.error {
                print(response.debugDescription)
                self.showAlert(with: error)
            } else {
                self.callbackButton.title = "성공"
                self.callbackButton.isPresented = true
                self.callbackButton.messageText = "쿠폰을 발급했습니다."
                self.callbackButton.callback = dismiss
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
