//
//  CreateNotificationViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/10/09.
//

import Alamofire
import SwiftUI

class CreateNotificationViewModel: BaseViewModel {
    
    let clubId: Int
    var notificationId: Int?
    let method: Method
    var notificationDetailData: NotificationDetailData?
    
    var isPostMode: Bool {
        return self.method == .post
    }
    var isPutMode: Bool {
        return self.method == .put
    }
    
    @Published var notificationParam = NotificationParam()
    @Published var uiImage: UIImage?
    
    @Published var twoButtonsAlert: TwoButtonsAlert = TwoButtonsAlert()
    @Published var oneButtonAlert: OneButtonAlert = OneButtonAlert()
    var alertCase: AlertCase?
    
    var notificationService = NotificationService.shared
    let clubNotificationService: ClubNotificationServiceEnable
    
    
    //  MARK: For Create
    init(clubId: Int, method: Method, clubNotificationService: ClubNotificationServiceEnable) {
        self.clubId = clubId
        self.method = method
        self.clubNotificationService = clubNotificationService
    }
    
    //  MARK: For Update
    
    @MainActor
    init(clubId: Int, notificationId: Int, method: Method, clubNotificationService: ClubNotificationServiceEnable) {
        self.clubId = clubId
        self.notificationId = notificationId
        self.method = method
        self.clubNotificationService = clubNotificationService
        
        Task {
            await self.getNotification()
            self.notificationParam = notificationDetailData?.toParam() ?? NotificationParam()
        }
    }
    
    @MainActor
    private func showAlert(alertCase: AlertCase) {
        self.alertCase = alertCase
        self.oneButtonAlert.title = self.title
        self.oneButtonAlert.messageText = self.message
        self.oneButtonAlert.callback = { await self.callback() }
        self.oneButtonAlert.isPresented = true
    }
    
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError!.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
    
    @MainActor
    private func showTwoButtonsAlert(alertCase: AlertCase) {
        self.alertCase = alertCase
        self.twoButtonsAlert.title = self.title
        self.twoButtonsAlert.messageText = self.message
        self.twoButtonsAlert.callback = { await self.callback() }
        self.twoButtonsAlert.isPresented = true
    }
    
    @MainActor
    func completeButtonTapped() {
        if isPostMode {
            if self.notificationParam.isCreatable {
                showTwoButtonsAlert(alertCase: .postNotification)
            } else {
                showAlert(alertCase: .lackOfInformation)
            }
        } else {
            if self.notificationParam.isCreatable {
                showTwoButtonsAlert(alertCase: .putNotification)
            } else {
                showAlert(alertCase: .lackOfInformation)
            }
        }
    }
    
    @MainActor
    func showUpdateNoficiationAlert() {
        twoButtonsAlert.title = ""
        twoButtonsAlert.messageText = "공지사항을 수정하시겠습니까?"
        twoButtonsAlert.callback = { await self.updateNofication() }
        twoButtonsAlert.isPresented = true
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

extension CreateNotificationViewModel {
    
    enum AlertCase {
        case postNotification
        case putNotification
        case lackOfInformation
    }
    
    var title: String {
        switch self.alertCase {
            
        case .none:
            return ""
        case .postNotification:
            return "공지사항 생성"
        case .putNotification:
            return "공지사항 수정"
        case .lackOfInformation:
            return "공지사항 생성불가"
        }
    }
    
    var message: String {
        switch self.alertCase {
            
        case .none:
            return ""
        case .postNotification:
            return "공지사항을 생성하시겠습니까?"
        case .putNotification:
            return "공지사항을 수정하시겠습니까?"
        case .lackOfInformation:
            return "제목과 내용을 필수입니다."
            
        }
    }
    
    var callback: () async -> () {
        switch self.alertCase {
        case .none:
            return { }
        case .postNotification:
            return {
                let response = await self.clubNotificationService.createNotification(clubId: self.clubId, data: self.notificationParam)
                if let error = response.error {
                    await self.showAlert(with: error)
                }
            }
        case .putNotification:
            return {
                let response = await self.clubNotificationService.updateNotification(clubId: self.clubId, notificationId: self.notificationId ?? -1, data: self.notificationParam)
                if let error = response.error { await self.showAlert(with: error) }
            }

        case .lackOfInformation:
            return { } 
        }
    }
    
}
