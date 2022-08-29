//
//  SignUp.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/29.
//

import SwiftUI

extension SignUp {
    
    enum Field: Int, CaseIterable, Hashable {
        case email
        case password
        case passwordCheck
        case name
        case major
        case studentId
        case phoneNumber
        
        var title: String {
            switch self {
            case .email:
                return "아주대학교 이메일 "
            case .password:
                return "Password"
            case .passwordCheck:
                return "Password 확인"
            case .name:
                return "이름"
            case .major:
                return "학과"
            case .studentId:
                return "학번"
            case .phoneNumber:
                return "휴대폰 번호"
            }
        }
    }
}
