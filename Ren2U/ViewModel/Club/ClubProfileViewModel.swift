//
//  ClubProfileViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/10/26.
//

import Foundation
import SwiftUI

class ClubProfileViewModel: AlertDelegate {
    
    @Published var selectedUIImage: UIImage?
    @Published var offset: CGFloat = .zero
    @Published var alert: CustomAlert = CustomAlert()
    var alertCase: (any BaseAlert)?
    @Published var clubProfileParam = ClubProfileParam()
    @Published var isShowingTagPlaceholder = true
    
    let mode: Mode
    var clubId: Int?

    private let clubProfileService: ClubProfileServiceEnable
    
    
    //  MARK: post 이니셜라이저
    init(clubService: ClubProfileServiceEnable) {
        self.clubProfileService = clubService
        self.mode = .post
    }
    
    //  MARK: put 이니셜라이저
    init(clubService: ClubProfileServiceEnable, clubId: Int) {
        self.clubProfileService = clubService
        self.clubId = clubId
        self.mode = .put
        
        Task {
            let response = await self.clubProfileService.getClubInfo(clubId: clubId)
            if let error = response.error {
                await self.showAlert(with: error)
            } else if let value = response.value {
                self.clubProfileParam = value.data.extractParam()
            }
        }
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
    func completeButtonTapped(_ closure: @escaping () -> ()) async {
        if self.clubProfileParam.isCreatable {
            if self.mode == .post {
                showAlertWithCancelButton(alertCase: AlertCase.postClub(self.clubProfileService, self.clubProfileParam, showAlert(with:))) {
                    closure()
                }
            } else {
                showAlertWithCancelButton(alertCase: AlertCase.updateClub(clubId ?? -1, self.clubProfileService, self.clubProfileParam, showAlert(with:))) {
                    closure() 
                }
            }
        } else {
            showAlert(alertCase: AlertCase.lackOfInformation)
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
}

extension ClubProfileViewModel {
    enum Mode {
        case post
        case put 
    }
}

extension ClubProfileViewModel {
    enum AlertCase: BaseAlert {
   
        case lackOfInformation
        case postClub(ClubProfileServiceEnable, ClubProfileParam, @MainActor (NetworkError) -> ())
        case updateClub(Int, ClubProfileServiceEnable, ClubProfileParam, @MainActor (NetworkError) -> ())
        
        var alertID: Int {
            switch self {
                
            case .lackOfInformation:
                return 1
            case .postClub(_, _, _):
                return 2
            case .updateClub(_, _, _, _):
                return 3
            }
        }
        
        var title: String {
            switch self {
            case .lackOfInformation:
                return "그룹 생성 불가"
            case .postClub(_, _, _):
                return "그룹 생성"
            case .updateClub(_, _, _, _):
                return "그룹 정보 변경"
            }
        }
        
        var message: String {
            switch self {
            case .lackOfInformation:
                return "그룹명과 소개는 필수입니다."
            case .postClub(_, _, _):
                return "그룹을 생성하시겠습니까?"
            case .updateClub(_, _, _, _):
                return "그룹 정보를 수정하시겠습니까?"
            }
        }
        
        var callback: () async -> () {
            switch self {
                
            case .lackOfInformation:
                return { }
            case let .postClub(service, param, closure):
                return {
                    let response = await service.createClub(data: param)
                    if let error = response.error {
                        await closure(error)
                    }
                }
            case let .updateClub(clubId, service, param, closure):
                return {
                    let response = await service.updateClub(data: param, clubId: clubId)
                    if let error = response.error {
                        await closure(error)
                    }
                }
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


