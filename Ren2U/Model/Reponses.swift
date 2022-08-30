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
    var data: UserData
    
}

struct LoginResponse: Codable {
    var token: String 
}

struct GetMyInfoResponse: Codable {
    var statusCode: Int
    var responseMessage: String
    var data: UserData
}

struct SerachClubsAllResponse: Codable {
    var statusCode: Int
    var responseMessage: String
    var data: ClubData
}

struct CreateClubResponse: Codable {
    var statusCode: Int
    var responseMessage: String
    var data: ClubData
}

struct GetMyClubsResponse: Codable {
    var statusCode: Int
    var responseMessage: String
    var data: [ClubAndRoleData]
}

struct GetSearchClubsAllResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [ClubData]
}
// MARK: 임시 코드

struct NoticeInfo: Identifiable {
    var id = UUID()
    let groupName: String
    let noticeDto: NoticeDto
    let isShown: Bool
    
    struct NoticeDto: Codable {
        let imageSource: String?
        let title: String
        let updateDate: Date
    }
    
    static func dummyNotice() -> NoticeInfo {
        return NoticeInfo(groupName: "아나바다", noticeDto: NoticeDto(imageSource: "https://picsum.photos/id/13/200/300", title: "그룹 공지!!", updateDate: Date.now), isShown: false)
    }
    
    static func dummyNotices() -> [NoticeInfo] {
        return [
            NoticeInfo(groupName: "아나바다", noticeDto: NoticeDto(imageSource: "https://picsum.photos/seed/picsum/200/300",
                                                               title: "그룹 공지!!", updateDate: Date.now), isShown: false),
            NoticeInfo(groupName: "Ren2U", noticeDto: NoticeDto(imageSource: "https://picsum.photos/seed/picsum/200/300",
                                                                title: "그룹 공지~~", updateDate: Date.now), isShown: true),
            NoticeInfo(groupName: "Page", noticeDto: NoticeDto(imageSource: nil,
                                                               title: "그룹 공지!!", updateDate: Date.now), isShown: false)]
    }
}

struct RentalItemInfo: Identifiable, Codable {
    var id = UUID()
    let imageSource: String
    let itemName: String
    let total: Int
    let remain: Int
    
    static func dummyRentalItem() -> RentalItemInfo {
        return RentalItemInfo(imageSource: "https://picsum.photos/id/0/200/300", itemName: "컴퓨터", total: 4, remain: 4)
    }
    
    static func dummyRentalItems() -> [RentalItemInfo] {
        return [
            RentalItemInfo(imageSource: "https://picsum.photos/id/0/200/300", itemName: "컴퓨터", total: 4, remain: 4),
            RentalItemInfo(imageSource: "https://picsum.photos/id/1/200/300", itemName: "컴퓨터", total: 5, remain: 1),
            RentalItemInfo(imageSource: "https://picsum.photos/id/2/200/300", itemName: "컴퓨터", total: 3, remain: 1),
            RentalItemInfo(imageSource: "https://picsum.photos/id/3/200/300", itemName: "컴퓨터", total: 1, remain: 0),
            RentalItemInfo(imageSource: "https://picsum.photos/id/4/200/300", itemName: "컴퓨터", total: 6, remain: 3),
            RentalItemInfo(imageSource: "https://picsum.photos/id/5/200/300", itemName: "컴퓨터", total: 3, remain: 2),
        ]
    }
}

