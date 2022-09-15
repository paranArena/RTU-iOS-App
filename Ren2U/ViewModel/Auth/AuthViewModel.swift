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
    
    @Published var userData: UserData?
    
    //  MARK: GET
    
    
    @MainActor
    func getMyInfo() {
        let url = "\(BASE_URL)/members/my/info"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "")]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).responseDecodable(of: GetMyInfoResponse.self) { res in
            switch res.result {
            case .success(let value):
                print("[getMyInfo success]")
                print(value.responseMessage)
                self.userData = value.data
            case .failure(let err):
                print("[getMyInfo err]")
                print(err)
            }
        }
    }

    func quitService() {
        let url = "\(BASE_URL)/members/my/quit"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "")]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).responseDecodable(of: GetMyInfoResponse.self) { res in
            print(res.debugDescription)
            switch res.result {
            case .success(_):
                print("[quitService success]")
            case .failure(_):
                print("[quitService err]")
            }
        }
    }
    
    
    //  MARK: POST
    
    func signUp(user: User, verificationCode: String) async -> Bool {
        var result = false
        let url = "\(BASE_URL)/signup"
        let param: [String: Any] = [
            "email" : "\(user.email)@ajou.ac.kr",
            "password" : user.password,
            "name" : user.name,
            "phoneNumber" : "010\(user.phoneNumber)",
            "studentId" : user.studentId,
            "major" : user.major,
            "verificationCode" : verificationCode
        ]
        
        let task = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).serializingString()
        let response = await task.result
        
        switch response {
        case .success(_):
            print("signUp success")
            result = true
        case .failure(let err):
            print("signUp err")
            print(err)
            result = false
        }
        
        return result
    }
    
    func requestEmailCode2(email: String) {
        let url = "\(BASE_URL)/members/email/requestCode"
        let param: [String: Any] = [
            "email" : "\(email)"
        ]
        
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).responseString { res in
            switch res.result {
            case .success(let value):
                print("[requestEmailCode success]")
                print(value)
            case .failure(let err):
                print("[requestEmailCode err]")
                print(err)
            }
        }
    }
    
    //  MARK: PUT
    
    func passwordResetWithVerificationCode(email: String, code: String, password: String) async -> Bool {
        let url = "\(BASE_URL)/members/password/reset/verify"
        let param: [String: Any] = [
            "email" : "\(email)",
            "code" : "\(code)",
            "password" : "\(password)"
        ]
        
        let response = AF.request(url, method: .put, parameters: param, encoding: JSONEncoding.default).serializingString()
        
        switch await response.result {
        case .success(let value):
            print("[passwordResetWithVerificationCode success]")
            return true
        case .failure(let err):
            print("[passwordResetWithVerificationCode err]")
            return false
        }
    }
}
