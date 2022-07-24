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
