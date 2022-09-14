//
//  NotificationViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/11.
//

import SwiftUI
import Alamofire

class NotificationViewModel: ObservableObject {
    
    @Published var notificationDetail = NotificationDetailData.dummyNotificationDetailData()
    @Published var isLoading = true 
    
    init(clubId: Int, notificationId: Int)  {
        Task {
            await getNotification(clubId: clubId, notificationId: notificationId)
        }
    }
    
    @MainActor
    func getNotification(clubId: Int, notificationId: Int) async {
        let url = "\(BASE_URL)/clubs/\(clubId)/notifications/\(notificationId)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetNotificationResponse.self)
        let result = await request.result
        isLoading = false
        
        switch result {
        case .success(let value):
            print("[getNotification success")
            print(value.responseMessage)
            self.notificationDetail = value.data
            print(value.data)
            print(value.data.updatedAt)
        case .failure(let err):
            print("[getNotification err]")
            print(err)
        }
        
    }
}
