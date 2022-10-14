//
//  MemberService .swift
//  Ren2U
//
//  Created by 노우영 on 2022/10/14.
//

import Alamofire
import Foundation

protocol MemberServiceProtocol: BaseService {
    func login(param: [String: Any]) async -> DataResponse<LoginResponse, NetworkError>
}

class MemberService: MemberServiceProtocol {
    
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
    func login(param: [String : Any]) async -> Alamofire.DataResponse<LoginResponse, NetworkError> {
        let url = "\(url)/authenticate"
        let response = await AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).serializingDecodable(LoginResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
}

