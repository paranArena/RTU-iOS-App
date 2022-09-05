//
//  ItemViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI
import Alamofire

class ItemViewModel: ObservableObject {
    
    @Published var image = [UIImage]()
    @Published var showPicker = false
    
    @Published var itemName = ""
    @Published var category: Category?
    @Published var price = ""
    @Published var fifoCount = 0
    @Published var reserveCount = 0
    @Published var fifoRentalPeriod = 0
    @Published var reserveRentalPeriod = 0
    
    @Published var locationDetail = ""
    @Published var locationLongtitude: Double = 0.0
    @Published var locationLatitude: Double = 0.0
    @Published var isSelectedLocation = false
    @Published var caution = ""
    @Published var isActive = false
    @Published var isDonation = false
    
    init() {
        image = [UIImage]()
        print("ItemViewModel init")
    }
    
    var isImageSelected: Bool {
        guard image.isEmpty else { return true }
        return false
    }
    
    var categoryString: String {
        guard let category = self.category else { return "선택"}
        return category.rawValue
    }
    
    var isAllItemInformationFilled: Bool {
        guard !itemName.isEmpty else { return false }
        guard category != nil else { return false }
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
        let url = "\(BASE_URL)/clubs/5/products"
        let hearders: HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY)!)",
            "Content-type": "multipart/form-data"
        ]
        
        let param: [String: Any] = [
            "name": self.itemName,
            
            //  MARK: 수정 필요
            "category": self.category!.rawValue,
            "price": self.price,
            
            "fifoRentalPeriod": self.fifoRentalPeriod,
            "reserveRentalPeriod": self.reserveRentalPeriod,
            "locationName": self.locationDetail,
            "longitude": self.locationLongtitude,
            "latitude": self.locationLatitude,
            "caution": self.caution
        ]
        
        for (key, value) in param {
            print("key : \(key), value: \(value)")
        }
        
        
        
        let task = AF.upload(multipartFormData: { multipart in
            if let image = self.image[0].jpegData(compressionQuality: 1) {
                multipart.append(image, withName: "image", fileName: "\(self.itemName).thumbnail", mimeType: "image/jpeg")
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
        
        
        let result = await task.result
        
        switch result {
        case .success(let value):
            print("creatProduct success : \(value)")
        case .failure(let err):
            print("createProduct failure : \(err)")
        }
    }
}
