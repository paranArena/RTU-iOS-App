//
//  ItemViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI
import Alamofire

class CreateProductViewModel: ObservableObject {
    
    let clubId: Int
    let clubName: String
    
    // 나중에 이미지 여러장 등록할 때 이용 UIImage 배열로 변경
    @Published var image: UIImage?
    @Published var showPicker = false
    
    @Published var itemName = ""
    @Published var category: String = "기타"
    @Published var price = ""
    @Published var fifoCount = 0
    @Published var reserveCount = 0
    @Published var fifoRentalPeriod = 0
    @Published var reserveRentalPeriod = 0
    
    @Published var locationDetail = ""
    @Published var locationLongtitude: Double = 0.0
    @Published var locationLatitude: Double = 0.0
    @Published var isSelectedLocation = false
    @Published var isUseLocation = true
    
    @Published var caution = ""
    @Published var isActive = false
    @Published var isDonation = false
    
    init(clubId: Int, clubName: String ) {
        self.clubId = clubId
        self.clubName = clubName
        print("ItemViewModel init")
    }
    
    var isImageSelected: Bool {
        guard image == nil else { return true }
        return false
    }
    
    var isAllItemInformationFilled: Bool {
        guard !itemName.isEmpty else { return false }
        guard (isDonation || !price.isEmpty) else { return false }
        return true
    }
    
    
    var isItemCautionAbleToGo: Bool {
        guard isSelectedLocation else { return false }
        guard !locationDetail.isEmpty else { return false}
        return true 
    }
    
    //  MARK: LOCAL
    func showImagePicker() {
        self.showPicker = true
    }
    
    //  MARK: POST
    func createProduct() async {
        let url = "\(BASE_URL)/clubs/\(clubId)/products"
        let hearders: HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY)!)",
            "Content-type": "multipart/form-data"
        ]
        
        let param: [String: Any] = [
            "name": self.itemName,
            "category": self.category,
            "price": self.price,
            "fifoRentalPeriod": self.fifoRentalPeriod,
            "reserveRentalPeriod": self.reserveRentalPeriod,
            "locationName": isUseLocation ? self.locationDetail : "" ,
            "longitude" : isUseLocation ? self.locationLongtitude : 200,
            "latitude" : isUseLocation ? self.locationLatitude : 200,
            "caution": self.caution,
        ]
        
        let task = AF.upload(multipartFormData: { multipart in
            if let image = self.image!.jpegData(compressionQuality: 1) {
                multipart.append(image, withName: "image", fileName: "item.image.\(self.clubName).\(self.itemName)", mimeType: "image/jpeg")
            }

            for (key, value) in param {
                multipart.append(Data(String("\(value)").utf8), withName: key)
            }
            
            for _ in 0..<self.fifoCount {
                multipart.append(Data(String("FIFO").utf8), withName: "rentalPolicies")
            }
            
            for _ in 0..<self.reserveCount {
                multipart.append(Data(String("RESERVE").utf8), withName: "rentalPolicies")
            }

        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: hearders).serializingString()
        
        
        let response = await task.response
        
        switch response.result {
        case .success(let value):
            print("creatProduct success : \(value)")
        case .failure(let err):
            print("createProduct failure : \(err)")
            print(response.debugDescription)
        }
    }
}