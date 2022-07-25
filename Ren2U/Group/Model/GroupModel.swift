//
//  GroupModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import Alamofire

class GroupModel: ObservableObject {
    
    @Published var likesGroups = [LikeGroupInfo]() 
    
    @Published var joinedGroups = [GroupInfo]() // VStack에서 나열될 그룹들
    @Published var notices = [NoticeInfo]() // Vstack 한개 그룹 셀에서 이동 후 사용될 정보
    @Published var rentalItems = [RentalItemInfo]() // Vstack 한개의 그룹 셀에서 이동 후 사용될 정보
    
    func fetchJoinedGroups() {
        
    }
    
    func fetchLikesGroups() {
        
    }
    
    func fetchNotices() {
        self.notices = NoticeInfo.dummyNotices()
    }
    
    func fetchRentalItems() {
        self.rentalItems = RentalItemInfo.dummyRentalItems()
    }
    
    func makeFavoritesGroupTag(tags: [TagInfo]) -> String {
        var tagLabel: String = ""
        var newLineCounter: Int = 0
        var isReachedLineLimit = false
        
        for tag in tags {

            let newTag = "#\(tag.tag) "
            newLineCounter += newTag.utf8.count
            
            if !isReachedLineLimit && newLineCounter > 32 {
                isReachedLineLimit = true
                tagLabel.append(contentsOf: "\n")
                newLineCounter = 0
            } else if isReachedLineLimit && newLineCounter > 23 {
                tagLabel.append(contentsOf: "\n")
                return tagLabel
            }
            
            tagLabel.append(contentsOf: newTag)
        }
        
        return tagLabel
    }
    
    func makeJoinedGroupTage(tags: [TagInfo]) -> String {
        var tagLabel: String = ""
        
        for tag in tags {
            tagLabel.append(contentsOf: "#\(tag.tag )")
        }
        
        return tagLabel
    }
}
