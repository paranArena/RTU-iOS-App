//
//  RentalViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/18.
//

import SwiftUI
import Foundation
import Alamofire
import CoreLocation

//  Return management view에 쓰이는 model. 추후 삭제
struct ReturnInfo: Codable {
    var imageSource: String
    var itemName: String
    
    init(imageSource: String, itemName: String) {
        self.imageSource = imageSource
        self.itemName = itemName
    }
    
    
    static func dummyReturnInfo() -> ReturnInfo {
        return ReturnInfo(imageSource: "https://picsum.photos/id/1058/200/300", itemName: "운동장")
    }
}

//  ItemMap, ProductDetailView에서 사용
class RentViewModel: BaseViewModel {
    
    var clubId = -1
    var productId = -1
    let rentService: RentServiceEnable
    let clubProductService: ClubProductServiceEnable
    
    @Published var selectedItem: ItemData?
    @Published var isLoading = true
    @Published var productDetail = ProductDetailData.dummyProductData()
    
    @Published var productLocation = CLLocationCoordinate2D(latitude: 127, longitude: 31)
    @Published var isRentalTerminal = false
    @Published var isPresentedMap = false
    
    var alertCase: AlertCase?
    @Published var oneButtonAlert = OneButtonAlert()
    @Published var twoButtonsAlert = TwoButtonsAlert()
  
    init(rentService: RentServiceEnable, clubProductService: ClubProductServiceEnable) {
        self.rentService = rentService
        self.clubProductService = clubProductService
    }
    
    init(clubId: Int, productId: Int, rentService: RentServiceEnable, clubProductService: ClubProductServiceEnable) {
        self.clubId = clubId
        self.productId = productId
        self.rentService = rentService
        self.clubProductService = clubProductService
        
        Task { await refreshProduct() }
    }
    
    @MainActor
    func showTwoButtonsAlert(alertCase: AlertCase) {
        self.alertCase = alertCase
        twoButtonsAlert.messageText = self.message
        twoButtonsAlert.title = self.title
        twoButtonsAlert.isPresented = true
        twoButtonsAlert.callback = {
            await self.callback()
            self.alertCase = nil
        }
    }
    
    @MainActor
    func showAlert(alertCase: AlertCase) {
        self.alertCase = alertCase
        oneButtonAlert.messageText = self.message
        oneButtonAlert.title = self.title
        oneButtonAlert.isPresented = true
        oneButtonAlert.callback = {
            await self.callback()
            self.alertCase = nil
        }
    }
    
    @MainActor
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError!.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
    
    func itemCellTapped(item: ItemData) {
        self.selectedItem = item 
    }
    
    @MainActor
    func setLocation() {
        if let latitude = productDetail.location.latitude, let longitude = productDetail.location.longitude {
            productLocation  = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    @MainActor
    func rentButtonTapped(rentalData: RentalData) {
        if rentalData.rentalInfo.rentalStatus == RentalStatus.wait.rawValue {
            showTwoButtonsAlert(alertCase: .applyAttempyInItemMap(clubId: rentalData.clubId, itemId: rentalData.id))
        } else {
            showTwoButtonsAlert(alertCase: .returnAttemptInItemMap(clubId: rentalData.clubId, itemId: rentalData.id))
        }
    }
    
    @MainActor
    func rentButtonTapped() {
        if let rentalInfo = selectedItem?.rentalInfo  {
            //  대여자가 내가 아닐 경우 아무것도 하지 않음
            if !rentalInfo.meRental {
                
            } else if rentalInfo.rentalStatus == RentalStatus.wait.rawValue {
                showTwoButtonsAlert(alertCase: .applyAttempt)
            } else if rentalInfo.rentalStatus == RentalStatus.rent.rawValue {
                showTwoButtonsAlert(alertCase: .returnAttempt)
            }
        } else {
            // 위치에 제약이 있는 경우 예약 먼저
            if self.productDetail.isThereLocationRestriction {
                showTwoButtonsAlert(alertCase: .requestAttempt)
            } else {
                showTwoButtonsAlert(alertCase: .applyAttemptWhenNoRestriction)
            }
        }
    }
    
    @MainActor
    private func clearSelectedItem() {
        self.selectedItem = nil
    }
    
    @MainActor
    private func refreshProduct () async {
        let response = await clubProductService.getProduct(clubId: self.clubId, productId: self.productId)
        isLoading = false
        
        if let error = response.error {
            self.showAlert(with: error)
        } else if let value = response.value {
            self.productDetail = value.data
        }
    }
    
    @MainActor
    private func showProductLocation() {
        self.isRentalTerminal = true
    }
}

extension RentViewModel {
    
    enum AlertCase {
        case requestAttempt
        case applyAttempt
        case applyAttemptWhenNoRestriction
        case applyAttempyInItemMap(clubId: Int, itemId: Int)
        case applySuccess
        case returnAttempt
        case returnAttemptInItemMap(clubId: Int, itemId: Int)
        case returnSuccess
    }
    
    var title: String {
        switch alertCase {
        case .requestAttempt:
            return "예약"
        case .applyAttempt:
            return "대여"
        case .applyAttemptWhenNoRestriction:
            return "대여"
        case .applyAttempyInItemMap:
            return "대여"
        case .applySuccess:
            return "대여 성공"
        case .returnAttempt:
            return "반납"
        case .returnAttemptInItemMap:
            return "반납"
        case .returnSuccess:
            return "반납 성공"
        case .none:
            return ""
        }
    }
    
    var message: String {
        switch alertCase {
        case .requestAttempt:
            return "물품을 예약하시곘습니까?"
        case .applyAttempt:
            return "물품을 대여하시겠습니까?"
        case .applyAttemptWhenNoRestriction:
            return "물품을 대여하시겠습니까?"
        case .applyAttempyInItemMap(_, _):
            return "물품을 대여하시겠습니까?"
        case .applySuccess:
            return "물품을 대여했습니다."
        case .returnAttempt:
            return "물품을 반납하시겠습니까?"
        case .returnAttemptInItemMap:
            return "물품을 반납하시겠습니까?"
        case .returnSuccess:
            return "물품을 반납했습니다."
            
        case .none:
            return ""
        }
    }
    
    var callback: () async -> () {
        switch alertCase {
        case .requestAttempt:
            return {
                let response = await self.rentService.requesRent(clubId: self.clubId, itemId: self.selectedItem?.id ?? -1)
                if let error = response.error {
                    await self.showAlert(with: error)
                }
                
                await self.refreshProduct()
                await self.clearSelectedItem()
                await self.showProductLocation()
            }
        case .applyAttempt:
            return {
                let response = await self.rentService.applyRent(clubId: self.clubId, itemId: self.selectedItem?.id ?? -1)
                if let error = response.error {
                    await self.showAlert(with: error)
                } else {
                    await self.showAlert(alertCase: .applySuccess)
                }
                await self.refreshProduct()
                await self.clearSelectedItem()
            }
        case .applyAttemptWhenNoRestriction:
            return {
                let _ = await self.rentService.requesRent(clubId: self.clubId, itemId: self.selectedItem?.id ?? -1)
                let response = await self.rentService.applyRent(clubId: self.clubId, itemId: self.selectedItem?.id ?? -1)
                if let error = response.error {
                    await self.showAlert(with: error)
                } else {
                    await self.showAlert(alertCase: .applySuccess)
                }
                await self.refreshProduct()
                await self.clearSelectedItem()
            }
        case .applyAttempyInItemMap(let clubId, let itemId):
            return {
                let response = await self.rentService.applyRent(clubId: clubId, itemId: itemId)
                if let error = response.error {
                    await self.showAlert(with: error)
                } else {
                    await self.showAlert(alertCase: .applySuccess)
                }
                await self.refreshProduct()
                await self.clearSelectedItem()
            }
        case .applySuccess:
            return { }
        case .returnAttempt:
            return {
                let response = await self.rentService.returnRent(clubId: self.clubId, itemId: self.selectedItem?.id ?? -1)
                if let error = response.error {
                    await self.showAlert(with: error)
                } else {
                    await self.showAlert(alertCase: .returnSuccess)
                }
                await self.refreshProduct()
                await self.clearSelectedItem()
            }
        case .returnAttemptInItemMap(let clubId, let itemId):
            return {
                let response = await self.rentService.returnRent(clubId: clubId, itemId: itemId)
                if let error = response.error {
                    await self.showAlert(with: error)
                } else {
                    await self.showAlert(alertCase: .returnSuccess)
                }
                await self.refreshProduct()
                await self.clearSelectedItem()
            }
        case .returnSuccess:
            return { }
        case .none:
            return { }
        }
    }
}
