//
//  ProductData.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/07.
//

import Foundation
import SwiftUI 

struct ProductPreviewData {
    let data: ProductPreviewDto
    var isActive = false
}

struct ProductPreviewDto: Codable {
    let id: Int
    let name: String
    let category: String
    let left, max: Int
    let clubName: String
    let imagePath: String?
    let clubId: Int
    
    static func dummyProductResponseData() -> ProductPreviewDto {
        return ProductPreviewDto(id: 0, name: "", category: "", left: 1, max: 1, clubName: "", imagePath: "", clubId: 1)
    }
    
    var status: String {
        if left == 0 {
            return "대여불가"
        } else {
            return "남은 수량"
        }
    }
    
    var fgColor: Color {
        if left == 0 {
            return Color.red_EB1808
        } else {
            return Color.gray_868E96
        }
    }
}

struct ProductDetailData: Codable {
    let id: Int
    var name, category: String
    var location: Location
    var fifoRentalPeriod, reserveRentalPeriod, price: Int
    var caution: String
    let imagePath: String?
    let items: [ItemData]
    
    static func dummyProductData() -> ProductDetailData {
        return ProductDetailData(id: 1, name: "", category: "", location: Location(name: "", latitude: 0.1, longitude: 0.1), fifoRentalPeriod: 1, reserveRentalPeriod: 1, price: 1, caution: "", imagePath: "", items: [ItemData.dummyItemData()])
    }
    
    struct Location: Codable {
        var name: String
        let latitude, longitude: Double
    }
}
