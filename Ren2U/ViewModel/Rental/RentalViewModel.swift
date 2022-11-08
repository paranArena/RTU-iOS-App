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
class RentalViewModel: BaseViewModel {
    
    var clubId = -1
    var productId = -1
    let rentService: RentServiceEnable
    
    @Published var selectedItem: ItemData?
    @Published var isLoading = true
    @Published var productDetail = ProductDetailData.dummyProductData()
    
    @Published var productLocation = CLLocationCoordinate2D(latitude: 127, longitude: 31)
    @Published var isRentalTerminal = false
    @Published var isPresentedMap = false
    
    @Published var oneButtonAlert = OneButtonAlert()
    @Published var twoButtonsAlert = TwoButtonsAlert()
    @Published var alert = Alert()
    
  
    init(service: RentServiceEnable) {
        rentService = service
    }
    
    init(clubId: Int, productId: Int, service: RentServiceEnable) {
        self.clubId = clubId
        self.productId = productId
        self.rentService = service
        
        Task {
            await getProduct()
        }
    }
    
    @MainActor
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError!.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
    
    @MainActor
    func showAlert(_ alertCase: AlertCase) {
        oneButtonAlert.title = alertCase.title
        oneButtonAlert.messageText = alertCase.message
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
    
    
    func rentButtonTapped(rentalData: RentalData) {
        if rentalData.rentalInfo.rentalStatus == RentalStatus.wait.rawValue {
            alert.message = Text("아이템을 대여하시겠습니까?")
            alert.isPresented = true
            alert.callback = {
                await self.applyRent(clubId: rentalData.clubId, itemId: rentalData.id)
            }
        } else {
            alert.message = Text("rentalData.rentalInfo.alertMeesage")
            alert.isPresented = true
            alert.callback = {
                await self.returnRent(clubId: rentalData.clubId, itemId: rentalData.id)
            }
        }
    }
    
    @MainActor
    func rentButtonTapped() {
        if let rentalInfo = selectedItem?.rentalInfo  {
            //  대여자가 내가 아닐 경우 아무것도 하지 않음
            if !rentalInfo.meRental {
                
            } else if rentalInfo.rentalStatus == RentalStatus.wait.rawValue {
                alert.message = Text(selectedItem?.alertMessage ?? "에러")
                alert.isPresented = true
                alert.callback = {
                    await self.applyRent(clubId: self.clubId, itemId: self.selectedItem?.id ?? -1)
                }
            } else if rentalInfo.rentalStatus == RentalStatus.rent.rawValue {
                alert.message = Text(selectedItem?.alertMessage ?? "에러")
                alert.isPresented = true
                alert.callback = {
                    await self.returnRent(clubId: self.clubId, itemId: self.selectedItem?.id ?? -1)
                    self.selectedItem = nil
                }
            }
        } else {
            
            // 위치에 제약이 있는 경우 예약 먼저
            if self.productDetail.isThereLocationRestriction {
                alert.message = Text(selectedItem?.alertMessage ?? "에러")
                alert.isPresented = true
                alert.callback = {
                    await self.requestRent()
                }
            } else {
                alert.message = Text(selectedItem?.alertMessage ?? "에러")
                alert.isPresented = true
                alert.callback = {
                    let _ = await self.rentService.requesRent(clubId: self.clubId, itemId: self.selectedItem?.id ?? -1)
                    await self.applyRent(clubId: self.clubId, itemId: self.selectedItem?.id ?? -1)
                    self.selectedItem = nil
                }
            }
        }
    }
    
    
    @MainActor
    private func getProduct() async {
        let url = "\(BASE_URL)/clubs/\(clubId)/products/\(productId)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "")]
        
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetProductResponse.self)
        let result = await request.result
        isLoading = false
        
        switch result {
        case .success(let value):
            print("[getProduct success]")
            self.productDetail = value.data
        case .failure(let err):
            print("[getProduct failure]")
            print(err)
        }
    }
    
    //  MARK: POST
    @MainActor
    private func requestRent() async {
        let url = "\(BASE_URL)/clubs/\(clubId)/rentals/\(selectedItem?.id ?? -1)/request"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        
        let request = AF.request(url, method: .post, encoding: JSONEncoding.default, headers: hearders).serializingString()
        
        let response = await request.response
        
        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 200:
                self.isRentalTerminal = true
                print("[requestRent success]")
            case 400:
                if let data = response.data {
                    let error = try? JSONDecoder().decode(ServerError.self, from: data)
                    if let code = error?.code {
                        switch code {
                        case "ALREADY_USED":
                            oneButtonAlert.title = "예약 실패"
                            oneButtonAlert.messageText = "이미 예약했습니다."
                            oneButtonAlert.isPresented = true
                        default:
                            oneButtonAlert.title = "예약 실패"
                            oneButtonAlert.messageText = "예약에 실패했습니다."
                            oneButtonAlert.isPresented = true
                        }
                    }
                }
            default:
                oneButtonAlert.title = "예약 실패"
                oneButtonAlert.messageText = "예약에 실패했습니다."
                oneButtonAlert.isPresented = true
            }
        }
        
        await getProduct()
    }
    
    //  MARK: PUT
    
    @MainActor
    private func applyRent(clubId: Int, itemId: Int) async {
        let url = "\(BASE_URL)/clubs/\(clubId)/rentals/\(itemId)/apply"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "")]
        
        let request = AF.request(url, method: .put, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let response = await request.response
        
        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 200:
                print("[applyRent success]")
                oneButtonAlert.title = "대여 성공"
                oneButtonAlert.messageText = ""
                oneButtonAlert.isPresented = true
            default:
                print("[applyRent failure]")
                print(response.debugDescription)
                oneButtonAlert.title = "대여 실패"
                oneButtonAlert.messageText = ""
                oneButtonAlert.isPresented = true
            }
        }
        
        await getProduct()
    }
    
    
    @MainActor
    private func returnRent(clubId: Int, itemId: Int) async {
        let url = "\(BASE_URL)/clubs/\(clubId)/rentals/\(itemId)/return"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "" )]
        
        let request = AF.request(url, method: .put, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let response = await request.response
        
        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 200:
                print("[returnRent success]")
                oneButtonAlert.title = "반납 성공"
                oneButtonAlert.messageText = ""
                oneButtonAlert.isPresented = true
            default:
                print("[returnRent failure]")
                print(response.debugDescription)
                oneButtonAlert.title = "반납 실패"
                oneButtonAlert.messageText = ""
                oneButtonAlert.isPresented = true
            }
        }
        
        await getProduct()
    }
}

extension RentalViewModel {
    enum AlertCase {
        case apply
        
        var title: String {
            switch self {
                
            case .apply:
                return ""
            }
        }
        
        var message: String {
            switch self {
                
            case .apply:
                return "아이템을 예약하시겠습니까?"
            }
        }
    }
}
