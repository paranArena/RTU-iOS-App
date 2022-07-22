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

struct LoginResponse: Codable {
    var statusCode: Int
    var responseMessage: String
    var data: UserToken
    
    struct UserToken: Codable {
        var token: String
    }
}

struct User: Codable {
    var email: String
    var password: String
    var name: String
    var major: String
    var studentId: String
    var phoneNumber: String
    var deviceToken: String
    
    static let `default` = User(email: "temp", password: "12345", name: "Page",
                                major: "소프트웨어학과", studentId: "12345678", phoneNumber: "01012345678",
                                deviceToken: "")
}

class AuthModel: ObservableObject {
    
    @Published var jwt: String?
    @Published var user: User?
    
    init() {
        self.jwt = UserDefaults.standard.value(forKey: "jwt") as? String
//        self.hello()
//        self.testSignup()
    }
    
    
    func sendCertificationNum() {
        let random = Int.random(in: 0000...9999)
        let randomGenerateNum = String(random)
    }
    
    func checkCertificationNum(num: String, user: User) -> Bool{
        print("\(self) : check!")
        let num = Int(num)
        guard num == 1234 else { return false }
        return true
    }

    func signUp(user: User) {
        
        let url = "http://localhost:8080/signup"
        
        let param: [String: Any] = [
            "email" : "\(user.email)@ajou.ac.kr",
            "password" : user.password,
            "name" : user.name,
            "phoneNumber" : user.phoneNumber,
            "studentId" : user.studentId,
            "major" : user.major
        ]
        
        
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseString { res in
                switch res.result {
                case .success(let value):
                    print("\(self) : \(value)")
                case .failure(let err):
                    print("\(self) : \(err)")
                }
            }
    }
    
    func login(account: Account) {
        self.jwt = "123"
        let defaults = UserDefaults.standard
        let url = "http://localhost:8080/authenticate"
        let param: [String: Any] = [
            "email" : account.email,
            "password" : account.password
        ]
        
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseDecodable(of: LoginResponse.self) { res in
                switch res.result {
                case .success(let value):
                    print(value)
                    break
                case .failure(let err):
                    print(err)
                }
            }
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
            }
    }
    
    func hello() {
        let url = "http://localhost:8080/api/hello"
        AF.request(url, method: .get, encoding: JSONEncoding.default)
            .responseString { res in
                switch res.result {
                case .success(let value):
                    print("[\(self)] : \(value)")
                case .failure(let err):
                    print("[\(self)] : \(err)")
                }
            }
    }
    
    func logout() {
        UserDefaults.standard.setValue(nil, forKey: "jwt")
        jwt = nil
    }
}
