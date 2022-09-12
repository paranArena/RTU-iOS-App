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
    @Published var products = [ProductPreviewDto]()
    @Published var notices = [NotificationPreview]()
    @Published var rentals = [ClubRentalData]()
    
    
    init(clubData: ClubData) {
        self.clubData = clubData
        print("ManageViewModel init, groupId[\(clubData.id)]")
        
        Task {
            await searchClubMembersAll()
            await searchClubJoinsAll()
            await searchClubProductsAll()
            await searchNotificationsAll()
            await searchClubRentalsAll()
        }
    }
    
    //  MARK: LOCAL
    
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
                print("이미지를 넣었어요")
                multipart.append(image.jpegData(compressionQuality: 1)!, withName: "image", fileName: "\(self.clubData.id).\(notice.title).image", mimeType: "image/jpeg")
            }

            for (key, value) in param {
                    multipart.append(Data(String("\(value)").utf8), withName: key)
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
    
    func acceptClubJoin(memberId: Int) async {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/requests/join/\(memberId)"
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
    func searchClubProductsAll()  {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/products/search/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).responseDecodable(of: SearchClubProductsAll.self) {
            res in
            
            switch res.result {
            case .success(let value):
                print("[searchClubProductsAll success]")
                self.products = value.data
            case .failure(let err):
                print("[searchClubProductsAll failure]")
                print(err)
            }
            
        }
    }
    
    @MainActor
    func searchNotificationsAll() {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/notifications/search/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).responseDecodable(of: SearchNotificationsAllResponse.self) { res in
            
            switch res.result {
            case .success(let value):
                print("[searchNotificationsAll success]")
                print(value.responseMessage)
                self.notices = value.data.reversed()
                
            case .failure(let err):
                print("[searchNotificationsAll err")
                print(err)
            }
        }
    }
    
    @MainActor
    func searchClubRentalsAll() {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/rentals/search/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let decoder = JSONDecoder()

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            throw DateError.invalidDate
        })

        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).responseDecodable(of: SearchClubRentalsAllResponse.self) { res in
            switch res.result {
            case .success(let value):
                print("[searchClubRentalsAll success]")
                print(value.responseMessage)
                self.rentals = value.data
                
            case .failure(let err):
                print("[searchClubRentalsAll err]")
                print(err)
            }
        }
    }
    
    //  MARK: PUT
    func updateNotification(groupId: Int, notificationId: Int, noticeData: NotificationPreview) async {
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
    func rejectClubJoin(memberId: Int) async {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/requests/join/\(memberId)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        
        let request = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let result = await request.result
        
        switch result {
        case .success(_):
            print("[rejectClubJoin Success]")
        case .failure(_):
            print("[rejectClubJoin err]")
        }
        
    }
    
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
    
    
    func deleteProduct(productId: Int) async {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/products/\(productId)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: hearders).serializingString()
        
        let result = await request.result
        
        switch result {
        case .success(let value):
            print("[deleteProduct success]")
            print(value)
        case .failure(let err):
            print("[deleteProduct err]")
            print(err)
        }
    }
    
    func removeMember(memberId: Int) async {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/members/\(memberId)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let result = await request.result
        
        switch result {
        case .success(_):
            print("[removeMember success")
        case .failure(_):
            print("[removeMember err")
        }
        
    }
    
    //  MARK: TASK
    
    func searchClubJoinsAllTask() {
        Task {
            await searchClubJoinsAll()
        }
    }
}
