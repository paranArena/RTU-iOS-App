//
//  CouponViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/20.
//

import SwiftUI
import Alamofire

class CouponViewModel: ObservableObject {
    
    let clubId: Int
    
    // CouponPreviewCell
    @Published var clubCoupons = [CouponPreviewData]()
    @Published var selectedCouponId = -1 

    
    @Published var alert = Alert()
    @Published var oneButtonAlert = OneButtonAlert()
    @Published var callbackButton = TwoButtonsAlert()
    
    let couponService: CouponServiceProtocol
    var imageService = ImageService.shared
    
    init(clubId: Int, couponService: CouponServiceProtocol) {
        self.clubId = clubId
        self.couponService = couponService
        Task { await getClubCouponsAdmin() }
    }

    @MainActor
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError!.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
    
    @MainActor
    func showDeleteCouponAdminAlert(clubId: Int, couponId: Int) {
        callbackButton.title = ""
        callbackButton.messageText = "쿠폰을 삭제하시겠습니까?"
        callbackButton.isPresented = true
        callbackButton.callback = { await self.deleteCouponAdmin(clubId: clubId, couponId: couponId) }
    }
    
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
    
    //  MARK: DELETE
    private func deleteCouponAdmin(clubId: Int, couponId: Int) async {
        let response = await couponService.deleteCouponAdmin(clubId: clubId, couponId: couponId)
        
        if let error = response.error {
            print(response.debugDescription)
            await self.showAlert(with: error)
        } else {
            await getClubCouponsAdmin()
        }
    }
}
