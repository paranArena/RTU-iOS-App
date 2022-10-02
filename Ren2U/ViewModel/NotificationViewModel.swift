//
//  NotificationViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/11.
//

import SwiftUI
import Alamofire

class NotificationViewModel: ObservableObject {
    
    var clubId: Int?
    
    @Published var notificationDetailData = NotificationDetailData.dummyNotificationDetailData()
    @Published var notificationParam = NotificationParam()
    @Published var isLoading = true
    
    @Published var oneButtonAlert = OneButtonAlert()
    @Published var callbackAlert = CallbackAlert()
    
    var notificationService = NotificationService.shared
    
    // For Create
    init(clubId: Int) {
        self.clubId = clubId
    }
    
    // For Detail & Update
    init(clubId: Int, notificationId: Int)  {
        Task {
            await self.getNotification(clubId: clubId, notificationId: notificationId)
        }
    }
    
    
    @MainActor
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
    
    @MainActor
    func showAlert(message: String) {
        oneButtonAlert.title = ""
        oneButtonAlert.messageText = message
        oneButtonAlert.isPresented = true
    }
    
    @MainActor
    func getNotification(clubId: Int, notificationId: Int) async {
        let response = await notificationService.getNotification(clubId: clubId, notificationId: notificationId)
        if let error = response.error {
            print(response.debugDescription)
            self.showAlert(with: error)
        } else {
            self.notificationDetailData = response.value!.data
        }
    }
    
    func createNotification() async {

        let param: [String: Any] = [
            "title": notificationParam.title,
            "content": notificationParam.content,
            "imagePath" : notificationParam.imagePath
        ]
            
        Task {
            let response = await notificationService.createNotification(clubId: clubId!, param: param)
            if let error = response.error {
                print(response.debugDescription)
                await self.showAlert(with: error)
            } else {
                await self.showAlert(message: response.value!.responseMessage)
            }
        }
    }
}
