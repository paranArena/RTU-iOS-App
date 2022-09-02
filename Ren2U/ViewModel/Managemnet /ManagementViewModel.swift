//
//  MemberManagementVM.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import Foundation
import Alamofire

class ManagementViewModel: ObservableObject {
    
    @Published var applicants = [UserData]()
    var groupId = 0
    
    init(groupId: Int) {
        self.groupId = groupId
        print("ManageViewModel init, groupId[\(groupId)]")
    }
    //  MARK: POST
    func createNotification(notice: NotificationModel) async {
        let url = "\(BASE_URL)/clubs/\(groupId)/notifications"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        let param: [String: Any] = [
            "title" : notice.title,
            "content" : notice.content
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
        let url = "\(BASE_URL)/clubs/\(groupId)/requests/join/\(userData.id)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .post, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let result = await request.result
        
        switch result {
        case .success(let value):
            print("acceptClubJoin Success : \(value)")
        case .failure(let err):
            print("클럽 가입 수락 실패 : \(err)")
        }
    }
    
    //  MARK: GET
    
    @MainActor
    func searchClubJoinsAll() async {
        let url = "\(BASE_URL)/clubs/\(groupId)/requests/join/search/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(SearchClubJoinsAllResponse.self)
        let result = await request.result
        
        switch result {
        case .success(let value):
            print("클럽 가입 조회 성공")
            self.applicants = value.data
        case .failure(let err):
            print("searchClubJoinsAll 실패 : \(err)")
        }
    }
    
    //  MARK: DELETE
    func deleteNotification(groupID: Int, notificationID: Int) async {
        let url = "\(BASE_URL)/clubs/\(groupID)/notifications/\(notificationID)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let result = await request.result
        
        switch result {
        case .success(_):
            print("deleteNotification Success")
        case .failure(let err):
            print("deleteNotification Err : \(err)")
        }
        
        
    }
    
    //  MARK: TASK
    func createNotificationTask(notice: NotificationModel) {
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
    
    func deleteNotificationTask(groupID: Int, notificationID: Int) {
        Task {
            await deleteNotification(groupID: groupID, notificationID: notificationID)
        }
    }
    
}
