//
//  RentalViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/18.
//

import SwiftUI
import Foundation
import Alamofire


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
    @Published var productDetail = ProductDetailData.dummyProductData()
    
    init(clubId: Int, productId: Int) {
        self.clubId = clubId
        self.productId = productId
        getProduct()
    }
    
    //  MARK: GET
    func getProduct() {
        let url = "\(BASE_URL)/clubs/\(clubId)/products/\(productId)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        print(url)
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).responseDecodable(of: GetProductResponse.self) { res in
            switch res.result {
            case .success(let value):
                print("[getProduct success]")
                self.productDetail = value.data
            case .failure(let err):
                print("[getProduct failure]")
                print(err)
            }
        }
    }
    
    //  MARK: POST
    func requestRent(itemId: Int) {
        let url = "\(BASE_URL)/clubs/\(clubId)/rentals/\(itemId)/request"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        print(url)
        
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: hearders).responseString() { res in
            
            switch res.result {
            case .success(let value):
                print("[requestRent success]")
                print(value)
            case .failure(let err):
                print("[requestRent failure]")
                print(err)
            }
        }
    }
}
