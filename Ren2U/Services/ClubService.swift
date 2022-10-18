//
//  ClubService.swift
//  Ren2U
//
//  Created by 노우영 on 2022/10/18.
//

import Alamofire
import Foundation

protocol ClubServiceEnable: BaseServiceEnable {
    func searchClubsAll() async -> DataResponse<GetSearchClubsAllResponse, NetworkError>
    func searchClubsWithName(groupName: String) async -> DataResponse<SearchClubsWithNameResponse, NetworkError>
}

class MockupClubService: ClubServiceEnable {
    
    var url: String?
    var bearerToken: String?
    
    func searchClubsWithName(groupName: String) async -> Alamofire.DataResponse<SearchClubsWithNameResponse, NetworkError> {
        let result = Result {
            return SearchClubsWithNameResponse(statusCode: 200, responseMessage: "", data: ClubAndRoleData.dummyClubAndRoleDatas())
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func searchClubsAll() async -> Alamofire.DataResponse<GetSearchClubsAllResponse, NetworkError> {
        let result = Result {
            return GetSearchClubsAllResponse(statusCode: 200, responseMessage: "", data: ClubAndRoleData.dummyClubAndRoleDatas())
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
}

class ClubService: ClubServiceEnable {
    var url: String?
    var bearerToken: String?
    
    init(url: String) {
        self.url = url
        self.bearerToken = UserDefaults.standard.string(forKey: JWT_KEY)
    }
    
    func searchClubsWithName(groupName: String) async -> Alamofire.DataResponse<SearchClubsWithNameResponse, NetworkError> {
        
        let url = "\(url!)/clubs/search?name=\(groupName)"
        let headers: HTTPHeaders = [
            .authorization(bearerToken: bearerToken!)
        ]
        
        let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        let encodedURL = URL(string: encoded)!
        
        let response = await AF.request(encodedURL, method: .get, encoding: JSONEncoding.default, headers: headers).serializingDecodable(SearchClubsWithNameResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func searchClubsAll() async -> Alamofire.DataResponse<GetSearchClubsAllResponse, NetworkError> {
        
        let url = "\(url!)/clubs/search/all"
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: self.bearerToken!)
        ]
        
        let response = await AF.request(url, method: .get, headers: headers).serializingDecodable(GetSearchClubsAllResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
}
