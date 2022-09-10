//
//  Alert.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/10.
//

import Foundation

struct Alert {
    var title = ""
    var isPresented = false
    var callback: () -> () = { print("callback") }
}
