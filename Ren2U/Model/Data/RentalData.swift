//
//  RetnalData.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/07.
//

import Foundation

struct RentalData: Codable {
    let id, numbering: Int
    let name: String
    let clubId: Int
    let clubName: String
    let imagePath: String?
    let rentalPolicy: String
    let rentalInfo: RentalInfo
    let location: Location
    
    struct RentalInfo: Codable {
        var rentalStatus: String
        let rentDate: String
        var expDate: String?
        
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
    
    struct Location: Codable {
        let name: String
        let latitude: Double
        let longitude: Double
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
}
