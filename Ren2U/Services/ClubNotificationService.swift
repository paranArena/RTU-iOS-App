//
//  ClubNotificationService.swift
//  Ren2U
//
//  Created by 노우영 on 2022/11/17.
//

import Foundation
import Alamofire

protocol ClubNotificationServiceEnable: BaseServiceEnable {
    func createNotification(clubId: Int, data: NotificationParam) async -> DataResponse<String, NetworkError>
    func getNotification(clubId: Int, notificationId: Int) async -> DataResponse<GetNotificationResponse, NetworkError>
    func updateNotification(clubId: Int, notificationId: Int, data: NotificationParam) async -> DataResponse<DefaultPostResponse, NetworkError>
}

class MockupClubNotificationService: ClubNotificationServiceEnable {
    func createNotification(clubId: Int, data: NotificationParam) async -> Alamofire.DataResponse<String, NetworkError> {
        let result = Result {
            return ""
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func getNotification(clubId: Int, notificationId: Int) async -> Alamofire.DataResponse<GetNotificationResponse, NetworkError> {
        let result = Result {
            return GetNotificationResponse(statusCode: 200, responseMessage: "", data: NotificationDetailData.dummyNotificationDetailData())
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func updateNotification(clubId: Int, notificationId: Int, data: NotificationParam) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
        let result = Result {
            return DefaultPostResponse(statusCode: 200, responseMessage: "", data: nil)
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    var url: String?
    var bearerToken: String?
}

class ClubNotificationService: ClubNotificationServiceEnable {
    func createNotification(clubId: Int, data: NotificationParam) async -> Alamofire.DataResponse<String, NetworkError> {
        
        let url = "\(self.url!)/api/v1/clubs/\(clubId)/notifications"
        let headers: HTTPHeaders = [
            .authorization(bearerToken: self.bearerToken!)
        ]
        
        var imagePaths = [String]()
        if !data.imagePath.isEmpty {
            imagePaths.append(data.imagePath)
        }
        
        let param: [String: Any] = [
            "title" : data.title,
            "content" : data.content,
            "imagePaths" : imagePaths
        ]
        
        let response = await AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).serializingString().response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func getNotification(clubId: Int, notificationId: Int) async -> Alamofire.DataResponse<GetNotificationResponse, NetworkError> {
        
        let url = "\(self.url!)/clubs/\(clubId)/notifications/\(notificationId)"
        let headers: HTTPHeaders = [
            .authorization(bearerToken: self.bearerToken!)
        ]
        
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).serializingDecodable(GetNotificationResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func updateNotification(clubId: Int, notificationId: Int, data: NotificationParam) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
        
        let url = "\(self.url!)/clubs/\(clubId)/notifications/\(notificationId)"
        let headers: HTTPHeaders = [
            .authorization(bearerToken: self.bearerToken!)
        ]
        
        let param: [String : Any] = [
            "title" : data.title,
            "content" : data.content,
            "imagePaths" : data.imagePath,
            "isPublic" : true
        ]
        
        let response = await AF.request(url, method: .put, parameters: param, encoding: JSONEncoding.default, headers: headers).serializingDecodable(DefaultPostResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    var url: String?
    var bearerToken: String?
    
    init(url: String) {
        self.url = url
        self.bearerToken = UserDefaults.standard.string(forKey: JWT_KEY)
    }
}
