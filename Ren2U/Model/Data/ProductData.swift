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
    
    static func dummyProductPreviewData() -> [ProductPreviewData] {
        return ProductPreviewDto.dummyProductPreviewDtoDatas().map { ProductPreviewData(data: $0) }
    }
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
        return ProductPreviewDto(id: Int.random(in: 0..<Int.max), name: PRODUCT_NAMES.randomElement()!,
                                 category: Category.allCases.randomElement()!.rawValue, left: Int.random(in: 0..<10),
                                 max: Int.random(in: 10..<30), clubName: CLUB_NAMES.randomElement()!,
                                 imagePath: "", clubId: Int.random(in: 0..<Int.max))
    }
    
    static func dummyProductPreviewDtoDatas() -> [ProductPreviewDto] {
        var datas = [ProductPreviewDto]()
        for _ in 0..<10 {
            datas.append(dummyProductResponseData())
        }
        
        return datas
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
