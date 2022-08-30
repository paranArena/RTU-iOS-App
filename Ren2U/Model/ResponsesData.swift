//
//  Data.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import Foundation

struct UserData: Codable {
    var id: Int
    var email: String
    var name: String
    var phoneNumber: String
    var studentId: String
    var major: String
}

struct ClubData: Codable, Hashable {
    let id: Int
    var name: String
    var introduction: String
    var thumbnailPath: String?
    var hashtags: [String]
}

struct ClubAndRoleData: Codable, Identifiable {
    var id: Int
    var club: ClubData
    var role: String
    
    init(id: Int, club: ClubData, role: String) {
        self.id = id
        self.club = club
        self.role = role
    }
}

extension ClubAndRoleData {
    enum GroupRole: String {
        case owner = "OWNER"
        case wait = "WAIT"
        case applicant = "APPLICANT"
        case nonMember = "NONMEMBER"
    }
}
