//
//  ClubProfileViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/10/26.
//

import Foundation

class ClubProfileViewModel: AlertDelegate {
    
    @Published var alert: CustomAlert = CustomAlert()
    var alertCase: (any BaseAlert)?
    @Published var clubProfileParam = ClubProfileParam()
    @Published var isShowingTagPlaceholder = true

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
    func completeButtonTapped() async {
        if self.clubProfileParam.isCreatable {
            showAlertWithCancelButton(alertCase: AlertCase.postClub(self.clubProfileService, self.clubProfileParam, showAlert(with:)))
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
    enum AlertCase: BaseAlert {
   
        case lackOfInformation
        case postClub(ClubProfileServiceEnable, ClubProfileParam, (NetworkError) -> Void)
        
        var alertID: Int {
            switch self {
                
            case .lackOfInformation:
                return 1
            case .postClub(_, _, _):
                return 2 
            }
        }
        
        var title: String {
            switch self {
            case .lackOfInformation:
                return "그룹 생성 불가"
            case .postClub(_, _, _):
                return "그룹 생성"
            }
        }
        
        var message: String {
            switch self {
            case .lackOfInformation:
                return "그룹명과 소개는 필수입니다."
            case .postClub(_, _, _):
                return "그룹을 생성하시겠습니까?"
            }
        }
        
        var callback: () async -> () {
            switch self {
                
            case .lackOfInformation:
                return { }
            case .postClub(let service, let param, let closure):
                return {
                    let response = await service.createClub(data: param)
                    if let error = response.error {
                        closure(error)
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


