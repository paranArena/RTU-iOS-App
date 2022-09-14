//
//  Category.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI

enum Category: String, CaseIterable {
    case homeAppliances = "가전제품"
    case habit = "게임/취미"
    case study = "공부할 때"
    case book = "도서"
    case digitalDevice = "디지털기기"
    case rainyDay = "비오는 날"
    case householdItem = "생활용품"
    case sports = "스포츠/레저"
    case clothes = "의류"
    case cook = "주방용 기구"
    case temperatures = "춥거나, 더울 때"
    case picnic = "피크닉"
    case event = "행사"
    case etc = "기타" 
}

enum ClubRole: String {
    case owner = "OWNER"
    case admin = "ADMIN"
    case user = "USER"
    case wait = "WAIT"
    case none = "NONE"
}

enum RentalStatus: String, CaseIterable {
    case wait = "WAIT"
    case rent = "RENT"
//    case cancel = "CANCEL"
    
    var value: Int {
        switch self {
        case .wait:
            return 0
        case .rent:
            return 1
//        case .cancel:
//            return 2
        }
    }
    
    var title: String {
        switch self {
        case .wait:
            return "예약"
        case .rent:
            return "대여"
//        case .cancel:
//            return "취소"
        }
    }
}
