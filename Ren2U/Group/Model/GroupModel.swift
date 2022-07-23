//
//  GroupModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import Alamofire

struct GroupInfo: Identifiable, Codable {
    var id = UUID()
    let imageSource: String
    let groupName: String
    let groupId: String
    let tags: [Tag]
    
    static func dummyGroup() -> GroupInfo {
        return GroupInfo(imageSource: "https://picsum.photos/200", groupName: "그룹이름", groupId: "12345",
                         tags: [Tag(tag: "tag1"), Tag(tag: "tag2"), Tag(tag: "tag3"), Tag(tag: "tag?"), Tag(tag: "태그4"), Tag(tag: "태그5"),
                                Tag(tag: "태그6"), Tag(tag: "태그7"), Tag(tag: "Final Tag!")])
    }
}

struct LikeGroup: Codable {
    let groupId: String
}

struct Tag: Codable, Hashable {
    let tag: String
}

class GroupModel: ObservableObject {
    
    @Published var joinedGoups = [GroupInfo]()
    @Published var likesGroups = [LikeGroup]()
    
    func fetchJoinedGroups() {
        
    }
    
    func fetchLikesGroups() {
        
    }
    
    func makeFavoritesGroupTag(tags: [Tag]) -> String {
        var tagLabel: String = ""
        var newLineCounter: Int = 0
        
        for tag in tags {
            print("\(tag.tag)의 길이 : \(tag.tag.utf8.count)")
            let newTag = "#\(tag.tag) "
            newLineCounter += newTag.utf8.count
            
            if newLineCounter > 24 {
                tagLabel.append(contentsOf: "\n")
                newLineCounter = 0
            }
            
            tagLabel.append(contentsOf: newTag)
        }
        
        return tagLabel
    }
    
    func makeJoinedGroupTage(tags: [Tag]) -> String {
        var tagLabel: String = ""
        
        for tag in tags {
            tagLabel.append(contentsOf: "#\(tag.tag )")
        }
        
        return tagLabel
    }
}
