//
//  ProductParam.swift
//  Ren2U
//
//  Created by 노우영 on 2022/11/11.
//

import Foundation

struct ProductParam: Codable {
    var imagePath: String = ""
    var name: String = ""
    var price: String = ""
    var fifoCount: Int = 0
    var reserveCount: Int = 0
    var fifoRentPeriod: Int = 0
    var reserveRentPeriod: Int = 0
    var locationName: String = ""
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    var caution: String = ""
    var isUseLocation = true
}
