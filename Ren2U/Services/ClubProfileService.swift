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
}

class MockupClubProfileService: ClubProfileServiceEnable {
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
    
    func createClub(data: ClubProfileParam) async -> Alamofire.DataResponse<CreateClubResponse, NetworkError> {
        
        let url = "\(self.url!)/clubs"
        let hearders: HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")",
            "Content-type": "multipart/form-data"
        ]
        
        let param: [String: Any] = [
            "name": data.name,
            "introduction": data.introduction,
            "hashtags": data.hashtags
        ]
        
        let response = await AF.upload(multipartFormData: { multipart in
            if let image = data.thumbnail.jpegData(compressionQuality: 1) {
                multipart.append(image, withName: "thumbnail", fileName: "club.thumbnail", mimeType: "image/jpeg")
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

        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: hearders).serializingDecodable(CreateClubResponse.self).response
        

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

