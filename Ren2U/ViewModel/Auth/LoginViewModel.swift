//
//  LoginViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/12.
//

import SwiftUI
import Alamofire

class LoginViewModel: BaseViewModel {
    
    @Published var twoButtonsAlert: TwoButtonsAlert = TwoButtonsAlert()
    @Published var oneButtonAlert: OneButtonAlert = OneButtonAlert()
    
    @Published var account = LoginParam()
    @Published var missInput = MissInput.default
    @Published var isActiveSignUpView = false
    
    let memberService: MemberServiceEnable
    
    init(memberService: MemberServiceEnable) {
        self.memberService = memberService
    }
    
    enum MissInput: String {
        case `default` = ""
        case wrong = "이메일 또는 비밀번호가 틀렸습니다."
    }
    
    @MainActor
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError!.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
    
    private func setToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: JWT_KEY)
    }
    
    func clearFields() {
        account.clear()
    }
    
    @MainActor
    func buttonTapped() async -> Bool {
        let response = await memberService.login(data: self.account)
        
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
