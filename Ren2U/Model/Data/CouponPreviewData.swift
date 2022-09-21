//
//  CouponData.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/21.
//

import SwiftUI

struct GetClubCouponsAdminResponse: Codable {
    let statusCode: Int
    let responseMessage: String
    let data: [CouponPreviewData]
}

struct CouponPreviewData: Codable, Identifiable {
    let id: Int
    let clubId: Int
    let clubName: String
    let name: String
    let imagePath: String
    let actDateDto: String
    let expDateDto: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case clubId
        case clubName
        case name
        case imagePath
        case actDateDto = "actDate"
        case expDateDto = "expDate"
    }
    
    var actDate: String {
        return self.actDateDto.toDate().toYMDformat()
    }
    
    var expDate: String {
        return self.expDateDto.toDate().toYMDformat()
    }
}
