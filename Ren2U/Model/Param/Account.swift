//
//  Account.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/14.
//

import Foundation
import SwiftUI

struct Account: Codable {
    var email: String = ""
    var password: String = ""
    
    var buttonFGColor: Color {
        if email.isEmpty || password.isEmpty {
            return Color.gray_E9ECEF
        } else {
            return Color.navy_1E2F97
        }
    }
    
    var isDisable: Bool {
        if email.isEmpty || password.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    mutating func clear() {
        self.email = ""
        self.password = ""
    }
}
