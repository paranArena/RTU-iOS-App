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
    
    func createCouponAdmin(clubId: Int, param: [String: Any]) -> AnyPublisher<DataResponse<DefaultPostResponse, NetworkError>, Never> {
        let url = "\(BASE_URL)/clubs/\(clubId)/coupon/admin"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")"]
        
        return AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: hearders)
            .validate()
            .publishDecodable(type: DefaultPostResponse.self)
            .map { resonse in
                resonse.mapError { err in
                    let serverError = resonse.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0)}
                    return NetworkError(initialError: err, serverError: serverError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getClubCouponsAdmin(clubId: Int) -> AnyPublisher<DataResponse<GetClubCouponsAdminResponse, NetworkError>, Never>  {
        let url = "\(BASE_URL)/clubs/\(clubId)/coupons/admin"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")"]
        
        return AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders)
            .validate()
            .publishDecodable(type: GetClubCouponsAdminResponse.self)
            .map { resonse in
                resonse.mapError { err in
                    let serverError = resonse.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0)}
                    return NetworkError(initialError: err, serverError: serverError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
    func grantCouponAdmin(clubId: Int, couponId: Int, param: [String: Any]) -> AnyPublisher<DataResponse<DefaultPostResponse, NetworkError>, Never> {
        let url = "\(BASE_URL)/clubs/\(clubId)/coupons/\(couponId)/admin"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")"]
        
        return AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: hearders)
            .validate()
            .publishDecodable(type: DefaultPostResponse.self)
            .map { resonse in
                resonse.mapError { err in
                    let serverError = resonse.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0)}
                    return NetworkError(initialError: err, serverError: serverError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
