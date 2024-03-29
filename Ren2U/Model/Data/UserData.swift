//
//  Data.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import Foundation
import SwiftUI

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


struct CouponMemberData: Codable {
    var isSelected = false
    let data: MemberPreviewData
    
    var selectButtonStrokeColor: Color {
        if isSelected {
            return Color.navy_1E2F97
        } else {
            return Color.gray_ADB5BD
        }
    }
}

struct MemberPreviewData: Codable, Identifiable {
    let id: Int
    let email: String?
    let name: String
    let phoneNumber: String?
    let studentId: String
    let major: String?
    let clubRole: String?
    
    var grantButtonText: String {
        if clubRole == ClubRole.user.rawValue {
            return "권한부여"
        } else if clubRole == ClubRole.admin.rawValue {
            return "권한제거"
        } else {
            return "에러"
        }
    }
    
    var grantButtonHidden: Bool {
        if clubRole == ClubRole.owner.rawValue {
            return true
        } else {
            return false
        }
    }
    
    var alertMessage: String {
        if clubRole == ClubRole.user.rawValue {
            return "관리자 권한을 주시겠습니까?"
        } else if clubRole == ClubRole.admin.rawValue {
            return "관리자 권한을 제거하시겠습니까?"
        } else {
            return "에러"
        }
    }
    
    var year: String {
        return studentId.substring(from: 3, to: 4)
    }
}

struct UserData: Codable, Identifiable {
    var id: Int
    var email: String?
    var name: String
    var phoneNumber: String?
    var studentId: String
    var major: String?
    
    static func dummyUserData() -> UserData {
        return UserData(id: 123, email: "nou0jid", name: "노우영", phoneNumber: "01064330824", studentId: "201820767", major: "소프트웨어학과")
    }
}

struct DuplicateCheckData: Codable {
    let phoneNumber: Bool
    let studentId: Bool
    
    static func dummyDuplicateCheckData() -> DuplicateCheckData {
        return DuplicateCheckData(phoneNumber: false, studentId: false)
    }
}

//  MARK: Response

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
