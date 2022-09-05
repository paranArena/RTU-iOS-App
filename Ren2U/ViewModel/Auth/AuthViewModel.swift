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
    @Published var userData: UserData?
    
    init() {
        self.jwt = UserDefaults.standard.string(forKey: JWT_KEY)
    }
    
    
    private func setToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: JWT_KEY)
        self.jwt = token
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
    
    //  MARK: GET
    
    @MainActor
    func checkEmailDuplicate(email: String) async -> Bool {
        let url = "\(BASE_URL)/members/\(email)/exists"
        let response =  await AF.request(url, method: .get, encoding: JSONEncoding.default).serializingDecodable(Bool.self).result
        
        switch response {
        case .success(let value):
            print("[checkEmailDuplicate success]")
            print(value)
            return value
        case .failure(let err):
            print("ceheckEmailDuplicate err : \(err)")
        }
        
        return true
    }
    
    @MainActor
    func getMyInfo() {
        let url = "\(BASE_URL)/members/my/info"
        let hearders: HTTPHeaders = [.authorization(bearerToken: self.jwt!)]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).responseDecodable(of: GetMyInfoResponse.self) { res in
            switch res.result {
            case .success(let value):
                print("getMyInfo success")
                self.userData = value.data
            case .failure(let err):
                print("getMyInfo err: \(err)")
            }
        }
    }
    
    
    //  MARK: POST
    
    func signUp(user: User) async -> Bool {
        var result = false
        let url = "\(BASE_URL)/signup"
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
        let url = "\(BASE_URL)/authenticate"
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
            print("login err: \(err)")
            return true
        }

    }
    
    
    func logout() {
        UserDefaults.standard.setValue(nil, forKey: JWT_KEY)
        self.jwt = nil
    }
    
    //  MARK: TASK
    func checkEmailDuplicateTask(email: String) -> Bool {
        return true
    }
    
    func getMyInfoTask() {
        Task {
            await getMyInfo()
        }
    }
}
