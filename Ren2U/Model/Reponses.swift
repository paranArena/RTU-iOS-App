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
    let data: [ClubAndRoleData]
}

struct SearchClubsWithName: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: ClubAndRoleData
}

struct SearchNotificationsAllResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [NoticeData]
}


//  MARK: REQUEST
struct requestClubJoinResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: String? 
}


//  MARK: 임시 코드 

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

struct SearchClubJoinsAllResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [UserData]
}

