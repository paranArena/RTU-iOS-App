//
//  Service.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/21.
//

import Foundation
import Combine
import Alamofire

class CouponeService {
    static let shared = CouponeService()
    private init() { }
    
    //  MARK: GET

    
    func getClubCouponsAdmin(clubId: Int) async -> DataResponse<GetClubCouponsAdminResponse, NetworkError> {
        
        let url = "\(BASE_URL)/clubs/\(clubId)/coupons/admin"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")"]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetClubCouponsAdminResponse.self).response
        

        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
        
    }
    
    func getCouponAdmin(clubId: Int, couponId: Int) async -> DataResponse<GetCouponAdminResponse, NetworkError> {
        let url = "\(BASE_URL)/clubs/\(clubId)/coupons/\(couponId)/admin"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")"]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetCouponAdminResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func getCouponMembersAdmin(clubId: Int, couponId: Int) async -> DataResponse<GetCouponMembersAdmin, NetworkError> {
        let url = "\(BASE_URL)/clubs/\(clubId)/coupons/\(couponId)/couponMembers/admin"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")"]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetCouponMembersAdmin.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func getCouponMembersHistoriesAdmin(clubId: Int, couponId: Int) async -> DataResponse<GetCouponMembersHistoriesAdmin, NetworkError> {
        let url = "\(BASE_URL)/clubs/\(clubId)/coupons/\(couponId)/histories/admin"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")"]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetCouponMembersHistoriesAdmin.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func getCouponUser(clubId: Int, couponId: Int) async -> DataResponse<GetCouponUserResponse, NetworkError> {
        let url = "\(BASE_URL)/clubs/\(clubId)/coupons/\(couponId)/user"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")"]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetCouponUserResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    
    //  MARK: POST
    
    func createCouponAdmin(clubId: Int, param: [String: Any]) async -> DataResponse<DefaultPostResponse, NetworkError> {
        let url = "\(BASE_URL)/clubs/\(clubId)/coupon/admin"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")"]
        
        let response = await AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(DefaultPostResponse.self).response
        
        return response.mapError { err in
                let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
                return NetworkError(initialError: err, serverError: serverError)
            }
    }
    
    func grantCouponAdmin(clubId: Int, couponId: Int, param: [String: Any]) async -> DataResponse<DefaultPostResponse, NetworkError> {
        let url = "\(BASE_URL)/clubs/\(clubId)/coupons/\(couponId)/admin"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")"]
        
        
        let response = await AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(DefaultPostResponse.self).response
        
        return response.mapError { err in
                let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
                return NetworkError(initialError: err, serverError: serverError)
            }
    }
}
