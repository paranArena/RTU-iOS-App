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
    let tags: [Tag]
}

struct Tag: Codable, Hashable {
    let tag: String
}

class GroupModel: ObservableObject {
    @Published var groups = [GroupInfo]()
    
    func fetchGroups() {
        
    }
    
//    func dummyGroups() -> [GroupInfo] {
//        
//    }
}
