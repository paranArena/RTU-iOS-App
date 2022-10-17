//
//  MemberManagementVM.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import Foundation
import Alamofire
import UIKit
import SwiftUI

class ManagementViewModel: ObservableObject {
    
    @Published var clubData = ClubDetailData.dummyClubData()
    
    @Published var applicants = [UserData]()
    @Published var products = [ProductPreviewDto]()
    @Published var notices = [NotificationPreviewData]()
    @Published var rentals = [ClubRentalData]()
    
    // MemberManagementView, GrantCouponView 
    @Published var members = [CouponMemberData]()
    
    var selectedMemberCount: Int {
        var result = 0
        for member in members {
            if member.isSelected {
                result += 1
            }
        }
        return result
    }
    
    //  MARK: Alert
    @Published var alert = Alert()
    @Published var deleteClubAlert = Alert()
    
    init() { }
    
    init(clubData: ClubDetailData) {
        self.clubData = clubData
        print("ManageViewModel init, groupId[\(clubData.id)]")
        
        Task {
            await searchClubMembersAll()
            await searchClubJoinsAll()
            await searchClubProductsAll()
            await searchNotificationsAll()
            await searchClubRentalsAll()
        }
    }
    
    //  MARK: For GrantCouponView
    func selectAllMembers() {
        for i in 0..<members.count {
            members[i].isSelected = true
        }
    }
    
    func unselectAllMembers() {
        for i in 0..<members.count {
            members[i].isSelected = false
        }
    }
    
    func getSelectedMembersId() -> [Int] {
        var membersId = [Int]()
        for member in members {
            if member.isSelected {
                membersId.append(member.data.id)
            }
        }
        
        return membersId
    }
    
    //  MARK: Alert
    func alertGrant(memberAndRoleData: MemberPreviewData) {
        alert.message = Text(memberAndRoleData.alertMessage)
        alert.isPresented = true
        let memberId = memberAndRoleData.id
        
        if memberAndRoleData.clubRole == ClubRole.user.rawValue {
            alert.callback = { await self.grantAdmin(memberId: memberId) }
        } else if memberAndRoleData.clubRole == ClubRole.admin.rawValue {
            alert.callback = { await self.grantUser(memberId: memberId) }
        } else {
            alert.callback = { print("에러")}
        }
    }
    
    func alertDeleteMember(memberId: Int) {
        alert.message = Text("멤버를 추방하시겠습니까?")
        alert.isPresented = true
        alert.callback = {
            Task {
                await self.removeMember(memberId: memberId)
            }
        }
    }
    
    func alertDeleteClub() {
        deleteClubAlert.message = Text("클럽을 삭제하시겠습니까?")
        deleteClubAlert.isPresented = true
        deleteClubAlert.callback = { await self.deleteClub() }
    }
    
    func acceptClubJoin(memberId: Int) async {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/requests/join/\(memberId)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .post, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let result = await request.result
        
        switch result {
        case .success(let value):
            print("acceptClubJoin Success : \(value)")
        case .failure(let err):
            print("클럽 가입 수락 실패 : \(err)")
        }
    }

    
    //  MARK: GET
    
    @MainActor
    func searchClubMembersAll() async {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/members/search/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(SearchClubMembersAllResponse.self)
        let result = await request.result
        
        switch result {
        case .success(let value):
            print("[searchClubMembersAll success]")
            print(value.responseMessage)
            self.members = value.data.map { member in
                CouponMemberData(data: member)
            }
        case .failure(let err):
            print("[seaerchClubMembersAll err]")
            print(err)
        }
        
    }
    
    @MainActor
    func searchClubJoinsAll() async {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/requests/join/search/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(SearchClubJoinsAllResponse.self)
        let result = await request.result
        
        switch result {
        case .success(let value):
            print("[searchClubJoinsAll success]")
            print(value.responseMessage)
            self.applicants = value.data
        case .failure(let err):
            print("searchClubJoinsAll 실패 : \(err)")
            print(err)
        }
    }
    
    @MainActor
    func searchClubProductsAll()  {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/products/search/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).responseDecodable(of: SearchClubProductsAll.self) {
            res in
            
            switch res.result {
            case .success(let value):
                print("[searchClubProductsAll success]")
                self.products = value.data
            case .failure(let err):
                print("[searchClubProductsAll failure]")
                print(err)
            }
            
        }
    }
    
    @MainActor
    func searchNotificationsAll() {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/notifications/search/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).responseDecodable(of: SearchNotificationsAllResponse.self) { res in
            
            switch res.result {
            case .success(let value):
                print("[searchNotificationsAll success]")
                print(value.responseMessage)
                self.notices = value.data.reversed()
                
            case .failure(let err):
                print("[searchNotificationsAll err")
                print(err)
            }
        }
    }
    
    @MainActor
    func searchClubRentalsAll() {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/rentals/search/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let decoder = JSONDecoder()

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            throw DateError.invalidDate
        })

        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).responseDecodable(of: SearchClubRentalsAllResponse.self) { res in
            switch res.result {
            case .success(let value):
                print("[searchClubRentalsAll success]")
                print(value.responseMessage)
                self.rentals = value.data
                
            case .failure(let err):
                print("[searchClubRentalsAll err]")
                print(err)
            }
        }
    }
    
    //  MARK: PUT
    func updateNotification(groupId: Int, notificationId: Int, noticeData: NotificationPreviewData) async {
        let url = "\(BASE_URL)/clubs/\(groupId)/notifications/\(notificationId)"
        let hearders: HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY)!)",
            "Content-type": "multipart/form-data"
        ]
        
//        let param: [String: Any] = [
//            "title" : noticeData.title,
//            "content" : noticeData.id
//        ]
        
        let request = AF.request(url, method: .put, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let result = await request.result
        
        switch result {
        case .success(_):
            print("deleteNotification Success")
        case .failure(let err):
            print("deleteNotification Err : \(err)")
        }
    }
    
    func grantAdmin(memberId: Int) async {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/members/\(memberId)/role/admin"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "")]
        
        let request = AF.request(url, method: .put, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GrantAdminResponse.self)
        let response = await request.response
        
        if let statusCode = response.response?.statusCode {
            print("[grantAdmin] statusCode: \(statusCode)")
            switch statusCode {
            case 200:
                await searchClubMembersAll()
            default:
                print(response.debugDescription)
            }
        }
    }
    
    func grantUser(memberId: Int) async {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/members/\(memberId)/role/user"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "")]
        
        let request = AF.request(url, method: .put, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GrantAdminResponse.self)
        let response = await request.response
        
        if let statusCode = response.response?.statusCode {
            print("[grantUser] statusCode : \(statusCode)")
            switch statusCode {
            case 200:
                await searchClubMembersAll()
            default:
                print(response.debugDescription)
            }
        }
    }
    
    //  MARK: DELETE
    
    func rejectClubJoin(memberId: Int) async {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/requests/join/\(memberId)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "")]
        
        
        let request = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let result = await request.result
        
        switch result {
        case .success(_):
            print("[rejectClubJoin Success]")
        case .failure(_):
            print("[rejectClubJoin err]")
        }
        
    }
    
    func deleteNotification(groupID: Int, notificationID: Int) async {
        let url = "\(BASE_URL)/clubs/\(groupID)/notifications/\(notificationID)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let result = await request.result
        
        switch result {
        case .success(_):
            print("deleteNotification Success")
        case .failure(let err):
            print("deleteNotification Err : \(err)")
        }
    }
    
    
    func deleteProduct(productId: Int) async {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/products/\(productId)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: hearders).serializingString()
        
        let result = await request.result
        
        switch result {
        case .success(let value):
            print("[deleteProduct success]")
            print(value)
        case .failure(let err):
            print("[deleteProduct err]")
            print(err)
        }
    }
    
    func removeMember(memberId: Int) async {
        let url = "\(BASE_URL)/clubs/\(clubData.id)/members/\(memberId)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let response = await request.response
        
        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 200:
                await self.searchClubMembersAll()
            default:
                print("에러")
            }
        }
    }
    
    func deleteClub() async {
        let url = "\(BASE_URL)/clubs/\(clubData.id)"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "" )]
        
        let request = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let result = await request.result
        
        switch result {
        case .success(_):
            print("[deleteClub success")
        case .failure(_):
            print("[deleteClub err")
        }
        
    }
    
    //  MARK: TASK
    
    func searchClubJoinsAllTask() {
        Task {
            await searchClubJoinsAll()
        }
    }
}
