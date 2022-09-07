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
    let imagePath: String
    let rentalPolicy: String
    let rentalInfo: RentalInfo
    
    struct RentalInfo: Codable {
        var rentalStatus: String
        let rentDate: String
        var expDate: String?
    }
}

struct ClubRentalData: Codable {
    let memberName: String
    let id, numbering: Int
    let name: String
    let clubId: Int
    let clubName: String
    let imagePath: String
    let rentalPolicy: String
    let rentalInfo: RentalInfo
    
    struct RentalInfo: Codable {
        var rentalStatus: String
        let rentDate: String
        var expDate: String?
    }
}
