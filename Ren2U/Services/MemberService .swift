//
//  MemberService .swift
//  Ren2U
//
//  Created by 노우영 on 2022/10/14.
//

import Alamofire
import Foundation

protocol MemberServiceProtocol: BaseService {
    func login(param: [String: Any]) async -> DataResponse<LoginResponse, NetworkError>
    func getMyInfo() async -> DataResponse<GetMyInfoResponse, NetworkError>
    func getMyClubs() async -> DataResponse<GetMyClubsResponse, NetworkError>
    func getMyRentals() async -> DataResponse<GetMyRentalsResponse, NetworkError>
    func getMyNotifications() async -> DataResponse<GetMyNotificationsResponse, NetworkError>
    func getMyProducts() async -> DataResponse<GetMyProductsResponse, NetworkError>
}

class MockupMemberService: MemberServiceProtocol {
    var bearerToken: String?
    var url: String?
    
    func login(param: [String : Any]) async -> Alamofire.DataResponse<LoginResponse, NetworkError> {
        let result = Result {
            return LoginResponse(token: "error token")
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func getMyInfo() async -> Alamofire.DataResponse<GetMyInfoResponse, NetworkError> {
        let result = Result {
            return GetMyInfoResponse(statusCode: 200, responseMessage: "", data: UserData.dummyUserData())
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func getMyClubs() async -> Alamofire.DataResponse<GetMyClubsResponse, NetworkError> {
        let result = Result {
            return GetMyClubsResponse(statusCode: 200, responseMessage: "", data: ClubAndRoleData.dummyClubAndRoleDatas())
        }.mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func getMyRentals() async -> Alamofire.DataResponse<GetMyRentalsResponse, NetworkError> {
        let result = Result {
            return GetMyRentalsResponse(statusCode: 200, responseMessage: "", data: RentalData.dummyRentalDatas())
        }.mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func getMyNotifications() async -> Alamofire.DataResponse<GetMyNotificationsResponse, NetworkError> {
        let result = Result {
            return GetMyNotificationsResponse(statusCode: 200, responseMessage: "", data: NotificationPreviewData.dummyNotifications())
        }.mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0.0, result: result)
    }
    
    func getMyProducts() async -> Alamofire.DataResponse<GetMyProductsResponse, NetworkError> {
        let result = Result {
            return GetMyProductsResponse(statusCode: 200, responseMessage: "", data: ProductPreviewDto.dummyProductPreviewDtoDatas())
        }.mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0.0, result: result)
    }
    
    
}

class MemberService: MemberServiceProtocol {
    let url: String?
    let bearerToken: String?
    
    init(url: String) {
        self.url = url
        self.bearerToken = UserDefaults.standard.string(forKey: JWT_KEY)
    }
    
    
    func getMyInfo() async -> Alamofire.DataResponse<GetMyInfoResponse, NetworkError> {
        let url = "\(url!)/members/my/info"
        let hearders: HTTPHeaders = [.authorization(bearerToken: self.bearerToken ?? "")]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyInfoResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }

    func login(param: [String : Any]) async -> Alamofire.DataResponse<LoginResponse, NetworkError> {
        let url = "\(url!)/authenticate"
        
        let response = await AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).serializingDecodable(LoginResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func getMyClubs() async -> Alamofire.DataResponse<GetMyClubsResponse, NetworkError> {
        let url = "\(url!)/members/my/clubs"
        let hearders: HTTPHeaders = [.authorization(bearerToken: self.bearerToken ?? "")]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyClubsResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func getMyRentals() async -> Alamofire.DataResponse<GetMyRentalsResponse, NetworkError> {
        let url = "\(url!)/members/my/rentals"
        let hearders: HTTPHeaders = [.authorization(bearerToken: self.bearerToken ?? "")]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyRentalsResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func getMyNotifications() async -> Alamofire.DataResponse<GetMyNotificationsResponse, NetworkError> {
        let url = "\(url!)/members/my/notifications"
        let hearders: HTTPHeaders = [.authorization(bearerToken: self.bearerToken ?? "")]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyNotificationsResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func getMyProducts() async -> Alamofire.DataResponse<GetMyProductsResponse, NetworkError> {
        let url = "\(url!)/members/my/products"
        let hearders: HTTPHeaders = [.authorization(bearerToken: self.bearerToken ?? "")]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyProductsResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    
}

