//
//  Reponses.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/29.
//

import SwiftUI

struct SignUpResponse: Codable {
    var statusCode: Int
    var responseMessage: String
    var data: UserResponse
    
}

struct LoginResponse: Codable {
    var token: String 
}

struct UserResponse: Codable {
    var id: Int
    var email: String
    var name: String
    var phoneNumber: String
    var studentId: String
    var major: String
}

struct GetMyInfoResponse: Codable {
    var statusCode: Int
    var responseMessage: String
    var data: UserResponse
}
