//
//  ProfileExtension .swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/29.
//

import SwiftUI

extension Profile {
    
    enum Field: Int, CaseIterable {
        case name
        case major
        case studentId
        case id
        case email
        case phoneNumber
        
        var title: String {
            switch self {
            case .name:
                return "이름"
            case .major:
                return "학과"
            case .studentId:
                return "학번"
            case .id:
                return "ID"
            case .email:
                return "아주대학교 이메일"
            case .phoneNumber:
                return "전화번호"
            }
        }
    }
}
