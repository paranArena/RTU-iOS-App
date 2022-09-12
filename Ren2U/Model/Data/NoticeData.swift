//
//  NoticeData.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/07.
//

import SwiftUI

struct NotificationDetailData: Codable {
    let id: Int
    let title, content: String
    let imagePath: String
    let createdAtDto, updatedAtDto: String
    let clubName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case imagePath
        case createdAtDto = "createdAt"
        case updatedAtDto = "updatedAt"
        case clubName
    }
    
    static func dummyNotificationDetailData() -> NotificationDetailData {
        return NotificationDetailData(id: 1, title: "", content: "", imagePath: "", createdAtDto: "", updatedAtDto: "", clubName: "")
    }
    
    var createdAt: Date {
        createdAtDto.toDate()
    }
    
    var updatedAt: Date {
        updatedAtDto.toDate()
    }
}

struct NotificationPreview: Codable, Equatable, Identifiable {
    let id: Int
    let clubId: Int
    let title: String
    let isPublic: Bool?
    let imagePath: String
   
    let createdAtDto, updatedAtDto: String
    
    var createdAt: Date {
        createdAtDto.toDate()
    }
    
    var updatedAt: Date {
        updatedAtDto.toDate()
    }
    
    var updateText: String {
        return updatedAt.toYMDformat()
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case clubId
        case title
        case isPublic
        case imagePath
        case createdAtDto = "createdAt"
        case updatedAtDto = "updatedAt"
    }
    
    static let reportTitle = "공지사항 신고를 접수하시겠습니까?"
}
