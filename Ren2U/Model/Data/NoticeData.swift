//
//  NoticeData.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/07.
//

import SwiftUI

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
}
