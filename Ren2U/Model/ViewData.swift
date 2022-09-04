//
//  Data.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import Foundation
import SwiftUI

struct CreateClubFormdata {
    var name: String
    var introduction: String
    var thumbnail: UIImage
    var hashtags: [String]
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

struct ClubData: Codable, Hashable {
    let id: Int
    var name: String
    var introduction: String
    var thumbnailPath: String?
    var hashtags: [String]
}

struct ClubAndRoleData: Codable, Identifiable, Hashable {
    var id: Int
    var name: String
    var introduction: String
    var thumbnailPath: String
    var hashtags: [String]
    var clubRole: String
    
    static func dummyClubAndRoleData() -> ClubAndRoleData {
        return ClubAndRoleData(id: 1, name: "", introduction: "", thumbnailPath: "", hashtags: [""], clubRole: "")
    }
}

struct NoticeData: Codable, Identifiable {
    let id: Int
    let title: String
    let imagePath: String
    let createdAt: String
    let updatedAt: String
}

//  MARK: searchClubMembersAll
struct UserAndRoleData: Codable, Identifiable {
    let id: Int
    let email: String
    let name: String
    let phoneNumber: String
    let studentId: String
    let major: String
    let clubRole: String
}

enum GroupRole: String {
    case owner = "OWNER"
    case admin = "ADMIN"
    case user = "USER"
    case wait = "WAIT"
    case none = "NONE"
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
