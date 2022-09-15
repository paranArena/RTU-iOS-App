//
//  LoginViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/12.
//

import SwiftUI
import Alamofire

class LoginViewModel: ObservableObject {
    
    @Published var account = Account()
    @Published var missInput = MissInput.default
    @Published var isActiveSignUpView = false
    let tmp = 10 
    
    enum MissInput: String {
        case `default` = ""
        case wrong = "이메일 또는 비밀번호가 틀렸습니다."
    }
    
    private func setToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: JWT_KEY)
    }
    
    func clearFields() {
        account.clear()
    }
    
    @MainActor
    func login() async -> Bool {
        let url = "\(BASE_URL)/authenticate"
        let param: [String: Any] = [
            "email" : account.email,
            "password" : account.password
        ]
        

        let request = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).serializingDecodable(LoginResponse.self)
        let response = await request.response
        
        switch response.result {
        case .success(let value):
            print("login success")
            self.setToken(token: value.token)
            missInput = .default
            return true
        case .failure(_):
            print(response.debugDescription)
            missInput = .wrong
            return false
        }

    }
    
}
