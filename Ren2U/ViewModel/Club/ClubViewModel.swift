//
//  GroupModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import Alamofire

class ClubViewModel: ObservableObject {
    
    @Published var likesGroupId = [LikeGroupInfo]()
    @Published var joinedClubs = [ClubAndRoleData]() // VStack에서 나열될 그룹들
    
    @Published var notices = [Int: [NoticeCellData]]() // Vstack 한개 그룹 이동 후 사용될 정보
    @Published var products = [ProductCellData]()
    @Published var rentals = [RentalData]()
    
    //  MARK: LOCAL
    
    func getGroupNameByGroupId(groupId: Int) -> String {
        if let fooOffset = joinedClubs.firstIndex(where: {$0.id == groupId }) {
            return joinedClubs[fooOffset].name
        } else {
            return "그룹 이름 에러"
        }
    }
    
    func makeFavoritesGroupTag(tags: [String]) -> String {
        var tagLabel: String = ""
        var newLineCounter: Int = 0
        var isReachedLineLimit = false
        
        for tag in tags {

            let newTag = "#\(tag) "
            newLineCounter += newTag.utf8.count
            
            if !isReachedLineLimit && newLineCounter > 32 {
                isReachedLineLimit = true
                tagLabel.append(contentsOf: "\n")
                newLineCounter = 0
            } else if isReachedLineLimit && newLineCounter > 23 {
                tagLabel.append(contentsOf: "\n")
                return tagLabel
            }
            
            tagLabel.append(contentsOf: newTag)
        }
        
        return tagLabel
    }
    
    func makeJoinedGroupTage(tags: [String]) -> String {
        var tagLabel: String = ""
        
        for tag in tags {
            tagLabel.append(contentsOf: "#\(tag )")
        }
        
        return tagLabel
    }
    
    //  MARK: GET
    
    @MainActor
    func getMyClubRole(clubId: Int) async -> String {
        let url = "\(BASE_URL)/members/my/clubs/\(clubId)/role"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY)!)"]
        
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
    func getMyClubs() {
        let url = "\(BASE_URL)/members/my/clubs"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY)!)"]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).responseDecodable(of: GetMyClubsResponse.self) { res in
            switch res.result {
            case .success(let value):
                print("[getMyClubs success]")
                self.joinedClubs = value.data
                print(value.responseMessage)
            case .failure(let err):
                print("[getMyClubs Error]")
                print(err)
            }
        }
    }
    
    @MainActor
    func getMyClubsAsync() async {
        let url = "\(BASE_URL)/members/my/clubs"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY)!)"]
        
        let task = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyClubsResponse.self)
        let response = await task.result
        
        switch response {
        case .success(let value):
            print("[getMyClubs success]")
            self.joinedClubs = value.data
            print(value.responseMessage)
        case .failure(let err):
            print("[getMyClubs Error]")
            print(err)
        }
    }
    
    @MainActor
    func getMyNotifications() {
        let url = "\(BASE_URL)/members/my/notifications"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).responseDecodable(of: GetMyNotificationsResponse.self) { res in
            switch res.result {
            case .success(let value):
                print("[getMyNotificationsSuccess]")
                print(value.responseMessage)
                self.notices.removeAll()
                
                for i in 0..<value.data.count {
                    let clubId = value.data[i].clubId
                    
                    if self.notices[clubId] == nil {
                        self.notices[clubId] = [NoticeCellData]()
                    }
                    
                    self.notices[clubId]!.append(value.data[i])
                }
            case .failure(let err):
                print("[getMyNotificationsErr")
                print(err)
            }
        }
    }
    
    @MainActor
    func getMyNotificationsAsync() async {
        let url = "\(BASE_URL)/members/my/notifications"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyNotificationsResponse.self)
        let result = await request.result
        
        notices.removeAll()
        
        switch result {
        case .success(let value):
            print("[getMyNotificationsSuccess]")
            print(value.responseMessage)
            notices.removeAll()
            
            for i in 0..<value.data.count {
                let clubId = value.data[i].clubId
                
                if notices[clubId] == nil {
                    notices[clubId] = [NoticeCellData]()
                }
                
                notices[clubId]!.append(value.data[i])
            }
        case .failure(let err):
            print("[getMyNotificationsErr")
            print(err)
        }
    }
    
    @MainActor
    func getMyProducts() async {
        let url = "\(BASE_URL)/members/my/products"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]

        let task = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyProductsResponse.self)
        let result = await task.result
        
        switch result {
        case .success(let value):
            print("[getMyProducts success]")
            print(value.responseMessage)
            self.products = value.data.map { ProductCellData(data: $0) }
        case .failure(let err):
            print("[getMyProducts err")
            print(err)
        }
    }
    
    @MainActor
    func getMyRentals()  async {
        let url = "\(BASE_URL)/members/my/rentals"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyRentalsResponse.self)
        let result = await request.result
        
        switch result {
        case .success(let value):
            print("[getMyRentals success")
            print(value.responseMessage)
            self.rentals = value.data
        case .failure(let err):
            print("[getMyRentals err]")
            print(err)
        }
    }
    
    @MainActor
    func searchClubsAll() async -> [ClubAndRoleData] {
        
        let url = "\(BASE_URL)/clubs/search/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]

        let task = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetSearchClubsAllResponse.self)
        let result = await task.result
        
        switch result {
        case .success(let value):
            print("serachClubsAll success")
            return value.data
        case .failure(let err):
            print("serachClubsAll failure")
            print(err)
            return [ClubAndRoleData]()
        }
    }
    
    @MainActor
    func searchClubsWithName(groupName: String) async -> ClubAndRoleData? {
        let url = "\(BASE_URL)/clubs/search?name=\(groupName)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        if let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let encodedURL = URL(string: encoded) {
            let task = AF.request(encodedURL, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(SearchClubsWithNameResponse.self)
            let result = await task.result
            
            switch result {
            case .success(let value):
                return value.data
            case .failure(let err):
                print("searchClubsWithName err [\(groupName)] : \(err)")
            }
        }
        
        return nil
    }
    
    @MainActor
    func searchClubsWithHashTag(hashTag: String) async -> [ClubAndRoleData] {
        let url = "\(BASE_URL)/clubs/search?hashtag=\(hashTag)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        if let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let encodedURL = URL(string: encoded) {
            
            let task = AF.request(encodedURL, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetSearchClubsAllResponse.self)
            let result = await task.result
            
            switch result {
            case .success(let value):
                print("SearchCLubsWithHashTag Success")
                return value.data
            case .failure(let err):
                print("SearchClubWithHashTag Error : \(err)")
            }
        }
        
        return [ClubAndRoleData]()
    }

    @MainActor
    func searchNotificationsAll(clubId: Int) {

        let url = "\(BASE_URL)/clubs/\(clubId)/notifications/search/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]

        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).responseDecodable(of: SearchNotificationsAllResponse.self) { res in
            switch res.result {
            case .success(let value):
                print("searchNotificationAll success, GroupId: \(clubId)")
                self.notices[clubId] = value.data
                self.notices[clubId] = self.notices[clubId]!.reversed()
            case .failure(let err):
                print("searchNotificationsAll failure, GroupId: \(clubId) : \(err)")
            }
        }
    }
    
    func reportNotification(clubId: Int, notificationId: Int) {
        let url = "\(BASE_URL)/clubs/\(clubId)/notifications/\(notificationId)/report"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]

        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: hearders).responseString() { res in
            switch res.result {
            case .success(let value):
                #if DEBUG
                print("[reportNotification success")
                print(value)
                #endif
            case .failure(let err):
                #if DEBUG
                print("[reportNotification err]")
                print(err)
                #endif
            }
        }
    }
    
    
    
    //  MARK: POST
    
    func createClub(club: CreateClubFormdata) async {
        let url = "\(BASE_URL)/clubs"
        let hearders: HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY)!)",
            "Content-type": "multipart/form-data"
        ]
        
        let param: [String: Any] = [
            "name": club.name,
            "introduction": club.introduction,
            "hashtags": club.hashtags
        ]
        
        let task = AF.upload(multipartFormData: { multipart in
            if let image = club.thumbnail.jpegData(compressionQuality: 1) {
                multipart.append(image, withName: "thumbnail", fileName: "\(club.name).thumbnail", mimeType: "image/jpeg")
            }

            for (key, value) in param {
                
                if key == "hashtags" {
                    multipart.append(Data(String("").utf8), withName: key)
                    for v in value as! [String] {
                        multipart.append(Data(v.utf8), withName: key)
                    }
                } else {
                    multipart.append(Data(String("\(value)").utf8), withName: key)
                }
            }

        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: hearders).serializingDecodable(CreateClubResponse.self)
        
        
        let result = await task.result
        
        switch result {
        case .success(let value):
            print("[create club success]")
            print(value.responseMessage)
        case .failure(let err):
            print("[create club err]")
            print(err)
        }
    }
    
    func requestClubJoin(clubId: Int) async {
        
        let url = "\(BASE_URL)/clubs/\(clubId)/requests/join"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let task = AF.request(url, method: .post, encoding: JSONEncoding.default, headers:  hearders).serializingDecodable(requestClubJoinResponse.self)
        let result = await task.result
        
        switch result {
        case .success(let value):
            print("[requestClubJoin success]")
            print(value.responseMessage)
        case .failure(let err):
            print("[requestClubJoin err]")
            print(err)
        }
    }
    
    //  MARK: DELETE
    func cancelClubJoin(clubId: Int) async {
        let url = "\(BASE_URL)/clubs/\(clubId)/requests/join/cancel"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: hearders).serializingString()
        
        let result = await request.result
        switch result {
        case .success(let value):
            print("[cancelClubJoin success]")
            print(value)
        case .failure(let err):
            print("[cancelClubJoin err]")
            print(err)
        }
    }
    
    func leaveClub(clubId: Int) async {
        let url = "\(BASE_URL)/clubs/\(clubId)/requests/leave"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: hearders).serializingString()
        
        let result = await request.result
        switch result {
        case .success(let value):
            print("[leaveClub success]")
            print(value)
        case .failure(let err):
            print("[leaveClub err]")
            print(err)
        }
    }
    
    func cancelRent(clubId: Int, itemId: Int) async {
        let url = "\(BASE_URL)/clubs/\(clubId)/rentals/\(itemId)/cancel"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: hearders).serializingString()
        
        let result = await request.result
        switch result {
        case .success(let value):
            print("[cancelRent success]")
            print(value)
        case .failure(let err):
            print("[cancelRent err]")
            print(err)
        }
    }
    
    //  MARK: PUT
    func returnRent(clubId: Int, itemId: Int) async {
        let url = "\(BASE_URL)/clubs/\(clubId)/rentals/\(itemId)/return"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .put, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let result = await request.result
            
        switch result {
        case .success(let value):
            print("[returnRent success]")
            print(value)
        case .failure(let err):
            print("[returnRent failure]")
            print(err)
        }
    }
    //  MARK: TASK
    func createClubTask(club: CreateClubFormdata) {
        Task {
            await createClub(club: club)
            await getMyClubsAsync()
        }
    }
}
