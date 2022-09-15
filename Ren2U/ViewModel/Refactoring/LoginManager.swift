//
//  LoginManager.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/14.
//

import Foundation

class LoginManager: ObservableObject {
    
    @Published var isLogined = false
    
    init() {
        if UserDefaults.standard.string(forKey: JWT_KEY) == nil {
            isLogined = false
        } else {
            isLogined = true
        }
    }
}
