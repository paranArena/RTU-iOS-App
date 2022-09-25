//
//  CouponData.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/21.
//

import SwiftUI



struct CouponPreviewData: Codable, Identifiable {
    let id: Int
    let clubId: Int
    let clubName: String
    let name: String
    let imagePath: String
    let actDateDto: String
    let expDateDto: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case clubId
        case clubName
        case name
        case imagePath
        case actDateDto = "actDate"
        case expDateDto = "expDate"
    }
    
    var actDate: String {
        return self.actDateDto.toDateType2().toYMDformat()
    }
    
    var expDate: String {
        return self.expDateDto.toDateType2().toYMDformat()
    }
}

struct CouponDetailAdminData: Codable {
    let id: Int
    let name: String
    let imagePath: String
    let actDateDto, expDateDto: String
    let information: String
    let allCouponCount: Int
    let leftCouponCount: Int
    let location: LocationData
    
    static func dummyData() -> CouponDetailAdminData {
        return CouponDetailAdminData(id: 0, name: "", imagePath: "", actDateDto: "", expDateDto: "", information: "", allCouponCount: 0, leftCouponCount: 0, location: LocationData.dummyLocationDate())
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imagePath, information, location
        case allCouponCount, leftCouponCount
        case actDateDto = "actDate"
        case expDateDto = "expDate"
    }
    
    var actDate: String {
        return self.actDateDto.toDateType2().toYMDformat()
    }
    
    var expDate: String {
        return self.expDateDto.toDateType2().toYMDformat()
    }
    
    var period: String {
        return "\(self.actDate) ~ \(self.expDate)"
    }
}

struct CouponDetailUserData: Codable {
    let id: Int
    let clubId: Int
    let name: String
    let clubName: String
    let imagePath: String
    let actDateDto, expDateDto: String
    let information: String
    let location: LocationData
    
    static func dummyCouponDetailUserDate() -> CouponDetailUserData {
        return CouponDetailUserData(id: 0, clubId: 0, name: "", clubName: "", imagePath: "", actDateDto: "", expDateDto: "", information: "", location: LocationData.dummyLocationDate())
    }
    
    enum CodingKeys: String, CodingKey {
        case id, clubId
        case name, clubName
        case imagePath, information, location
        case actDateDto = "actDate"
        case expDateDto = "expDate"
    }
    
    var actDate: String {
        return self.actDateDto.toDateType2().toYMDformat()
    }
    
    var expDate: String {
        return self.expDateDto.toDateType2().toYMDformat()
    }
    
    var period: String {
        return "\(self.actDate) ~ \(self.expDate)"
    }
}

struct CouponMembersData: Codable, Identifiable {
    let id: Int
    let memberPreviewDto: MemberPreviewDto
}

struct MemberPreviewDto: Codable {
    let id: Int
    let name: String
    let major: String
    let studentId: String
    
    var year: String {
        return studentId.substring(from: 3, to: 4)
    }
}

//  MARK: RESPONSES

struct GetClubCouponsAdminResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [CouponPreviewData]
}


struct GetCouponAdminResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: CouponDetailAdminData
}

struct GetCouponUserResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: CouponDetailUserData
}

struct GetMyCouponsAllResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [CouponPreviewData]
}

struct GetMyCouponHistoriesAllResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [CouponPreviewData]
}

struct GetCouponMembersAdmin: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [CouponMembersData]
}

struct GetCouponMembersHistoriesAdmin: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [CouponMembersData]
}

