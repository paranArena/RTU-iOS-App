//
//  ClubProfileViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/10/26.
//

import Foundation

class ClubProfileViewModel: BaseViewModel {
    
    var callbackAlert: CallbackAlert = CallbackAlert()
    var oneButtonAlert: OneButtonAlert = OneButtonAlert()
    let clubSerivce: ClubServiceEnable
    
    init(clubService: ClubServiceEnable) {
        self.clubSerivce = clubService
    }
    
    @MainActor
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError!.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
    
//    func completeButtonTapped(closure: @escaping () -> ()) {
//        callbackAlert.title = "그룹 생성"
//        callbackAlert.messageText = "그룹을 생성하시겠습니까?"
//        callbackAlert.isPresented = true
//        callbackAlert.callback = {
//            closure()
//        }
//    }
    
    show
}


