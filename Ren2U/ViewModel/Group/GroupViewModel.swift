//
//  GroupModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import Alamofire

class GroupViewModel: ObservableObject {
    
    @Published var likesGroupId = [LikeGroupInfo]()
    @Published var joinedClubs = [ClubAndRoleData]() // VStack에서 나열될 그룹들
    
    @Published var notices = [Int: [NoticeData]]() // Vstack 한개 그룹 셀에서 이동 후 사용될 정보
    @Published var rentalItems = [RentalItemInfo]() // Vstack 한개의 그룹 셀에서 이동 후 사용될 정보
    
    @Published var itemViewActive = [Bool]()
    
    //  MARK: LOCAL
    
    func getGroupNameByGroupId(groupId: Int) -> String {
        if let fooOffset = joinedClubs.firstIndex(where: {$0.id == groupId }) {
            print(joinedClubs[fooOffset].name)
            return joinedClubs[fooOffset].name
        } else {
            return "그룹 이름 에러"
        }
    }
    
    func fetchRentalItems() {
        self.rentalItems = RentalItemInfo.dummyRentalItems()
        self.itemViewActive = [Bool](repeating: false, count: rentalItems.count)
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
    func getMyClubs() async {
        let url = "\(BASE_URL)/members/my/clubs"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY)!)"]
        
        let task = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyClubsResponse.self)
        let response = await task.result
        
        switch response {
        case .success(let value):
            print("getMyClubs Success")
            self.joinedClubs = value.data
        case .failure(let err):
            print("[getMyClubs Error]\n \(err)")
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
    func searchNotificationsAll(groupId: Int) async {
        
        let url = "\(BASE_URL)/clubs/\(groupId)/notifications/search/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let task = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(SearchNotificationsAllResponse.self)
        let result = await task.result
        
        switch result {
        case .success(let value):
            print("searchNotificationAll success, GroupId: \(groupId)")
            self.notices[groupId] = value.data
            self.notices[groupId] = notices[groupId]!.reversed()
        case .failure(let err):
            print("searchNotificationsAll failure, GroupId: \(groupId) : \(err)")
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
            print("create club success : \(value.data)")
        case .failure(let err):
            print("create club failure : \(err)")
        }
    }
    
    func requestClubJoin(clubId: Int) async {
        
        let url = "\(BASE_URL)/clubs/\(clubId)/requests/join"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let task = AF.request(url, method: .post, encoding: JSONEncoding.default, headers:  hearders).serializingDecodable(requestClubJoinResponse.self)
        let result = await task.result
        
        switch result {
        case .success(let value):
            print(value)
        case .failure(let err):
            print(err)
        }
    }
    
    //  MARK: TASK
    func createClubTask(club: CreateClubFormdata) {
        Task {
            await createClub(club: club)
            await getMyClubs()
        }
    }
    
    func getMyClubsTask() {
        Task {
            await getMyClubs()
            
            notices.removeAll()
            for joinedClub in joinedClubs {
                await searchNotificationsAll(groupId: joinedClub.id)
            }
            
            for joinedClub in joinedClubs {
                for i in 0..<(notices[joinedClub.id]?.count ?? 0) {
                    print("공지사항 : \(notices[joinedClub.id]![i].title)")
                }
            }
        }
        
    }
    
    func requestClubJoinTask(cludId: Int) {
        Task {
            await requestClubJoin(clubId: cludId)
        }
    }
    
    func searchNotificationsAllTask() {
        Task {
            for joinedClub in joinedClubs {
                await searchNotificationsAll(groupId: joinedClub.id)
            }
        }
    }
}
