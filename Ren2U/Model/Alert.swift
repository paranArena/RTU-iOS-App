//
//  Alert.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/10.
//

import Foundation
import SwiftUI

// legacy 
struct Alert {
    var message = Text("")
    var isPresented = false
    var callback: () async -> () = { }
}

struct OneButtonAlert {
    var title = ""
    var isPresented = false
    var messageText = ""
    var callback: () async -> () = { } 
    
    var message: Text {
        return Text(messageText)
    }
    
    static let noActionButton = Button("확인", role: .cancel) {}
}

struct TwoButtonsAlert {
    var title = ""
    var isPresented = false
    var messageText = ""
    var callback: () async -> () = { print("callback") }
    
    var message: Text {
        return Text(messageText)
    }
}

