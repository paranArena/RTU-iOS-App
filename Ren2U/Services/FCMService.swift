//
//  FCMService.swift
//  Ren2U
//
//  Created by 노우영 on 2022/11/22.
//

import Foundation
import Alamofire

protocol FCMServiceEnable: BaseServiceEnable {
    func registerFCMToken(memberId: Int, fcmToken: String) async -> DataResponse<DefaultPostResponse, NetworkError>
}

class FCMService: FCMServiceEnable {
    func registerFCMToken(memberId: Int, fcmToken: String) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
        
        let url = "\(self.url!)/api/fcm/register"
        let headers: HTTPHeaders = [
            .authorization(bearerToken: self.bearerToken!)
        ]
        let param: [String: Any] = [
            "memberId" : memberId,
            "fcmToken" : fcmToken
        ]
        
        let response = await AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).serializingDecodable(DefaultPostResponse.self).response
        
        print("FCM : \(response.debugDescription)")
        
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
