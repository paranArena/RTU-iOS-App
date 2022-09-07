//
//  ClubData.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/07.
//

import SwiftUI

struct ClubProfileData {
    var name: String
    var introduction: String
    var thumbnail: UIImage?
    var hashtags: [String]
    var thumbnailPath: String?
    
    init(clubData: ClubData) {
        self.name = clubData.name
        self.introduction = clubData.introduction
        self.hashtags = clubData.hashtags
        self.thumbnailPath = clubData.thumbnailPath
    }
    
    init() {
        self.name = ""
        self.introduction = ""
        self.hashtags = [String]()
    }
}

struct ClubData: Codable, Hashable {
    let id: Int
    var name: String
    var introduction: String
    var thumbnailPath: String?
    var hashtags: [String]
    
    static func dummyClubData() -> ClubData {
        return ClubData(id: 1, name: "오류", introduction: "오류", hashtags: ["오류"])
    }
}

struct ClubAndRoleData: Codable, Identifiable, Hashable {
    var id: Int
    var name: String
    var introduction: String
    var thumbnailPath: String
    var hashtags: [String]
    var clubRole: String
    
    static func dummyClubAndRoleData() -> ClubAndRoleData {
        return ClubAndRoleData(id: 1, name: "", introduction: "", thumbnailPath: "", hashtags: [""], clubRole: "")
    }
    
    func extractClubData() -> ClubData {
        return ClubData(id: id, name: name, introduction: introduction, thumbnailPath: thumbnailPath, hashtags: hashtags)
    }
}
