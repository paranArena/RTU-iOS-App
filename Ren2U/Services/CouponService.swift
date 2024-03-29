//
//  Service.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/21.
//

import Foundation
import Combine
import Alamofire

protocol CouponServiceProtocol {
    func getClubCouponsAdmin(clubId: Int) async -> DataResponse<GetClubCouponsAdminResponse, NetworkError>
    func getCouponAdmin(clubId: Int, couponId: Int) async -> DataResponse<GetCouponAdminResponse, NetworkError>
    func getCouponMembersAdmin(clubId: Int, couponId: Int) async -> DataResponse<GetCouponMembersAdmin, NetworkError>
    func getCouponMembersHistoriesAdmin(clubId: Int, couponId: Int) async -> DataResponse<GetCouponMembersHistoriesAdmin, NetworkError>
    func getCouponUser(clubId: Int, couponId: Int) async -> DataResponse<GetCouponUserResponse, NetworkError>
    func deleteCouponAdmin(clubId: Int, couponId: Int) async -> DataResponse<DefaultPostResponse, NetworkError>
    func deleteCouponMemberAdmin(clubId: Int, couponMemberId: Int) async -> DataResponse<DefaultPostResponse, NetworkError>
    func createCouponAdmin(clubId: Int, param: [String: Any]) async -> DataResponse<DefaultPostResponse, NetworkError>
    func grantCouponAdmin(clubId: Int, couponId: Int, param: [String: Any]) async -> DataResponse<DefaultPostResponse, NetworkError>
    func useCouponUser(clubId: Int, couponId: Int) async -> DataResponse<DefaultPostResponse, NetworkError>
    func updateCouponAdmin(clubId: Int, couponId: Int, param: [String: Any]) async -> DataResponse<DefaultPostResponse, NetworkError>
}

//class MockupCouponService: CouponServiceProtocol {
//    func getClubCouponsAdmin(clubId: Int) async -> Alamofire.DataResponse<GetClubCouponsAdminResponse, NetworkError> {
//
//        let result = Result {
//            return GetClubCouponsAdminResponse(statusCode: 200, responseMessage: "", data: CouponPreviewData.dummyCouponPreviewDatas())
//        }
//        .mapError { _ in
//            return NetworkError(initialError: nil, serverError: nil)
//        }
//
//        return DataResponse(request: .none, response: .none, data: .none, metrics: .none, serializationDuration: 0.0, result: result)
//
//    }
//
//    func getCouponAdmin(clubId: Int, couponId: Int) async -> Alamofire.DataResponse<GetCouponAdminResponse, NetworkError> {
//        <#code#>
//    }
//
//    func getCouponMembersAdmin(clubId: Int, couponId: Int) async -> Alamofire.DataResponse<GetCouponMembersAdmin, NetworkError> {
//        <#code#>
//    }
//
//    func getCouponMembersHistoriesAdmin(clubId: Int, couponId: Int) async -> Alamofire.DataResponse<GetCouponMembersHistoriesAdmin, NetworkError> {
//        <#code#>
//    }
//
//    func getCouponUser(clubId: Int, couponId: Int) async -> Alamofire.DataResponse<GetCouponUserResponse, NetworkError> {
//        <#code#>
//    }
//
//    func deleteCouponAdmin(clubId: Int, couponId: Int) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
//        <#code#>
//    }
//
//    func deleteCouponMemberAdmin(clubId: Int, couponMemberId: Int) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
//        <#code#>
//    }
//
//    func createCouponAdmin(clubId: Int, param: [String : Any]) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
//        <#code#>
//    }
//
//    func grantCouponAdmin(clubId: Int, couponId: Int, param: [String : Any]) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
//        <#code#>
//    }
//
//    func useCouponUser(clubId: Int, couponId: Int) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
//        <#code#>
//    }
//
//    func updateCouponAdmin(clubId: Int, couponId: Int, param: [String : Any]) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
//        <#code#>
//    }
//}

class CouponService: CouponServiceProtocol {
    
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
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
    
    //  MARK: DELETE
    
    func deleteCouponAdmin(clubId: Int, couponId: Int) async -> DataResponse<DefaultPostResponse, NetworkError> {
        let url = "\(BASE_URL)/clubs/\(clubId)/coupons/\(couponId)/admin"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")"]
        
        let response = await AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(DefaultPostResponse.self).response
        
        return response.mapError { err in
                let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
                return NetworkError(initialError: err, serverError: serverError)
            }
    }
    
    func deleteCouponMemberAdmin(clubId: Int, couponMemberId: Int) async -> DataResponse<DefaultPostResponse, NetworkError> {
        let url = "\(BASE_URL)/clubs/\(clubId)/couponMembers/\(couponMemberId)/admin"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")"]
        
        let response = await AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(DefaultPostResponse.self).response
        
        return response.mapError { err in
                let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
                return NetworkError(initialError: err, serverError: serverError)
            }
    }
    
    //  MARK: POST
    
    func createCouponAdmin(clubId: Int, param: [String: Any]) async -> DataResponse<DefaultPostResponse, NetworkError> {
        let url = "\(BASE_URL)/clubs/\(clubId)/coupons/admin"
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
    
    //  MARK: PUT
    
    func useCouponUser(clubId: Int, couponId: Int) async -> DataResponse<DefaultPostResponse, NetworkError> {
        let url = "\(BASE_URL)/clubs/\(clubId)/coupons/\(couponId)/user"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")"]
        
        
        let response = await AF.request(url, method: .put, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(DefaultPostResponse.self).response
        
        return response.mapError { err in
                let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
                return NetworkError(initialError: err, serverError: serverError)
            }
    }
    
    func updateCouponAdmin(clubId: Int, couponId: Int, param: [String: Any]) async -> DataResponse<DefaultPostResponse, NetworkError>{
        let url = "\(BASE_URL)/clubs/\(clubId)/coupons/\(couponId)/admin"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")"]
        
        
        let response = await AF.request(url, method: .put, parameters: param, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(DefaultPostResponse.self).response
        
        return response.mapError { err in
                let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
                return NetworkError(initialError: err, serverError: serverError)
            }
    }
}
