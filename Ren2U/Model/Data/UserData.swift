//
//  Data.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import Foundation
import SwiftUI

//  MARK: USER
struct UserAndRoleData: Codable, Identifiable {
    let id: Int
    let email: String
    let name: String
    let phoneNumber: String
    let studentId: String
    let major: String
    let clubRole: String
}

struct UserData: Codable, Identifiable {
    var id: Int
    var email: String
    var name: String
    var phoneNumber: String
    var studentId: String
    var major: String
    
    static func dummyUserData() -> UserData {
        return UserData(id: 123, email: "nou0jid", name: "노우영", phoneNumber: "01064330824", studentId: "201820767", major: "소프트웨어학과")
    }
}

//  MARK: TEMP
struct LikeGroupInfo: Codable {
    var groupId: String
    
    init(groupId: String) {
        self.groupId = groupId
    }
    
    static func dummyLikeGroupInfos() -> [LikeGroupInfo] {
        return [LikeGroupInfo(groupId: "1"), LikeGroupInfo(groupId: "4"), LikeGroupInfo(groupId: "6"), LikeGroupInfo(groupId: "8")]
    }
}
