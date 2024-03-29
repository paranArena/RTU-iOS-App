//
//  CouponParam.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/21.
//

import Foundation
import SwiftUI

struct CouponParam: Codable {
    var name = ""
    var location = ""
    var latitude: Double?
    var longitude: Double?
    var information = ""
    var imagePath = ""
    var actDate: Date?
    var expDate: Date?
    
    var period: String {
        if actDate == nil {
            return ""
        } else {
            return "\(actDate?.toYMDformat() ?? "") ~ \(expDate?.toYMDformat() ?? "")"
        }
    }
    
    var isFilledAllParams: Bool {
        guard !name.isEmpty else { return false }
        guard !location.isEmpty else { return false }
        guard !information.isEmpty else { return false }
        guard (latitude != nil && longitude != nil) else { return false }
        return true
    }
    
    var showMapButtonBGColor: Color {
        if latitude == nil || longitude == nil {
            return Color.gray_F1F2F3
        } else {
            return Color.navy_1E2F97
        }
    }
    
    var showMapButtonFGColor: Color {
        if latitude == nil || longitude == nil {
            return Color.black
        } else {
            return Color.white
        }
    }
}
