//
//  LoginModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/18.
//

import Foundation
import SwiftUI

extension Login {
    class ViewModel: ObservableObject {
        @Published var account = Account(email: "", password: "")
        @Published var isWroungAccount = false
        
        var authenticationInfo: String {
            if isWroungAccount {
                return "이메일 또는 비밀번호를 잘못 입력했습니다"
            } else {
                return " "
            }
        }
        
        func initValue() {
            self.account.email = ""
            self.account.password = ""
            self.isWroungAccount = false
        }
    }
}

extension Login {
    enum Field: Int, CaseIterable {
        case email
        case password
    }

}
