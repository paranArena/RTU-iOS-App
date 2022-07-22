//
//  GroupModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import Alamofire

struct GroupInfo: Identifiable, Codable {
    let id = UUID()
    let imageSource: String
    let groupName: String
    let groupId: String
    let tags: [Tag]
    
    static func dummyGroup() -> GroupInfo {
        return GroupInfo(imageSource: "https://picsum.photos/200", groupName: "그룹이름", groupId: "12345", tags: [Tag(tag: "tag1"), Tag(tag: "tag2")] )
    }
}

struct LikeGroup: Codable {
    let groupId: String
}

struct Tag: Codable, Hashable {
    let tag: String
}

class GroupModel: ObservableObject {
    @Published var groups = [GroupInfo]()
    @Published var likesGroups = [LikeGroup]()
    
    func fetchGroups() {
        
    }
}
