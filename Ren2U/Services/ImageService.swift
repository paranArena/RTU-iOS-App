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

class ImageService {
    
    static let shared = ImageService()
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
