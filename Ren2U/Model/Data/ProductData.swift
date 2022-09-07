//
//  ProductData.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/07.
//

import Foundation
import SwiftUI 

struct ProductCellData {
    let data: ProductResponseData
    var isActive = false
}

struct ProductResponseData: Codable {
    let id: Int
    let name: String
    let category: String
    let left, max: Int
    let clubName: String
    let imagePath: String
    let clubId: Int
    
    static func dummyProductResponseData() -> ProductResponseData {
        return ProductResponseData(id: 0, name: "", category: "", left: 1, max: 1, clubName: "", imagePath: "", clubId: 1)
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
    let name, category: String
    let location: Location
    let fifoRentalPeriod, reserveRentalPeriod, price: Int
    let caution: String
    let imagePath: String
    let items: [Item]
    
    static func dummyProductData() -> ProductDetailData {
        return ProductDetailData(id: 1, name: "", category: "", location: Location(name: "", latitude: 0.1, longitude: 0.1), fifoRentalPeriod: 1, reserveRentalPeriod: 1, price: 1, caution: "", imagePath: "", items: [Item(id: 1, numbering: 1, rentalPolicyDto: "", rentalInfo: nil)])
    }
    
    struct Location: Codable {
        let name: String
        let latitude, longitude: Double
    }
    
    struct Item: Codable {
        let id, numbering: Int
        let rentalPolicyDto: String
        let rentalInfo: Rental?
        
        enum CodingKeys: String, CodingKey {
            case id
            case numbering
            case rentalPolicyDto = "rentalPolicy"
            case rentalInfo
        }
//
        var bgColor: Color {
            if rentalPolicyDto == "FIFO" {
                return Color.yellow_FFB800
            } else {
                return Color.green_2CA900
            }
        }

        var rentalPolicy: String {
            if rentalPolicyDto == "FIFO" {
                return "선착순"
            } else {
                return "기간제"
            }
        }
        
        var status: String {
            if rentalInfo == nil {
                return "대여 가능"
            } else if rentalInfo?.rentalStatus == "WAIT" {
                return "예약중"
            } else {
                return "처리 필요"
            }
        }
    }
    
    struct Rental: Codable {
        let rentalStatus: String
        let rentDate: String
        let expDate: String?
    }
}
