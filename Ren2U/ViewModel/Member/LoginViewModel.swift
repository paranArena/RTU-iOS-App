//
//  LoginViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/12.
//

import SwiftUI
import Alamofire

class LoginViewModel: ObservableObject {
    
    @Published var account = SignUpParam()
    @Published var missInput = MissInput.default
    @Published var isActiveSignUpView = false
    
    let memberService: MemberServiceEnable
    let tmp = 10
    
    init(memberService: MemberServiceEnable) {
        self.memberService = memberService
    }
    
    enum MissInput: String {
        case `default` = ""
        case wrong = "이메일 또는 비밀번호가 틀렸습니다."
    }
    
    private func setToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: JWT_KEY)
    }
    
    func clearFields() {
        account.clearLogin()
    }
    
    func buttonTapped() async -> Bool {
        let param: [String:Any] = [
            "email" : account.email,
            "password" : account.password
        ]
        
        let response = await memberService.login(param: param)
        
        if response.error != nil {
            self.missInput = .wrong
        } else if let value = response.value {
            self.setToken(token: value.token)
            self.missInput = .default
            return true 
        }
        
        return false
    }
}
