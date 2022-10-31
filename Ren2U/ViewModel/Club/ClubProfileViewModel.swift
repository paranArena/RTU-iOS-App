//
//  ClubProfileViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/10/26.
//

import Foundation

class ClubProfileViewModel: BaseViewModel {

    @Published var callbackAlert: CallbackAlert = CallbackAlert()
    @Published var oneButtonAlert: OneButtonAlert = OneButtonAlert()
    @Published var clubProfileParam = ClubProfileParam()
    
    let clubProfileService: ClubProfileServiceEnable

    init(clubService: ClubProfileServiceEnable) {
        self.clubProfileService = clubService
    }

    @MainActor
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError!.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
    
    @MainActor
    func completeButtonTapped(closure: @escaping () -> ()) {
        if self.clubProfileParam.isCreatable {
            callbackAlert.title = "그룹 생성"
            callbackAlert.messageText = "그룹을 생성하시겠습니까?"
            callbackAlert.isPresented = true
            callbackAlert.callback = {
                await self.createClub()
                closure()
            }
        } else {
            oneButtonAlert.title = "정보 입력"
            oneButtonAlert.messageText = "그룹의 이름과 소개는 필수입니다."
            oneButtonAlert.isPresented = true 
        }
    }
    
    func hashtagEditEnded() {
        
        let splited = clubProfileParam.hashtagText.split(separator: " ")
        
        for element in splited {
            var hashtag = element
            if hashtag.first == "#" {
                hashtag.removeFirst()
                if !hashtag.isEmpty {
                    clubProfileParam.hashtags.append(String(hashtag))
                }
            }
        }
        
        self.clubProfileParam.hashtagText = ""
    }
    
    private func createClub() async {
        let response = await clubProfileService.createClub(data: clubProfileParam)
        if let error = response.error {
            await self.showAlert(with: error)
        } 
    }
}


