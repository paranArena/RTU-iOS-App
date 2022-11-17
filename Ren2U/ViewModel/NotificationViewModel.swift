//
//  NotificationViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/11.
//

import SwiftUI
import Alamofire

class NotificationViewModel: BaseViewModel {
    
    @Published var twoButtonsAlert = TwoButtonsAlert()
    @Published var oneButtonAlert = OneButtonAlert()
    
    var clubId: Int?
    
    @Published var notificationDetailData = NotificationDetailData.dummyNotificationDetailData()
    @Published var isLoading = true
    
    @Published var callbackAlert = TwoButtonsAlert()
    
    let clubNotificationService: ClubNotificationServiceEnable
    
    // For Detail & Update
    init(clubId: Int, notificationId: Int, clubNotificationService: ClubNotificationServiceEnable)  {
        self.clubNotificationService = clubNotificationService
        Task {
            await self.getNotification(clubId: clubId, notificationId: notificationId)
        }
    }
    
    
    @MainActor
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError!.localizedDescription : error.serverError!.message
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
        
        let response = await clubNotificationService.getNotification(clubId: clubId, notificationId: notificationId)
        if let error = response.error {
            self.showAlert(with: error)
        } else if let value = response.value {
            self.notificationDetailData = value.data
        }
        
        isLoading = false
    }
}
