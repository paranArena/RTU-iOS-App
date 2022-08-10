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
    let groupDto: GroupDto
    var didLike = false
    
    struct GroupDto: Codable {
        let imageSource: String
        let groupName: String
        let groupId: String
        let tags: [TagInfo]
        let intoduction: String
    }
    
    static func dummyGroup() -> GroupInfo {
        return GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/200", groupName: "아나바다", groupId: "12345",
                         tags: [TagInfo(tag: "태그"), TagInfo(tag: "태그"), TagInfo(tag: "태그"), TagInfo(tag: "태그"),
                                TagInfo(tag: "태그"), TagInfo(tag: "태그"), TagInfo(tag: "태그"), TagInfo(tag: "태그"),
                                TagInfo(tag: "태그4"), TagInfo(tag: "태그5"),
                                TagInfo(tag: "태그6"), TagInfo(tag: "태그7"), TagInfo(tag: "Final Tag!")],
                                intoduction: "산아, 푸른 산아. 철철철 흐르듯 짙푸른 산아. 무성히 무성히 우거진 산마루에 금빛 기름진 햇살을 내려오고 둥둥 산을 넘어 흰 구름 걷는 자리 씻기는 하늘 사슴도 안오고 바람도 안불고 너멋골 골짜기서 울어오는 뻐꾸기..."))
    }
    static func dummyGroups() -> [GroupInfo] {
        return [
                GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/id/10/200/300", groupName: "그룹1", groupId: "1", tags: [TagInfo(tag: "태그1")], intoduction: "첫번째 그룹")),
                GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/id/20/200/300", groupName: "그룹2", groupId: "2", tags: [TagInfo(tag: "태그2")], intoduction: "두번째 그룹")),
                GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/id/30/200/300", groupName: "그룹3", groupId: "3", tags: [TagInfo(tag: "태그3")], intoduction: "세번째 그룹")),
                GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/id/40/200/300", groupName: "그룹4", groupId: "4", tags: [TagInfo(tag: "태그4")], intoduction: "번번째 그룹")),
                GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/id/50/200/300", groupName: "그룹5", groupId: "5", tags: [TagInfo(tag: "태그5")], intoduction: "다섯번째 그룹")),
                GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/id/60/200/300", groupName: "그룹6", groupId: "6", tags: [TagInfo(tag: "태그6")], intoduction: "여섯번째 그룹")),
                GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/id/70/200/300", groupName: "그룹7", groupId: "7", tags: [TagInfo(tag: "태그7")], intoduction: "일곱번째 그룹")),
                GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/id/80/200/300", groupName: "그룹8", groupId: "8", tags: [TagInfo(tag: "태그8")], intoduction: "여덟번째 그룹")),
                GroupInfo(groupDto: GroupDto(imageSource: "https://picsum.photos/id/90/200/300", groupName: "그룹9", groupId: "9", tags: [TagInfo(tag: "태그9")], intoduction: "아홉번째 그룹"))
        
        ]
    }
}

struct TempGroupInfo: Codable {
    var name: String
    var introduction: String
}

struct LikeGroupInfo: Codable {
    var groupId: String
    
    init(groupId: String) {
        self.groupId = groupId
    }
    
    static func dummyLikeGroupInfos() -> [LikeGroupInfo] {
        return [LikeGroupInfo(groupId: "1"), LikeGroupInfo(groupId: "4"), LikeGroupInfo(groupId: "6"), LikeGroupInfo(groupId: "8")]
    }
}

class GroupViewModel: ObservableObject {
    
    @Published var likesGroupId = [LikeGroupInfo]()
    @Published var joinedGroups = [GroupInfo]() // VStack에서 나열될 그룹들
    
    @Published var notices = [NoticeInfo]() // Vstack 한개 그룹 셀에서 이동 후 사용될 정보
    @Published var rentalItems = [RentalItemInfo]() // Vstack 한개의 그룹 셀에서 이동 후 사용될 정보
    
    @Published var itemViewActive = [Bool]()
    
    func createClub(club: TempGroupInfo) async {
        let url = "\(baseURL)/clubs"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.value(forKey: jwtKey) as! String)]
        let param: [String: Any] = [
            "name": club.name,
            "introduction": club.introduction
        ]
        
        let task = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let response = await task.result
        
        switch response {
        case .success(let value):
            print(value.description)
        case .failure(let err):
            print(err.errorDescription!)
        }
    }
    
    func fetchJoinedGroups() {
        self.joinedGroups = GroupInfo.dummyGroups()
        self.fetchLikesGroups()
    }
    
    func fetchLikesGroups() {
        self.likesGroupId = LikeGroupInfo.dummyLikeGroupInfos()
    }
    
    func getLikesGroups() {
        
        for i in 0..<joinedGroups.count {
            let joinedGroup = joinedGroups[i]
            
            likesGroupId.contains { likesGroup in
                if likesGroup.groupId == joinedGroup.groupDto.groupId {
                    joinedGroups[i].didLike = true
                    return true
                } else {
                    return false
                }
            }
        }

    }
    
    func likesGroup(group: GroupInfo) {
        likesGroupId.append(LikeGroupInfo(groupId: group.groupDto.groupId))
    }
    
    func unlikesGroups() {
        //  좋아요 등록된 것중에 didLike = false면 삭제
        likesGroupId.removeAll { likesGroups in
            joinedGroups.contains { groupInfo in
                if groupInfo.groupDto.groupId == likesGroups.groupId && !groupInfo.didLike {
                    return true
                } else {
                    return false
                }
            }
        }
    }
    
    func unlikeGroup(group: GroupInfo) {
        likesGroupId.removeAll { likeGroup in
            if likeGroup.groupId == group.groupDto.groupId {
                return true
            } else {
                return false 
            }
        }
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
    
    func taskCreateClub(club: TempGroupInfo) {
        Task {
            await createClub(club: club)
        }
    }
}
