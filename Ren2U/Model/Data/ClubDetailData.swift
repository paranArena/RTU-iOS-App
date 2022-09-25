//
//  ClubData.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/07.
//

import SwiftUI

struct ClubDetailParam {
    var name: String
    var introduction: String
    var thumbnail: UIImage?
    var hashtags: [String]
    var thumbnailPath: String?
    
    init(clubData: ClubDetailData) {
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

struct ClubDetailData: Codable, Hashable {
    let id: Int
    var name: String
    var introduction: String
    var thumbnailPath: String?
    var hashtags: [String]
    
    static func dummyClubData() -> ClubDetailData {
        return ClubDetailData(id: -1, name: "", introduction: "", hashtags: [])
    }
}

struct ClubAndRoleData: Codable, Identifiable, Hashable {
    var id: Int
    var name: String
    var introduction: String
    var thumbnailPath: String
    var hashtags: [String]
    var clubRole: String
    
    var buttonText: String {
        if clubRole == "USER" {
            return "탈퇴하기"
        } else if clubRole == "NONE" {
            return "가입하기"
        } else {
            //USER와 ADMIN까지 포함된다. 
            return "가입취소"
        }
    }
    
    var oneLineHashtag: String {
        var result = ""
        for hashtag in hashtags {
            result.append("#\(hashtag) ")
        }
        return result
    }
    
    static func dummyClubAndRoleData() -> ClubAndRoleData {
        return ClubAndRoleData(id: 1, name: "", introduction: "", thumbnailPath: "", hashtags: [""], clubRole: "")
    }
    
    func extractClubData() -> ClubDetailData {
        return ClubDetailData(id: id, name: name, introduction: introduction, thumbnailPath: thumbnailPath, hashtags: hashtags)
    }
}
