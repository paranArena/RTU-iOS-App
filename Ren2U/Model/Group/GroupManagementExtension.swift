//
//  GroupManagementExtension.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/29.
//

import SwiftUI


extension ClubManagementView {
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

extension ClubManagementView {
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
