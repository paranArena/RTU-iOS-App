//
//  User.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/29.
//

import Foundation

struct User: Codable {
    var email: String
    var password: String
    var name: String
    var major: String
    var studentId: String
    var phoneNumber: String
    var imageSource: String
    
    static func dummyUser() -> User {
        return  User(email: "temp", password: "12345", name: "Page", major: "소프트웨어학과",
                     studentId: "201820767", phoneNumber: "01012345678", imageSource: "https://picsum.photos/seed/picsum/200/300")
    }
}


