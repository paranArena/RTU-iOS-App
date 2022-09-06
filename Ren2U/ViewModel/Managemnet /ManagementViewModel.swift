//
//  MemberManagementVM.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import Foundation
import Alamofire
import UIKit

class ManagementViewModel: ObservableObject {
    
    @Published var clubData = ClubData.dummyClubData()
    
    @Published var applicants = [UserData]()
    @Published var members = [UserAndRoleData]()
    @Published var products = [ProductResponseData]()
    
    
    init(clubData: ClubData) {
        self.clubData = clubData
        print("ManageViewModel init, groupId[\(clubData.id)]")
    }
    
    //  MARK: POST
    func createNotification(notice: NotificationModel) async {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/notifications"
        let hearders: HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY)!)",
            "Content-type": "multipart/form-data"
        ]
        
        let param: [String: Any] = [
            "title": notice.title,
            "content": notice.content,
        ]
            
        let task = AF.upload(multipartFormData: { multipart in
            if let image = notice.image {
                multipart.append(image.jpegData(compressionQuality: 1)!, withName: "image", fileName: "\(self.clubData.id).\(notice.title).image", mimeType: "image/jpeg")
            }

            for (key, value) in param {
                if key == "hashtags" {
                    for v in value as! [String] {
                        multipart.append(Data(v.utf8), withName: key)
                    }
                } else {
                    multipart.append(Data(String("\(value)").utf8), withName: key)
                }
            }
            

        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: hearders).serializingDecodable(CreateNotificationResponse.self)
        
        
        switch await task.result {
        case .success(let value):
            print("[createNotification success]")
            print(value.responseMessage)
        case .failure(let err):
            print("[createNotification err]")
            print(err)
        }
    }
    
    func acceptClubJoin(userData: UserData) async {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/requests/join/\(userData.id)"
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
    
    @MainActor
    func searchClubProductsAll(clubId: Int) {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/products/search/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).responseString { res in
            switch res.result {
            case .success(let value):
                print("[searchClubProductsAll success]")
                print(value)
            case .failure(let err):
                print("[searchClubProductsAll err]")
                print(err)
            }
        }
    }
    
    func applyRent(clubId: Int, itemId: Int) {
        let url = "\(BASE_URL)/clubs/\(clubId)/apply/rent/\(itemId)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: hearders).responseString { res in
            switch res.result {
            case .success(let value):
                print("[applyRent success]")
                print(value)
            case .failure(let err):
                print("[applyRent err]")
                print(err)
            }
        }
    }
    
    //  MARK: GET
    
    @MainActor
    func searchClubMembersAll() async {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/members/search/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(SearchClubMembersAllResponse.self)
        let result = await request.result
        
        switch result {
        case .success(let value):
            print("[searchClubMembersAll success]")
            print(value.responseMessage)
            self.members = value.data
        case .failure(let err):
            print("[seaerchClubMembersAll err]")
            print(err)
        }
        
    }
    
    @MainActor
    func searchClubJoinsAll() async {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/requests/join/search/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(SearchClubJoinsAllResponse.self)
        let result = await request.result
        
        switch result {
        case .success(let value):
            print("[searchClubJoinsAll success]")
            print(value.responseMessage)
            self.applicants = value.data
        case .failure(let err):
            print("searchClubJoinsAll 실패 : \(err)")
            print(err)
        }
    }
    
    @MainActor
    func searchClubProductsAll() async {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/products/search/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        //  MARK: 수정 필요
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingString()
    }
    
    //  MARK: PUT
    func updateNotification(groupId: Int, notificationId: Int, noticeData: NoticeCellData) async {
        let url = "\(BASE_URL)/clubs/\(groupId)/notifications/\(notificationId)"
        let hearders: HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY)!)",
            "Content-type": "multipart/form-data"
        ]
        
//        let param: [String: Any] = [
//            "title" : noticeData.title,
//            "content" : noticeData.id
//        ]
        
        let request = AF.request(url, method: .put, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let result = await request.result
        
        switch result {
        case .success(_):
            print("deleteNotification Success")
        case .failure(let err):
            print("deleteNotification Err : \(err)")
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
