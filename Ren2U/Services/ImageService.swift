//
//  ImageService.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/21.
//

import Foundation
import Combine
import Alamofire
import SwiftUI

protocol ImageServiceEnable: BaseServiceEnable {
    func upload(image: UIImage) async -> DataResponse<DefaultPostResponse, NetworkError>
}

class ImageService: ImageServiceEnable {
    
    func upload(image: UIImage) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
        
        let url = "\(self.url!)/image/upload" 
        let hearders: HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")",
            "Content-type": "multipart/form-data"
        ]
        
        
        
        let response = await AF.upload(multipartFormData: { multipart in
           multipart.append(image.jpegData(compressionQuality: 1)!, withName: "image", fileName: "image", mimeType: "image/jpeg")
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: hearders).serializingDecodable(DefaultPostResponse.self).response
        
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

class DeprecatedImageService {
    
    static let shared = DeprecatedImageService()
    private init() { }
    
    func post(image: UIImage) -> AnyPublisher<DataResponse<DefaultPostResponse, NetworkError>, Never> {
        let url = "\(BASE_URL)/image/upload"
        let hearders: HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")",
            "Content-type": "multipart/form-data"
        ]
        
        return AF.upload(multipartFormData: { multipart in
            multipart.append(image.jpegData(compressionQuality: 1)!, withName: "image", fileName: "image", mimeType: "image/jpeg")
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: hearders)
        .validate()
        .publishDecodable(type: DefaultPostResponse.self)
        .map { resonse in
            resonse.mapError { err in
                let serverError = resonse.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0)}
                return NetworkError(initialError: err, serverError: serverError)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
