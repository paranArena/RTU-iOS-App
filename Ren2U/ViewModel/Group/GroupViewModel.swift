//
//  GroupModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import Alamofire


struct LikeGroupInfo: Codable {
    var groupId: String
    
    init(groupId: String) {
        self.groupId = groupId
    }
    
    static func dummyLikeGroupInfos() -> [LikeGroupInfo] {
        return [LikeGroupInfo(groupId: "1"), LikeGroupInfo(groupId: "4"), LikeGroupInfo(groupId: "6"), LikeGroupInfo(groupId: "8")]
    }
}

extension GroupViewModel {
    
    struct ClubInfo {
        
    }
}

class GroupViewModel: ObservableObject {
    
    @Published var likesGroupId = [LikeGroupInfo]()
    @Published var joinedGroups = [ClubAndRoleData]() // VStack에서 나열될 그룹들
    
    @Published var notices = [NoticeInfo]() // Vstack 한개 그룹 셀에서 이동 후 사용될 정보
    @Published var rentalItems = [RentalItemInfo]() // Vstack 한개의 그룹 셀에서 이동 후 사용될 정보
    
    @Published var itemViewActive = [Bool]()
    
    func createClub(club: CreateClubFormdata) async {
        let url = "\(baseURL)/clubs"
        
        let hearders: HTTPHeaders = [
            .authorization(bearerToken: UserDefaults.standard.string(forKey: jwtKey)!),
            .init(name: "Content-Type", value: "multipart/form-data")
        ]
        
        let param: [String: Any] = [
            "name": club.name,
            "introduction": club.introduction,
            "hashtags": club.hashtags
        ]
        
        AF.upload(multipartFormData: { multipart in
            if let image = club.thumbnail.jpegData(compressionQuality: 1) {
                multipart.append(image, withName: "thumbnail", mimeType: "image/jpeg")
            }
            
            for (key, value) in param {
                if key == "hashtags" {
                    for v in value as! [String] {
                        multipart.append(v.data(using: .utf8, allowLossyConversion: false)!, withName: key)
                    }
                } else {
                    multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: key)
                }
            }
            
        }, to: url, method: .post, headers: hearders).response { res in
            switch res.result {
            case .success(let value):
                print("create success \(value?.description ?? "그룹 생성 성공")")
            case .failure(let err):
                print("create err \(err.errorDescription!)")
            }
        }
        
        await getMyClubs()
    }
    
    @MainActor
    func getMyClubs() async {
        let url = "\(baseURL)/members/my/clubs"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: jwtKey)!)]
        
        let task = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyClubsResponse.self)
        let response = await task.result
        
        switch response {
        case .success(let value):
            print("getMyClubsSuccess")
            self.joinedGroups = value.data
        case .failure(let err):
            print("getMyClubs err : \(err.errorDescription!)")
        }
    }
    
    func refreshItems() async {
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000) 
        } catch {
            
        }
    }
    
    func fetchNotices() {
        self.notices = NoticeInfo.dummyNotices()
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
    
    
    // MARK: SEARCH
    
    @MainActor
    func searchClubsAll() async -> [ClubData] {
        
        let url = "\(baseURL)/clubs/search/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: jwtKey)!)]
        
        print(UserDefaults.standard.string(forKey: jwtKey)!)
        let task = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetSearchClubsAllResponse.self)
        let response = await task.result
        
        switch response {
        case .success(let value):
            return value.data
        case .failure(let err):
            print(err)
            return [ClubData]()
        }
    }
    
    
    //  MARK: TASK
    func taskCreateClub(club: CreateClubFormdata) {
        Task {
            await createClub(club: club)
        }
    }
    
    func getMyClubsTask() {
        Task {
            await getMyClubs()
        }
    }
}
