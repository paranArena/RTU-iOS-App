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
    @Published var isShowingTagPlaceholder = true
    
    var alertCase: AlertCase?
    
    private let clubProfileService: ClubProfileServiceEnable

    init(clubService: ClubProfileServiceEnable) {
        self.clubProfileService = clubService
    }
    
    func focusFieldChanged(focusedField: Field) {
        if focusedField == .tag {
            self.isShowingTagPlaceholder = false
        } else {
            guard self.clubProfileParam.hashtagText.isEmpty else { return }
            isShowingTagPlaceholder = true
        }
    }
    
    func xmarkTapped(index: Int) {
        clubProfileParam.hashtags.remove(at: index)
    }

    @MainActor
    internal func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError!.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
    
    @MainActor
    private func showAlert(selectedCase: AlertCase) {
        alertCase = selectedCase
        if let alertCase = self.alertCase {
            oneButtonAlert.title = alertCase.title
            oneButtonAlert.messageText = alertCase.message
            oneButtonAlert.isPresented = true
            oneButtonAlert.callback = { self.alertCase = nil }
        }
    }
    
    @MainActor
    func completeButtonTapped(closure: @escaping () -> ()) async {
        if self.clubProfileParam.isCreatable {
            let response = await clubProfileService.createClub(data: self.clubProfileParam)
            if let error = response.error {
                self.showAlert(with: error)
            } else {
                closure()
            }
        } else {
            showAlert(selectedCase: .lackOfInformation)
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

extension ClubProfileViewModel {
    enum AlertCase {
        case lackOfInformation

        var title: String {
            switch self {
            case .lackOfInformation:
                return "그룹 생성 불가"
            }
        }
        
        var message: String {
            switch self {
                
            case .lackOfInformation:
                return "그룹명과 소개는 필수입니다."
            }
        }
    }
}

extension ClubProfileViewModel {
    enum Field: CaseIterable {
        case name
        case tag
        case introduction 
    }
}


