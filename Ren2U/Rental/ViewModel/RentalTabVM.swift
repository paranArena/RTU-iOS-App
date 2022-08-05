//
//  RentalTabVM.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/05.
//

import SwiftUI

extension RentalTab {
    enum Selection: Int, CaseIterable {
        case rentalItem
        case rentalList
        
        var title: String {
            switch self {
            case .rentalItem:
                return "대여물품"
            case .rentalList:
                return "대여목록"
            }
        }
    }
}
