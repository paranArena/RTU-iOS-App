//
//  CreateNotificationViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/10/09.
//

import Alamofire
import SwiftUI

class CreateNotificationViewModel: ObservableObject, BaseViewModel {
    
    let clubId: Int
    var notificationId: Int?
    let method: Method
    var notificationDetailData: NotificationDetailData? 
    
    @Published var notificationParam = NotificationParam()
    @Published var callbackAlert: CallbackAlert = CallbackAlert()
    @Published var oneButtonAlert: OneButtonAlert = OneButtonAlert()
    
    var notificationService = NotificationService.shared
    
    
    //  MARK: For Create
    init(clubId: Int, method: Method) {
        self.clubId = clubId
        self.method = method
    }
    
    //  MARK: For Update
    
    @MainActor
    init(clubId: Int, notificationId: Int, method: Method) {
        self.clubId = clubId
        self.notificationId = notificationId
        self.method = method
        
        Task {
            await self.getNotification()
            self.notificationParam = notificationDetailData?.toParam() ?? NotificationParam()
        }
    }
    
    

    
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
    
    @MainActor
    func showUpdateNoficiationAlert() {
        callbackAlert.title = ""
        callbackAlert.messageText = "공지사항을 수정하시겠습니까?"
        callbackAlert.callback = { await self.updateNofication() }
        callbackAlert.isPresented = true
    }
    
    private func updateNofication() async {
        
        var imagePaths = [String]()
        if !notificationParam.imagePath.isEmpty {
            imagePaths.append(notificationParam.imagePath)
        }
        
        let param: [String : Any] = [
            "title" : notificationParam.title,
            "content" : notificationParam.content,
            "imagePaths" : imagePaths,
            "isPublic" : true
        ]
        
        let response = await notificationService.updateNotification(clubId: clubId, notificationId: notificationId!, param: param)
        
        if let error = response.error {
            await showAlert(with: error)
        } else {
            print("update notification success")
        }
    }
    
    func createNotification() async {
        
        var imagePaths = [String]()
        if !notificationParam.imagePath.isEmpty {
            imagePaths.append(notificationParam.imagePath)
        }
        
        let param: [String: Any] = [
            "title": notificationParam.title,
            "content": notificationParam.content,
            "imagePaths" : imagePaths
        ]
            
        Task {
            let response = await notificationService.createNotification(clubId: clubId, param: param)
            if let error = response.error {
                await self.showAlert(with: error)
            } else {
                print("createNotification success")
            }
        }
    }
    
    @MainActor
    private func getNotification() async {
        let response = await notificationService.getNotification(clubId: clubId, notificationId: notificationId!)
        if let error = response.error {
            print(response.debugDescription)
            self.showAlert(with: error)
        } else {
            print("getNotification success")
            self.notificationDetailData = response.value!.data
        }
    }
}
