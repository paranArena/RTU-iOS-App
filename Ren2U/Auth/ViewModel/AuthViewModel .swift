//
//  AuthViewModel .swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/15.
//  request header bearer token : https://stackoverflow.com/questions/61093557/alamofire-request-with-authorization-bearer-token-and-additional-headers-swift
//  Almofire 안쓰는 전체 auth 과정 : https://www.youtube.com/watch?v=iXG3tVTZt6o

import Foundation
import Alamofire

struct Account: Codable {
    var email: String
    var password: String
}

struct User: Codable {
    var name: String
}

class AuthViewModel: ObservableObject {
    
    @Published var jwt: String?
    
    init() {
        self.jwt = UserDefaults.standard.value(forKey: "jwt") as? String
    }
    
    func testGet() {
        let url = ""
        
        let headers: HTTPHeaders = [.authorization(bearerToken: jwt!)]
        
        let param: [String: Any] = [
            "key1" : "123",
            "key2" : "123"
        ]
        
        AF.request(url, method: .get, parameters: param, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: User.self) { response in
                //
            }
    }
    
    func login(account: Account) {
        let defaults = UserDefaults.standard
        let url = ""
        let param: [String: Any] = [
            "email" : account.email,
            "password" : account.password
        ]
        
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseDecodable(of: Account.self) { response in
                switch response.result {
                case .success(let value):
                    defaults.setValue(value, forKey: "jwt")
                    self.jwt = defaults.value(forKey: "jwt") as? String
                case .failure(let err):
                    print("[AuthViewModel] login Error : \(err.localizedDescription)")
                }
            }
    }
    
    func logout() {
        UserDefaults.standard.setValue(nil, forKey: "jwt")
        jwt = nil
    }
}
