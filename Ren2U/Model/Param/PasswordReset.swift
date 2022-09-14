//
//  PasswordReset.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/13.
//

import Foundation

struct PasswordReset: Codable {
    var password = ""
    var passwordCheck = ""
    
    var checkCondition: Bool {
        if password.count < 8 || passwordCheck.count < 8 || password.count > 30 || passwordCheck.count > 30 || password != passwordCheck {
            return false
        }
        return true 
    }
}
