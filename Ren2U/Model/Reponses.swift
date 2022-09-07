//
//  Reponses.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/29.
//

import SwiftUI

//  MARK: GET

struct GetMyClubRoleResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: Data
    
    struct Data: Codable {
        let clubRole: String
    }
}

struct SearchClubMembersAllResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [UserAndRoleData]
}


struct GetMyClubsResponse: Codable {
    var statusCode: Int
    var responseMessage: String
    var data: [ClubAndRoleData]
}

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

struct GetMyNotificationsResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [NoticeCellData]
}

struct GetMyProductsResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [ProductResponseData]
}

struct SearchClubProductsAll: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [ProductResponseData]
}


struct GetProductResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: ProductDetailData
}

struct GetMyRentalsResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [RentalData]
}

struct GetClubRetnalsResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [ClubRentalData]
}

//  MARK: POST

struct VerifyEmailCodeResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: String?
}

struct CreateClubResponse: Codable {
    var statusCode: Int
    var responseMessage: String
    var data: ClubData
}

struct CreateNotificationResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: NoticeDetailData
}

struct GetSearchClubsAllResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [ClubAndRoleData]
}

struct SearchClubsWithNameResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: ClubAndRoleData
}

struct SearchNotificationsAllResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [NoticeCellData]
}


//  MARK: REQUEST
struct requestClubJoinResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: String? 
}


struct SearchClubJoinsAllResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [UserData]
}

