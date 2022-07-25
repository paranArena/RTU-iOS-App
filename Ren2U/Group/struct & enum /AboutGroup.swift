//
//  GroupEnums.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/24.
//

import Foundation
import SwiftUI

struct GroupInfo: Identifiable, Codable {
    var id = UUID()
    let imageSource: String
    let groupName: String
    let groupId: String
    let tags: [Tag]
    let intoduction: String
    
    
    static func dummyGroup() -> GroupInfo {
        return GroupInfo(imageSource: "https://picsum.photos/200", groupName: "아나바다", groupId: "12345",
                         tags: [Tag(tag: "태그"), Tag(tag: "태그"), Tag(tag: "태그"), Tag(tag: "태그"),
                                Tag(tag: "태그"), Tag(tag: "태그"), Tag(tag: "태그"), Tag(tag: "태그"),
                                Tag(tag: "태그4"), Tag(tag: "태그5"),
                                Tag(tag: "태그6"), Tag(tag: "태그7"), Tag(tag: "Final Tag!")],
                                intoduction: "산아, 푸른 산아. 철철철 흐르듯 짙푸른 산아. 무성히 무성히 우거진 산마루에 금빛 기름진 햇살을 내려오고 둥둥 산을 넘어 흰 구름 걷는 자리 씻기는 하늘 사슴도 안오고 바람도 안불고 너멋골 골짜기서 울어오는 뻐꾸기...")
    }
}

struct LikeGroup: Codable {
    let groupId: String
}

struct Tag: Identifiable, Codable, Hashable {
    var id = UUID()
    let tag: String
}

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
    let total: Int
    let remain: Int
}

enum CreateGroupField: Int, CaseIterable {
    case groupName
    case tagsText
    case introduction
}

enum GroupRole: Int, CaseIterable {
    case chairman
    case member
    case application 
    case none
}
