//
//  GroupManagementExtension.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/29.
//

import SwiftUI


extension GroupManagement {
    enum ManageSelection: Int, CaseIterable {
        case profileEdit
        case rentalManagement
        case notice
        case memberManagement
        case rentalActive
        
        var title: String {
            switch self {
            case .profileEdit:
                return "프로필 수정"
            case .rentalManagement:
                return "대여/물품 관리"
            case .notice:
                return "공지사항"
            case .memberManagement:
                return "멤버 관리"
            case .rentalActive:
                return "대여목록 활성화"
            }
        }
    }
}

extension GroupManagement {
    enum RentalSelection: Int, CaseIterable {
        case reservation
        case rental
        case `return`
        
        var title: String {
            switch self {
            case .reservation:
                return "예약"
            case .rental:
                return "대여"
            case .return:
                return "반납"
            }
        }
    }
}


extension GroupPage {
    enum Role: Int, CaseIterable {
        case chairman
        case member
        case application
        case none
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

