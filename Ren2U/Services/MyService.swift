//
//  MyService.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/23.
//

import Foundation
import Alamofire

class MyService {
    
    static let shared = MyService()
    
    func getMyCouponsAll() async -> DataResponse<GetMyCouponsAllResponse, NetworkError> {
        
        let url = "\(BASE_URL)/members/my/coupons/all"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")"]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyCouponsAllResponse.self).response

        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func getMyCouponHistoriesAll() async -> DataResponse<GetMyCouponHistoriesAllResponse, NetworkError> {
        
        let url = "\(BASE_URL)/members/my/couponHistories/all"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")"]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyCouponHistoriesAllResponse.self).response
        

        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
}
