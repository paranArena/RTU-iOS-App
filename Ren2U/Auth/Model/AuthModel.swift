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
    
    static let `default` = User(email: "temp", password: "12345", name: "Page",
                                major: "소프트웨어학과", studentId: "12345678", phoneNumber: "01012345678")
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
//        let random = Int.random(in: 0000...9999)
//        let randomGenerateNum = String(random)
    }
    
    func checkCertificationNum(num: String, user: User) -> Bool{
        print("\(self) : check!")
        let num = Int(num)
        guard num == 1234 else { return false }
        return true
    }

    func signUp(user: User) async -> Bool {
        
        var result = false
        let url = "\(baseURL)/signup"
        let param: [String: Any] = [
            "email" : "\(user.email)@ajou.ac.kr",
            "password" : user.password,
            "name" : user.name,
            "phoneNumber" : user.phoneNumber,
            "studentId" : user.studentId,
            "major" : user.major
        ]
        
        let task = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).serializingString()
        let response = await task.result
        
        switch response {
        case .success(let value):
            print("[AuthVM] : \(value)")
            result = true
        case .failure(let err):
            print("[AuthVM] : \(err)")
            result = false
        }
        
        return result
    }
    
    @MainActor
    func login(account: Account) async {
        self.jwt = "123"
        let defaults = UserDefaults.standard
        let url = "\(baseURL)/authenticate"
        let param: [String: Any] = [
            "email" : account.email,
            "password" : account.password
        ]
        
        
        let request = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).serializingDecodable(LoginResponse.self)
        let response = await request.result
        
        switch response {
        case .success(let value):
            print("[AuthVM] login : \(value)")
            break
        case .failure(let err):
            print("[AuthVM] login : \(err)")
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
    
    func logout() {
        UserDefaults.standard.setValue(nil, forKey: "jwt")
        jwt = nil
    }
}
