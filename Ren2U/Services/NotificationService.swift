//
//  NotificationService.swift
//  Ren2U
//
//  Created by 노우영 on 2022/10/02.
//

import Foundation
import Alamofire

class NotificationService {
    
    static let shared = NotificationService()
    
    func getNotification(clubId: Int, notificationId: Int) async -> DataResponse<GetNotificationResponse, NetworkError> {
        
        let url = "\(BASE_URL)/clubs/\(clubId)/notifications/\(notificationId)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetNotificationResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func createNotification(clubId: Int, param: [String: Any]) async -> DataResponse<DefaultPostResponse, NetworkError>{
        let url = "\(BASE_URL)/clubs/\(clubId)/notifications"
        let hearders: HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")",
        ]
        
        let response = await AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(DefaultPostResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func updateNotification(clubId: Int, notificationId: Int, param: [String: Any]) async -> DataResponse<DefaultPostResponse, NetworkError>{
        
        let url = "\(BASE_URL)/clubs/\(clubId)/notifications/\(notificationId)"
        let hearders: HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")",
        ]
        
        let response = await AF.request(url, method: .put, parameters: param, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(DefaultPostResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
}
