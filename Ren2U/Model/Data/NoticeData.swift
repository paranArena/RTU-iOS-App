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
        return NotificationDetailData(id: 1, title: SING_TITLES.randomElement()!, content: LYRICS.randomElement()!, imagePath: "", createdAtDto: DATES_YMD.randomElement()!, updatedAtDto: DATES_YMD.randomElement()!, clubName: CLUB_NAMES.randomElement()!)
    }
    
    var createdAt: Date {
        createdAtDto.toDate()
    }
    
    var updatedAt: Date {
        updatedAtDto.toDate()
    }
    
    func toParam() -> NotificationParam {
        return NotificationParam(title: self.title, content: self.content, imagePath: self.imagePath)
    }
}

struct NotificationPreviewData: Codable, Equatable, Identifiable {
    let id: Int
    let clubId: Int
    let title: String
    let isPublic: Bool?
    let imagePath: String?
   
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
    
    static func dummyNotification() -> NotificationPreviewData {
        return NotificationPreviewData(id: Int.random(in: 0..<Int.max), clubId: Int.random(in: 0..<Int.max),
                                       title: SING_TITLES.randomElement()!, isPublic: false,
                                       imagePath: "", createdAtDto: DATES_YMD.randomElement()!, updatedAtDto: DATES_YMD.randomElement()!)
    }
    
    static func dummyNotifications() -> [NotificationPreviewData] {
        var datas = [NotificationPreviewData]()
        for _ in 0..<10 {
            datas.append(dummyNotification())
        }
        
        return datas
    }
}
