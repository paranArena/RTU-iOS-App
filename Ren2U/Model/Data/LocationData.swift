//
//  LocationData.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/21.
//

import SwiftUI

struct LocationData: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
    
    static func dummyLocationDate() -> LocationData {
        return LocationData(name: "아주대", latitude: DEFAULT_REGION.latitude, longitude: DEFAULT_REGION.longitude)
    }
}
