//
//  RetnalData.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/07.
//

import Foundation

struct RentalData: Codable {
    let id: Int
    let rentalStatus: String
    let rentDate: String
    let expDate: String?
}
