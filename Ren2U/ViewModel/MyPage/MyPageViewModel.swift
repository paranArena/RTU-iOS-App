//
//  AuthViewModel .swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/15.
//  request header bearer token : https://stackoverflow.com/questions/61093557/alamofire-request-with-authorization-bearer-token-and-additional-headers-swift
//  Almofire 안쓰는 전체 auth 과정 : https://www.youtube.com/watch?v=iXG3tVTZt6o

import Foundation
import Alamofire

class MyPageViewModel: ObservableObject {
    
    @Published var userData: UserData?
    @Published var isLogined = false
    
    init() {
        if UserDefaults.standard.string(forKey: JWT_KEY) == nil {
            isLogined = false
        } else {
            isLogined = true
        }
    }
    
    func logout() {
        UserDefaults.standard.set(nil, forKey: JWT_KEY)
        isLogined = false
    }
    
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
                self.logout()
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
}
