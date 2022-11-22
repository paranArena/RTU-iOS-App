//
//  Reponses.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/29.
//

import SwiftUI


class CustomDecoder: JSONDecoder {
    let dateFormatter = DateFormatter()

    override init() {
        super.init()
        dateDecodingStrategy = .iso8601
    }
}


//  MARK: GET

//  MARK: CLUB_NOTIFICATION
struct CreateNofiticationResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: NotificationDetailData
}

struct DefaultPostResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: String? 
}

struct CheckPhoneStudentIdDuplicateResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: DuplicateCheckData 
}

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
    let data: [MemberPreviewData]
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
    let data: [NotificationPreviewData]
}

struct GetMyProductsResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [ProductPreviewDto]
}

struct SearchClubProductsAll: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [ProductPreviewDto]
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

struct SearchClubRentalsAllResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [ClubRentalData]
}

struct GetNotificationResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: NotificationDetailData
}

struct GetClubInfoResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: ClubDetailData
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
    var data: ClubDetailData
}

struct CreateNotificationResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: NotificationDetailData
}

struct GetSearchClubsAllResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [ClubAndRoleData]
}

struct SearchClubsWithNameResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [ClubAndRoleData]
}

struct SearchNotificationsAllResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [NotificationPreviewData]
}


//  MARK: REQUEST
struct requestClubJoinResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: String? 
}

//  MARK: PUT
struct GrantAdminResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: String?
}

struct SearchClubJoinsAllResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [UserData]
}

struct RequestRentResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: RentalInfo
}

