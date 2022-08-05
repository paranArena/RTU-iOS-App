//
//  GroupModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import Alamofire

class GroupViewModel: ObservableObject {
    
    @Published var likesGroups = [LikeGroupInfo]()
//    @Published var 
    @Published var joinedGroups = [GroupInfo]() // VStack에서 나열될 그룹들
    @Published var notices = [NoticeInfo]() // Vstack 한개 그룹 셀에서 이동 후 사용될 정보
    @Published var rentalItems = [RentalItemInfo]() // Vstack 한개의 그룹 셀에서 이동 후 사용될 정보
    @Published var itemViewActive = [Bool]()
    
    func fetchJoinedGroups() {
        self.joinedGroups = GroupInfo.dummyGroups()
        self.fetchLikesGroups()
    }
    
    func fetchLikesGroups() {
        self.likesGroups = LikeGroupInfo.dummyLikeGroupInfos()
    }
    
    func fetchNotices() {
        self.notices = NoticeInfo.dummyNotices()
    }
    
    func fetchRentalItems() {
        self.rentalItems = RentalItemInfo.dummyRentalItems()
        self.itemViewActive = [Bool](repeating: false, count: rentalItems.count)
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
