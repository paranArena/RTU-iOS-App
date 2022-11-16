//
//  LoginParam.swift
//  Ren2U
//
//  Created by 노우영 on 2022/10/20.
//

import Foundation
import SwiftUI 

struct LoginParam: Codable {
    var email = ""
    var password = ""
    
    var fgColorLoginButton: Color {
        if email.isEmpty || password.isEmpty {
            return Color.gray_E9ECEF
        } else {
            return Color.navy_1E2F97
        }
    }
    
    var isDisableLoginButton: Bool {
        if email.isEmpty || password.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    mutating func clear() {
        self.email = ""
        self.password = "" 
    }
}
