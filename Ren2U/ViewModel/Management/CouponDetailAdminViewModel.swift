//
//  CouponDetailAdminViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/25.
//

import Foundation

class CouponDetailAdminViewModel: ObservableObject, BaseViewModel {
    
    let clubId: Int
    let couponId: Int
    let couponTitle = CouponTitle()
    
    @Published var couponMembers = [CouponMembersData]()
    @Published var couponeMebersHistories = [CouponMembersData]()
    @Published var couponDetailData: CouponDetailAdminData?
   
    @Published var isShowingLocationPikcer = false
    @Published var selectedTitle = ""
    
    @Published var selectedUnsedCouponId = -1 
    
    @Published var callbackAlert: CallbackAlert = CallbackAlert()
    @Published var oneButtonAlert: OneButtonAlert = OneButtonAlert()
    
    var couponService = CouponService.shared
    
    // CreatCouponView 문제 해결용. 나중에 삭제 필요 
    init() {
        self.clubId = -1
        self.couponId = -1
    }
    
    init(clubId: Int, couponId: Int) {
        self.clubId = clubId
        self.couponId = couponId
        self.selectedTitle = couponTitle.title[0]
        Task {
            await getCouponAdmin()
            await getCouponMembersAdmin()
            await getCouponMembersHistoriesAdmin()
        }
    }
    
    @MainActor
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
    
    @MainActor
    func showDeleteCouponAdminAlert(couponMemberId: Int) {
        callbackAlert.messageText = "쿠폰을 삭제하시겠습니까?"
        callbackAlert.isPresented = true
        callbackAlert.title = ""
        callbackAlert.callback = { await self.deleteCouponMemberAdmin(couponMemberId: couponMemberId) }
    }
    
    //  MARK: GET
    @MainActor
    func getCouponAdmin() async {
        let response = await couponService.getCouponAdmin(clubId: clubId, couponId: couponId)
        if let error = response.error {
            print(response.debugDescription)
            self.showAlert(with: error)
        } else {
            print("getCouponAdmin success")
            self.couponDetailData = response.value?.data ?? nil
        }
    }
    
    @MainActor
    func getCouponMembersAdmin() async {
        let response = await couponService.getCouponMembersAdmin(clubId: clubId, couponId: couponId)
        if let error = response.error {
            print(response.debugDescription)
            self.showAlert(with: error)
        } else {
            print("getCouponMembersAdmin success")
            self.couponMembers = response.value?.data ?? [CouponMembersData]()
        }
    }
    
    @MainActor
    func getCouponMembersHistoriesAdmin() async {
        let response = await couponService.getCouponMembersHistoriesAdmin(clubId: clubId, couponId: couponId)
        if let error = response.error {
            print(response.debugDescription)
            self.showAlert(with: error)
        } else {
            print("getCouponMembersHistoriesAdmin success")
            self.couponeMebersHistories = response.value?.data ?? [CouponMembersData]()
        }
    }
    
    
    //  MARK: DELETE
    
    private func deleteCouponMemberAdmin(couponMemberId: Int) async {
        let response = await couponService.deleteCouponMemberAdmin(clubId: clubId, couponMemberId: couponMemberId)
        if let error = response.error {
            print(response.debugDescription)
            await self.showAlert(with: error)
        } else {
            print("deleteCouponMemberAdmin success")
            await getCouponMembersAdmin()
            await self.getCouponAdmin()
        }
    }
    
    //  MARK: POST
    
    @MainActor
    func grantCouponAdmin(param: [Int], dismiss: @escaping () -> ()) async {
        let param = ["memberIds" : param]
        
        let response = await couponService.grantCouponAdmin(clubId: clubId, couponId: couponId, param: param)
        
        print(response.debugDescription)
        if let error = response.error {
            print(response.debugDescription)
            self.showAlert(with: error)
        } else {
            self.callbackAlert.title = "성공"
            self.callbackAlert.isPresented = true
            self.callbackAlert.messageText = "쿠폰을 발급했습니다."
            self.callbackAlert.callback = dismiss
            await self.getCouponMembersAdmin()
            await self.getCouponAdmin()
        }
    }
    
}
