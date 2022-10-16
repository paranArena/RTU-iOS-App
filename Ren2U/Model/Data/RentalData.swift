//
//  RetnalData.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/07.
//

import Foundation

enum RentalPolicy: String, CaseIterable {
    case fifo = "FIFO"
    case reserve = "RESERVE"
}

struct RentalData: Codable {
    let id, numbering: Int
    let name: String
    let clubId: Int
    let clubName: String
    let imagePath: String?
    let rentalPolicy: String
    let rentalInfo: RentalInfo
    let location: LocationData
    
    static func dummyRentalData() -> RentalData {
        
        return RentalData(id: Int.random(in: 0..<Int.max), numbering: Int.random(in: 0..<Int.max), name: PRODUCT_NAMES.randomElement()!,
                          clubId: Int.random(in: 0..<Int.max), clubName: CLUB_NAMES.randomElement()!, imagePath: "",
                          rentalPolicy: RentalPolicy.allCases.randomElement()!.rawValue, rentalInfo: RentalInfo.dummyRentalInfo(),
                          location: LocationData.dummyLocationDate())
    }
    
    static func dummyRentalDatas() -> [RentalData] {
        var datas = [RentalData]()
        for _ in 0..<10 {
            datas.append(self.dummyRentalData())
        }
        
        return datas
    }
}

struct ClubRentalData: Codable {
    let memberName: String
    let id, numbering: Int
    let name: String
    let clubId: Int
    let clubName: String
    let imagePath: String?
    let rentalPolicy: String
    let rentalInfo: RentalInfo
    
    struct RentalInfo: Codable {
        var rentalStatus: String
        let rentDateDto: String
        var expDate: String?
        
        enum CodingKeys: String, CodingKey {
            case rentalStatus
            case rentDateDto = "rentDate"
            case expDate
        }
        
        var rentDate: Date {
            return rentDateDto.toDate()
        }
        
        var remainTime: Int {
            return Int(60*10 - Date.now.timeIntervalSince(rentDate))
        }
    }
}

struct RentalInfo: Codable {
    let rentalStatus: String
    let rentDate: String
    let expDate: String?
    let meRental: Bool?
    
    static func dummyRentalInfo() -> RentalInfo {
        
        let meRentals: [Bool] = [true, false]
        
        return RentalInfo(rentalStatus: "RENT", rentDate: "2022-09-08T01:59:45.705393", expDate: "2022-09-08T01:59:45.705393", meRental: meRentals.randomElement()!)
    }
    
    var alertMeesage: String {
        if rentalStatus == RentalStatus.wait.rawValue {
            return "예약을 취소하시겠습니까?"
        } else if rentalStatus == RentalStatus.rent.rawValue {
            return "아이템을 반납하시겠습니까?"
        } else {
            return "에러"
        }
    }
    
    var toDate: Date {
        return rentDate.toDate()
    }
    
    var time: Int {
        return Int(60*10 - Date.now.timeIntervalSince(rentDate.toDate()))
    }
}
