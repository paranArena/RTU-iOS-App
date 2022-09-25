//
//  UpdateProductViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/20.
//

import Foundation
import Alamofire

class UpdateProductViewModel: ObservableObject {
    
    let clubId: Int
    let productId: Int
    
    @Published var productDetailData = ProductDetailData.dummyProductData()
    @Published var price = ""
    @Published var fifoRentalPeriod = ""
    
    @Published var isLoading = true
    
    @Published var alert = Alert()
    @Published var oneButtonAlert = OneButtonAlert()
    
    @MainActor
    init(clubId: Int, productId: Int) {
        self.clubId = clubId
        self.productId = productId
        
        Task {
            await getProduct()
            self.price = String(productDetailData.price)
            self.fifoRentalPeriod = String(productDetailData.fifoRentalPeriod)
            self.isLoading = false
        }
    }
    
    
    @MainActor
    private func getProduct() async {
        let url = "\(BASE_URL)/clubs/\(clubId)/products/\(productId)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "")]
        
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetProductResponse.self)
        let result = await request.result
        
        switch result {
        case .success(let value):
            isLoading = false
            print("[getProduct success]")
            self.productDetailData = value.data
        case .failure(let err):
            print("[getProduct failure]")
            print(err)
        }
    }
    
}
