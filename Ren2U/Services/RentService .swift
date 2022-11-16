//
//  RentService .swift
//  Ren2U
//
//  Created by 노우영 on 2022/11/08.
//

import Foundation
import Alamofire

protocol RentServiceEnable: BaseServiceEnable {
    func requesRent(clubId: Int, itemId: Int) async -> DataResponse<String, NetworkError>
    func applyRent(clubId: Int, itemId: Int) async -> DataResponse<DefaultPostResponse, NetworkError>
    func returnRent(clubId: Int, itemId: Int) async -> DataResponse<DefaultPostResponse, NetworkError>
    func cancelRent(clubId: Int, itemId: Int) async -> DataResponse<DefaultPostResponse, NetworkError>
    func searchClubRentalsAll(clubId: Int) async -> DataResponse<SearchClubRentalsAllResponse, NetworkError>
}


class MockupRentService: RentServiceEnable {
    func requesRent(clubId: Int, itemId: Int) async -> Alamofire.DataResponse<String, NetworkError> {
        let result = Result {
            return ""
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func applyRent(clubId: Int, itemId: Int) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
        let result = Result {
            return DefaultPostResponse(statusCode: 200, responseMessage: "", data: nil)
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func returnRent(clubId: Int, itemId: Int) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
        let result = Result {
            return DefaultPostResponse(statusCode: 200, responseMessage: "", data: nil)
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func cancelRent(clubId: Int, itemId: Int) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
        let result = Result {
            return DefaultPostResponse(statusCode: 200, responseMessage: "", data: nil)
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func searchClubRentalsAll(clubId: Int) async -> Alamofire.DataResponse<SearchClubRentalsAllResponse, NetworkError> {
        let result = Result {
            return SearchClubRentalsAllResponse(statusCode: 200, responseMessage: "", data: ClubRentalData.dummyClubRentalDatas())
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    var url: String?
    var bearerToken: String?
}

class RentService: RentServiceEnable {
    func requesRent(clubId: Int, itemId: Int) async -> Alamofire.DataResponse<String, NetworkError> {
        
        let url = "\(self.url!)/clubs/\(clubId)/rentals/\(itemId)/request"
        let headers: HTTPHeaders = [
            .authorization(bearerToken: self.bearerToken!)
        ]
        
        let response = await AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers).serializingString().response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func applyRent(clubId: Int, itemId: Int) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
        
        let url = "\(self.url!)/clubs/\(clubId)/rentals/\(itemId)/apply"
        let headers: HTTPHeaders = [
            .authorization(bearerToken: self.bearerToken!)
        ]
        
        let response = await AF.request(url, method: .put, encoding: JSONEncoding.default, headers: headers).serializingDecodable(DefaultPostResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func returnRent(clubId: Int, itemId: Int) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
        
        
        let url = "\(self.url!)/clubs/\(clubId)/rentals/\(itemId)/return"
        let headers: HTTPHeaders = [
            .authorization(bearerToken: self.bearerToken!)
        ]
        
        let response = await AF.request(url, method: .put, encoding: JSONEncoding.default, headers: headers).serializingDecodable(DefaultPostResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func cancelRent(clubId: Int, itemId: Int) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
        
        let url = "\(self.url!)/clubs/\(clubId)/rentals/\(itemId)/cancel"
        let headers: HTTPHeaders = [
            .authorization(bearerToken: self.bearerToken!)
        ]
        
        let response = await AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: headers).serializingDecodable(DefaultPostResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func searchClubRentalsAll(clubId: Int) async -> Alamofire.DataResponse<SearchClubRentalsAllResponse, NetworkError> {
        
        let url = "\(self.url!)/clubs/\(clubId)/rentals/search/all"
        let headers: HTTPHeaders = [
            .authorization(bearerToken: self.bearerToken!)
        ]
        
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).serializingDecodable(SearchClubRentalsAllResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    var url: String?
    
    var bearerToken: String?
    
    init(url: String) {
        self.url = url
        self.bearerToken = UserDefaults.standard.string(forKey: JWT_KEY)
    }
}

