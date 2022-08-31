//
//  MemberManagementVM.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import Foundation
import Alamofire

class ManagementViewModel: ObservableObject {
    
    @Published var members = [UserData]()
    var groupId = 0
    
    init(groupId: Int) {
        self.groupId = groupId
        print("[ManageViewModel] groupId : \(groupId)")
    }
    //  MARK: POST
    func createNotification(notice: NotificationModel) async {
        let url = "\(baseURL)/clubs/\(groupId)/notifications"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: jwtKey)!)]
        let param: [String: Any] = [
            "title" : notice.content,
            "content" : notice.title
        ]
        
        let request = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let result = await request.result
        
        switch result {
        case .success(let value):
            print("공지사항 생성 성공 : \(value)")
        case .failure(let err):
            print("공지사항 생성 실패: \(err)")
        }
    }
    
    func acceptClubJoin(userData: UserData) async {
        let url = "\(baseURL)/clubs/\(groupId)/requests/join/\(userData.id)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: jwtKey)!)]
        
        let request = AF.request(url, method: .post, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let reuslt = await request.result
        
        switch reuslt {
        case .success(_):
            print("클럽 가입 수락 성공")
        case .failure(let err):
            print("클럽 가입 수락 실패 : \(err)")
        }
    }
    
    //  MARK: GET
    
    @MainActor
    func searchClubJoinsAll() async {
        let url = "\(baseURL)/clubs/\(groupId)/requests/join/search/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: jwtKey)!)]
        
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(SearchClubJoinsAllResponse.self)
        let response = await request.result
        
        switch response {
        case .success(let value):
            print("클럽 가입 조회 성공")
            self.members = value.data
        case .failure(let err):
            print("searchClubJoinsAll 실패 : \(err)")
        }
    }
    
    
    //  MARK: TASK
    func createNotification(notice: NotificationModel) {
        Task {
            await createNotification(notice: notice)
        }
    }
    
    func searchClubJoinsAllTask() {
        Task {
            await searchClubJoinsAll()
        }
    }
    
    func acceptClubJoinTask(userData: UserData) {
        Task {
            await acceptClubJoin(userData: userData)
        }
    }
    
}
