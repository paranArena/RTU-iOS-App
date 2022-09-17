//
//  ClubSearchViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/17.
//

import SwiftUI
import Alamofire

class ClubSearchViewModel: ObservableObject {
    
    @Published var clubData = [ClubAndRoleData]()
    
    @MainActor
    func searchWithText(text: String) {
        Task {
            let result1 = await searchClubsWithName(groupName: text)
            let result2 = await searchClubsWithHashTag(hashTag: text)
            
            clubData = result1
            for data in result2 {
                if !clubData.contains(data) {
                    clubData.append(data)
                }
            }
        }
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
    func searchClubsAll() async {
        
        let url = "\(BASE_URL)/clubs/search/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "")]

        let task = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetSearchClubsAllResponse.self)
        let result = await task.result
        
        switch result {
        case .success(let value):
            print("serachClubsAll success")
            self.clubData = value.data
        case .failure(let err):
            print("serachClubsAll failure")
            print(err)
        }
    }
    
    @MainActor
    func searchClubsWithName(groupName: String) async -> [ClubAndRoleData] {
        let url = "\(BASE_URL)/clubs/search?name=\(groupName)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "")]
        
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
        
        return [ClubAndRoleData]()
    }
    
    @MainActor
    func searchClubsWithHashTag(hashTag: String) async -> [ClubAndRoleData] {
        let url = "\(BASE_URL)/clubs/search?hashtag=\(hashTag)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "")]
        
        if let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let encodedURL = URL(string: encoded) {
            
            let task = AF.request(encodedURL, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetSearchClubsAllResponse.self)
            let result = await task.result
            
            switch result {
            case .success(let value):
                print("SearchClubsWithHashTag Success")
                return value.data
            case .failure(let err):
                print("SearchClubWithHashTag Error : \(err)")
            }
        }
        
        return [ClubAndRoleData]()
    }
    
    func requestClubJoin(clubId: Int) async {
        
        let url = "\(BASE_URL)/clubs/\(clubId)/requests/join"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "" )]
        
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

}
