//
//  ClubProfileService.swift
//  Ren2U
//
//  Created by 노우영 on 2022/10/26.
//

import Foundation
import Alamofire

protocol ClubProfileServiceEnable: BaseServiceEnable {
    
    func createClub(data: ClubProfileParam) async -> DataResponse<CreateClubResponse, NetworkError>
    func getClubInfo(clubId: Int) async -> DataResponse<GetClubInfoResponse, NetworkError>
    func updateClub(data: ClubProfileParam, clubId: Int) async -> DataResponse<String, NetworkError>
}

class MockupClubProfileService: ClubProfileServiceEnable {
    func updateClub(data: ClubProfileParam, clubId: Int) async -> Alamofire.DataResponse<String, NetworkError> {
        let result = Result {
            return ""
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func getClubInfo(clubId: Int) async -> Alamofire.DataResponse<GetClubInfoResponse, NetworkError> {
        let result = Result {
            return GetClubInfoResponse(statusCode: 200, responseMessage: "", data: ClubDetailData.dummyClubData())
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func createClub(data: ClubProfileParam) async -> Alamofire.DataResponse<CreateClubResponse, NetworkError> {
        let result = Result {
            return CreateClubResponse(statusCode: 200, responseMessage: "", data: ClubDetailData.dummyClubData())
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }

        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    var url: String?
    var bearerToken: String?
}

class ClubProfileService: ClubProfileServiceEnable {
 
    
    var url: String?
    var bearerToken: String?
    
    init(url: String) {
        self.url = url
        self.bearerToken = UserDefaults.standard.string(forKey: JWT_KEY)
    }
    
    func updateClub(data: ClubProfileParam, clubId: Int) async -> Alamofire.DataResponse<String, NetworkError> {
        let url = "\(self.url!)/api/v1/clubs/\(clubId)/info"
        let headers: HTTPHeaders = [
            .authorization(bearerToken: self.bearerToken!)
        ]
        let imagePaths: [String] = [data.imagePath]
        
        let param: [String: Any] = [
            "name" : data.name,
            "intro" : data.introduction,
            "imagePaths" : imagePaths,
            "hashtags" : data.hashtags
                
        ]
        
        let response = await AF.request(url, method: .put, parameters: param, encoding: JSONEncoding.default, headers: headers).serializingString().response
        
        print(response.debugDescription)
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }

    }
    
    func createClub(data: ClubProfileParam) async -> Alamofire.DataResponse<CreateClubResponse, NetworkError> {

        
        let url = "\(self.url!)/api/v1/clubs"
        let headers: HTTPHeaders = [
            .authorization(bearerToken: self.bearerToken!)
        ]
        let imagePaths: [String] = [data.imagePath]
        
        let param: [String: Any] = [
            "name" : data.name,
            "intro" : data.introduction,
            "imagePaths" : imagePaths,
            "hashtags" : data.hashtags
                
        ]
        
        let response = await AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).serializingDecodable(CreateClubResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    
    func getClubInfo(clubId: Int) async -> Alamofire.DataResponse<GetClubInfoResponse, NetworkError> {
        
        let url = "\(self.url!)/clubs/\(clubId)/info"
        let headers: HTTPHeaders = [
            .authorization(bearerToken: self.bearerToken!)
        ]
        
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).serializingDecodable(GetClubInfoResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
}

