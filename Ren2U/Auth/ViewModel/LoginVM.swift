//
//  LoginModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/18.
//

import Foundation
import SwiftUI

extension Login {
    class ViewModel: ObservableObject {
        @Published var account = Account(email: "", password: "")
        @Published var isWroungAccount = false
        
        func initTextFields() {
            self.account.email = ""
            self.account.password = ""
        }
    }
}

extension Login {
    enum Field: Int, CaseIterable {
        case email
        case password
    }

}
