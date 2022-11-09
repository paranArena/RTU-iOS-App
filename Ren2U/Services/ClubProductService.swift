//
//  ClubProductService.swift
//  Ren2U
//
//  Created by 노우영 on 2022/11/09.
//

import Foundation
import Alamofire

protocol ClubProductServiceEnable: BaseServiceEnable {
    func getProduct(clubId: Int, productId: Int) async -> DataResponse<GetProductResponse, NetworkError>
}

class MockupClubProductService: ClubProductServiceEnable {
    func getProduct(clubId: Int, productId: Int) async -> Alamofire.DataResponse<GetProductResponse, NetworkError> {
        let result = Result {
            return GetProductResponse(statusCode: 200, responseMessage: "", data: ProductDetailData.dummyProductData())
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    var url: String?
    var bearerToken: String?
}

class ClubProductService: ClubProductServiceEnable {
    func getProduct(clubId: Int, productId: Int) async -> Alamofire.DataResponse<GetProductResponse, NetworkError> {
        
        let url = "\(self.url!)/clubs/\(clubId)/products/\(productId)"
        let headers: HTTPHeaders = [ .authorization(bearerToken: self.bearerToken!) ]
        
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).serializingDecodable(GetProductResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    init(url: String) {
        self.url = url
        self.bearerToken = UserDefaults.standard.string(forKey: JWT_KEY)
    }
    
    var url: String?
    var bearerToken: String?
}
