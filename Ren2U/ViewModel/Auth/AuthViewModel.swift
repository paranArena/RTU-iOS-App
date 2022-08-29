//
//  AuthViewModel .swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/15.
//  request header bearer token : https://stackoverflow.com/questions/61093557/alamofire-request-with-authorization-bearer-token-and-additional-headers-swift
//  Almofire 안쓰는 전체 auth 과정 : https://www.youtube.com/watch?v=iXG3tVTZt6o

import Foundation
import Alamofire

class AuthViewModel: ObservableObject {
    
    @Published var jwt: String?
    @Published var user: User?
    
    init() {
        self.setLocalValues()
    }
    
    func sendCertificationNum() {
//        let random = Int.random(in: 0000...9999)
//        let randomGenerateNum = String(random)
    }
    
    
    
    func checkCertificationNum(num: String, user: User) -> Bool{
        let num = Int(num)
        guard num == 1234 else { return false }
        return true
    }
    
//    @MainActor
//    func checkEmailPuplicate(email: String) async -> Bool {
//        let url = "\(baseURL)/\(email)/exists"
//    }

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
    func login(account: Account) async -> Bool {
        let url = "\(baseURL)/authenticate"
        let param: [String: Any] = [
            "email" : account.email,
            "password" : account.password
        ]
        
 
        
        let request = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).serializingDecodable(LoginResponse.self)
        let response = await request.result

        switch response {
        case .success(let value):
            self.setToken(token: value.token)
            return false
        case .failure(let err):
            print("[Auth] login err: \(err)")
            return true
        }
        
    }
    
    
    func logout() {
        UserDefaults.standard.setValue(nil, forKey: jwtKey)
        self.jwt = nil
    }
    
    @MainActor
    func getMyInfo() async {
        let url = "\(baseURL)/members"
        let hearders: HTTPHeaders = [.authorization(bearerToken: self.jwt!)]
        
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let response = await request.result
        
        switch response {
        case .success(let value):
            print(value)
            break
        case .failure(let err):
            print("[AuthVM] login err: \(err)")
        }
    }
    
    private func setToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: jwtKey)
        self.jwt = token
    }
    
    
    //  MARK: Func for Local Test
    
    private func setLocalValues() {
        setLocalToken()
        setLocalUser()
    }
    
    private func setLocalToken() {
        self.jwt = "123"
    }
    
    private func setLocalUser() {
        self.user = User.dummyUser()
    }
}
