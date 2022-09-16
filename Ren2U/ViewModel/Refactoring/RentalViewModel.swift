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

class RentalViewModel: ObservableObject {
    
    var clubId = -1
    var productId = -1
    @Published var selectedItem: ItemData?
    
    @Published var isLoading = true
    @Published var productDetail = ProductDetailData.dummyProductData()
    @Published var productLocation = CLLocationCoordinate2D(latitude: 127, longitude: 31)
    @Published var isRentalTerminal = false
    
    @Published var oneButtonAlert = OneButtonAlert()
    @Published var alert = Alert() 
    
    init(clubId: Int, productId: Int) {
        self.clubId = clubId
        self.productId = productId
        
        
        Task {
            await getProduct()
            setLocation()
        }
    }
    
    //  MARK: LOCAL
    func setLocation() {
        productLocation  = CLLocationCoordinate2D(latitude: productDetail.location.latitude, longitude: productDetail.location.longitude)
    }
    
    func setAlert() {
        if let rentalInfo = selectedItem?.rentalInfo  {
            //  대여자가 내가 아닐 경우 아무것도 하지 않음
            if !rentalInfo.meRental {
                alert.callback = {
                    #if DEBUG
                    print("대여불가능")
                    #endif
                }
            } else if rentalInfo.rentalStatus == RentalStatus.wait.rawValue {
                alert.title = selectedItem?.alertMessage ?? "에러"
                alert.isPresented = true
                alert.callback = {
                    Task {
                        await self.applyRent()
                    }
                }
            } else if rentalInfo.rentalStatus == RentalStatus.rent.rawValue {
                alert.title = selectedItem?.alertMessage ?? "에러"
                alert.isPresented = true
                alert.callback = {
                    Task {
                        await self.returnRent()
                    }
                }
            }
        } else {
            alert.title = selectedItem?.alertMessage ?? "에러"
            alert.isPresented = true
            alert.callback = {
                Task {
                    await self.requestRent()
                }
            }
        }
    }
    
    //  MARK: GET
    
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
        
        if response.response!.statusCode == 400 {
            print(response.debugDescription)
            if let data = response.data {
                let error = try? JSONDecoder().decode(ErrorBody.self, from: data)
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
        } else {
            switch response.result {
                case .success(let value):
                    self.isRentalTerminal = true
                    print("[requestRent success]")
                    print(value)
                case .failure(let err):
                    print("[requestRent failure]")
                    print(err)
            }
        }
        
        self.selectedItem = nil
        await getProduct()
    }
    
    //  MARK: PUT
    private func applyRent() async {
        let url = "\(BASE_URL)/clubs/\(clubId)/rentals/\(selectedItem?.id ?? -1)/apply"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "")]
        
        let request = AF.request(url, method: .put, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let result = await request.result
            
        switch result {
        case .success(let value):
            print("[applyRent success]")
            print(value)
        case .failure(let err):
            print("[applyRent failure]")
            print(err)
        }
        
        
        self.selectedItem = nil
        await getProduct()
    }
    
    private func returnRent() async {
        let url = "\(BASE_URL)/clubs/\(clubId)/rentals/\(selectedItem?.id ?? -1)/return"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "" )]
        
        let request = AF.request(url, method: .put, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let result = await request.result
            
        switch result {
        case .success(let value):
            print("[returnRent success]")
            print(value)
        case .failure(let err):
            print("[returnRent failure]")
            print(err)
        }
        
        
        self.selectedItem = nil
        await getProduct()
    }
}
