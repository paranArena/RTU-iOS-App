//
//  GroupEnums.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/24.
//

import Foundation
import SwiftUI

// struct - Info, Dto
// enum = field, role, selection

enum GroupSelection: Int, CaseIterable {
    case group
    case notice
    
    var title: String {
        switch self {
        case .group:
            return "그룹"
        case .notice:
            return "공지사항"
        }
    }
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


enum RentalSelection: Int, CaseIterable {
    case rentalItem
    case rentalList
    
    var title: String {
        switch self {
        case .rentalItem:
            return "대여물품"
        case .rentalList:
            return "대여목록"
        }
    }
}

struct GroupInfo: Identifiable, Codable {
    
    var id = UUID()
    let groupDto: GroupDto
    var didLike = false
    
    struct GroupDto: Codable {
        let imageSource: String
        let groupName: String
        let groupId: String
        let tags: [TagInfo]
        let intoduction: String
    }
    
    static func dummyGroup() -> GroupInfo {
        return GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/200", groupName: "아나바다", groupId: "12345",
                         tags: [TagInfo(tag: "태그"), TagInfo(tag: "태그"), TagInfo(tag: "태그"), TagInfo(tag: "태그"),
                                TagInfo(tag: "태그"), TagInfo(tag: "태그"), TagInfo(tag: "태그"), TagInfo(tag: "태그"),
                                TagInfo(tag: "태그4"), TagInfo(tag: "태그5"),
                                TagInfo(tag: "태그6"), TagInfo(tag: "태그7"), TagInfo(tag: "Final Tag!")],
                                intoduction: "산아, 푸른 산아. 철철철 흐르듯 짙푸른 산아. 무성히 무성히 우거진 산마루에 금빛 기름진 햇살을 내려오고 둥둥 산을 넘어 흰 구름 걷는 자리 씻기는 하늘 사슴도 안오고 바람도 안불고 너멋골 골짜기서 울어오는 뻐꾸기..."))
    }
    static func dummyGroups() -> [GroupInfo] {
        return [
                GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/id/10/200/300", groupName: "그룹1", groupId: "1", tags: [TagInfo(tag: "태그1")], intoduction: "첫번째 그룹")),
                GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/id/20/200/300", groupName: "그룹2", groupId: "1", tags: [TagInfo(tag: "태그2")], intoduction: "두번째 그룹")),
                GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/id/30/200/300", groupName: "그룹3", groupId: "1", tags: [TagInfo(tag: "태그3")], intoduction: "세번째 그룹")),
                GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/id/40/200/300", groupName: "그룹4", groupId: "1", tags: [TagInfo(tag: "태그4")], intoduction: "번번째 그룹")),
                GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/id/50/200/300", groupName: "그룹5", groupId: "1", tags: [TagInfo(tag: "태그5")], intoduction: "다섯번째 그룹")),
                GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/id/60/200/300", groupName: "그룹6", groupId: "1", tags: [TagInfo(tag: "태그6")], intoduction: "여섯번째 그룹")),
                GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/id/70/200/300", groupName: "그룹7", groupId: "1", tags: [TagInfo(tag: "태그7")], intoduction: "일곱번째 그룹")),
                GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/id/80/200/300", groupName: "그룹8", groupId: "1", tags: [TagInfo(tag: "태그8")], intoduction: "여덟번째 그룹")),
                GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/id/90/200/300", groupName: "그룹9", groupId: "1", tags: [TagInfo(tag: "태그9")], intoduction: "아홉번째 그룹"))
        
        ]
    }
}

struct LikeGroupInfo: Codable {
    let groupId: String
    
    static func dummyLikeGroupInfos() -> [LikeGroupInfo] {
        return [LikeGroupInfo(groupId: "1"), LikeGroupInfo(groupId: "4"), LikeGroupInfo(groupId: "6"), LikeGroupInfo(groupId: "8")]
    }
}

struct TagInfo: Identifiable, Codable, Hashable {
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
