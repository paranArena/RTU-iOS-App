//
//  MemberManagementVM.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import Foundation
import Alamofire

class ManagementViewModel: ObservableObject {

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
        let response = await request.result
        
        switch response {
        case .success(let value):
            print("공지사항 생성 성공 : \(value)")
        case .failure(let err):
            print("공지사항 생성 실패: \(err)")
        }
    }
    
    //  MARK: GET
    
    //  MARK: TASK
    func createNotification(notice: NotificationModel) {
        Task {
            await createNotification(notice: notice)
        }
    }
    
}
