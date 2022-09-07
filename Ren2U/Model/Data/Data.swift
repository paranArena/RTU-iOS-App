//
//  Data.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import Foundation
import SwiftUI

//  MARK: CLUB
struct ClubProfileData {
    var name: String
    var introduction: String
    var thumbnail: UIImage?
    var hashtags: [String]
    var thumbnailPath: String?
    
    init(clubData: ClubData) {
        self.name = clubData.name
        self.introduction = clubData.introduction
        self.hashtags = clubData.hashtags
        self.thumbnailPath = clubData.thumbnailPath
    }
    
    init() {
        self.name = ""
        self.introduction = ""
        self.hashtags = [String]()
    }
}

struct ClubData: Codable, Hashable {
    let id: Int
    var name: String
    var introduction: String
    var thumbnailPath: String?
    var hashtags: [String]
    
    static func dummyClubData() -> ClubData {
        return ClubData(id: 1, name: "오류", introduction: "오류", hashtags: ["오류"])
    }
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
    
    func extractClubData() -> ClubData {
        return ClubData(id: id, name: name, introduction: introduction, thumbnailPath: thumbnailPath, hashtags: hashtags)
    }
}

//  MARK: NOTIFICATION DATA

struct NoticeDetailData: Codable {
    let id: Int
    let title, content: String
    let imagePath: String
    let createdAt, updatedAt: String
}

struct NoticeCellData: Codable, Equatable, Identifiable {
    let id: Int
    let clubId: Int
    let title: String
    let isPublic: Bool?
    let imagePath: String
    let createdAt, updatedAt: String
}


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

enum ClubRole: String {
    case owner = "OWNER"
    case admin = "ADMIN"
    case user = "USER"
    case wait = "WAIT"
    case none = "NONE"
}

//  MARK: PRODUCT
struct ProductCellData {
    let data: ProductResponseData
    var isActive = false
}

struct ProductResponseData: Codable {
    let id: Int
    let name: String
    let category: String
    let left, max: Int
    let clubName: String
    let imagePath: String
    let clubId: Int
    
    static func dummyProductResponseData() -> ProductResponseData {
        return ProductResponseData(id: 0, name: "", category: "", left: 1, max: 1, clubName: "", imagePath: "", clubId: 1)
    }
}

struct ProductDetailData: Codable {
    let id: Int
    let name, category: String
    let location: Location
    let fifoRentalPeriod, reserveRentalPeriod, price: Int
    let caution: String
    let imagePath: String
    let items: [Item]
    
    static func dummyProductData() -> ProductDetailData {
        return ProductDetailData(id: 1, name: "", category: "", location: Location(name: "", latitude: 0.1, longitude: 0.1), fifoRentalPeriod: 1, reserveRentalPeriod: 1, price: 1, caution: "", imagePath: "", items: [Item(id: 1, numbering: 1, rentalPolicyDto: "", rental: nil)])
    }
    
    struct Location: Codable {
        let name: String
        let latitude, longitude: Double
    }
    
    struct Item: Codable {
        let id, numbering: Int
        let rentalPolicyDto: String
        let rental: Rental?
        
        enum CodingKeys: String, CodingKey {
            case id
            case numbering
            case rentalPolicyDto = "rentalPolicy"
            case rental
        }
        
        var bgColor: Color {
            if rentalPolicyDto == "FIFO" {
                return Color.yellow_FFB800
            } else {
                return Color.green_2CA900
            }
        }
        
        var rentalPolicy: String {
            if rentalPolicyDto == "FIFO" {
                return "선착순"
            } else {
                return "기간제"
            }
        }
    }
    
    struct Rental: Codable {
        let id: Int
        let rentalStatus: String
        let rentDate: String
        let expDate: String?
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
