//
//  ClubSearchViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/17.
//

import SwiftUI
import Alamofire

class ClubSearchViewModel: ObservableObject, BaseViewModel {
    
    @Published var clubData = [ClubAndRoleData]()
    @Published var callbackAlert: CallbackAlert = CallbackAlert()
    @Published var oneButtonAlert: OneButtonAlert = OneButtonAlert()
    
    let clubService: ClubServiceEnable
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var isSearchDelayComplted: Bool = false
    
    init(clubService: ClubServiceEnable) {
        self.clubService = clubService
    }
    
    
    @MainActor
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError!.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }

    
    @MainActor
    func getMyClubRole(clubId: Int) async -> String {
        let url = "\(BASE_URL)/members/my/clubs/\(clubId)/role"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "" )"]
        
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyClubRoleResponse.self)
        
        let result = await request.result
        
        switch result {
        case .success(let value):
            print("[getMyClubRole success]")
            print(value.responseMessage)
            return value.data.clubRole
        case .failure(let err):
            print("[getMyClubs Error]")
            print(err)
            return "err"
        }
    }
    
    @MainActor
    func searchWithDelay(text: String) async {
        guard !isSearchDelayComplted && !text.isEmpty else { return }
        self.isSearchDelayComplted = true
        
        self.clearClubData()
        let responseWithName = await clubService.searchClubsWithName(groupName: text)
        let responseWithHashtag = await clubService.searchClubWithHashTag(hashtag: text)
        
        if let error = responseWithName.error {
            self.showAlert(with: error)
        } else {
            self.clubData.append(contentsOf: responseWithName.value!.data)
        }
        
        if let error = responseWithHashtag.error {
            self.showAlert(with: error)
        } else {
            for club in responseWithHashtag.value!.data {
                if !clubData.contains(club) {
                    clubData.append(club)
                }
            }
        }
    }
    
    @MainActor
    func searchBarTapped(text: String) async {
        guard text.isEmpty else { return }
        
        let response = await clubService.searchClubsAll()
        if let error = response.error {
            self.showAlert(with: error)
        } else {
            self.clubData = response.value!.data
        }
        
    }
    
    func clearClubData() {
        self.clubData = [ClubAndRoleData]()
    }
    
    func requestClubJoin(clubId: Int) async {
        
        let url = "\(BASE_URL)/clubs/\(clubId)/requests/join"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "" )]
        
        let task = AF.request(url, method: .post, encoding: JSONEncoding.default, headers:  hearders).serializingDecodable(requestClubJoinResponse.self)
        let result = await task.result
    }

}
