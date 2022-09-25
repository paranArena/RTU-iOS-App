//
//  MyCouponDetailViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/24.
//

import SwiftUI
import CoreLocation
import MapKit

class MyCouponDetailViewModel: ObservableObject {
    @Published var couponDetailUserData = CouponDetailUserData.dummyCouponDetailUserDate()
    @Published var mapRegion = MKCoordinateRegion(center: DEFAULT_REGION, span: DEFAULT_SPAN)
    @Published var annotation = [Annotation]()
    
    @Published var isActiveMap = false
    
    @Published var alert = Alert()
    @Published var oneButtonAlert = OneButtonAlert()
    @Published var callbackButton = CallbackAlert()
    
    var couponService = CouponeService.shared
    var myServiccee = MyService.shared
    
    init(clubId: Int, couponId: Int) {
        Task {
            await getCouponUser(clubId: clubId, couponId: couponId)
        }
    }
    
    
    @MainActor
    func alertUseCouponUser() async {
        alert.message = Text("쿠폰을 사용하시겠습니까?\n 쿠폰 사용 시 관계자에게 보여주세요")
        alert.callback = {
            await self.useCouponUser()
        }
        alert.isPresented = true
    }
    
    @MainActor
    func getCouponUser(clubId: Int, couponId: Int) {
        Task {
            let response = await couponService.getCouponUser(clubId: clubId, couponId: couponId)
            if let error = response.error {
                print(response.debugDescription)
                self.showAlert(with: error)
            } else {
                self.couponDetailUserData = response.value?.data ?? CouponDetailUserData.dummyCouponDetailUserDate()
                let location = couponDetailUserData.location
                let region = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                mapRegion = MKCoordinateRegion(center: region, span: DEFAULT_SPAN)
                annotation = [Annotation(coordinate: region)]
            }
        }
    }
    
    
    //  MARK: PUT
    func useCouponUser() async {
        let data = self.couponDetailUserData
        let response = await couponService.useCouponUser(clubId: data.clubId, couponId: data.id)
        if let error = response.error {
            print(response.debugDescription)
            await self.showAlert(with: error)
        } else {
            print("useCouponUser success")
        }
    }
    
    @MainActor
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
}
