//
//  Extension.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/12.
//

import SwiftUI

extension Color {
    
    init(hex: String) {
       let scanner = Scanner(string: hex)
       _ = scanner.scanString("#")
       
       var rgb: UInt64 = 0
       scanner.scanHexInt64(&rgb)
       
       let r = Double((rgb >> 16) & 0xFF) / 255.0
       let g = Double((rgb >>  8) & 0xFF) / 255.0
       let b = Double((rgb >>  0) & 0xFF) / 255.0
       self.init(red: r, green: g, blue: b)
     }
    
    static let Gray_ADB5BD = Color(hex: "ADB5BD")
    static let Gray_495057 = Color(hex: "495057")
    static let GrayDivider = Color(hex: "E9ECEF")
    static let NavyView = Color(hex: "1E2F97")
    static let RedText = Color(hex: "EB1808")
}
