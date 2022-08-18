//
//  RentalViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/18.
//

import SwiftUI
import Foundation


struct ReturnInfo: Codable {
    var imageSource: String
    var itemName: String
    
    init(imageSource: String, itemName: String) {
        self.imageSource = imageSource
        self.itemName = itemName
    }
    
    static func dummyReturnInfo() -> ReturnInfo {
        return ReturnInfo(imageSource: "https://picsum.photos/id/1058/200/300", itemName: "운동장")
    }
}

class RentalViewModel: ObservableObject {
    
}
