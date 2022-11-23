//
//  PasswordReset.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/13.
//

import Foundation

struct PasswordResetParam: Codable {
    
    var email = ""
    var password = ""
    var passwordCheck = ""
    var code = "" 
    
    var checkCondition: Bool {
        if password.count < 8 || passwordCheck.count < 8 || password.count > 30 || passwordCheck.count > 30 || password != passwordCheck {
            return false
        }
        return true 
    }
    
}

struct UpdateMyInfoParam: Codable {
    var name = ""
    var major = ""
    var studentId = ""
    var phoneNumber = "" 
}