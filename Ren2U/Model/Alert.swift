//
//  Alert.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/10.
//

import Foundation
import SwiftUI

protocol BaseAlert: Equatable {
    var title: String { get }
    var message: String { get }
    var callback: () async -> () { get }
}

struct CustomAlert {
    var titleText: String = ""
    var messageText: String = ""
    var callback: () async -> () = { }
    var isPresentedAlert = false
    var isPresentedCancelButton = false
    
    var message: Text {
        Text(messageText)
    }
    
    static let CancelButton = Button("취소", role: .cancel) { }
}

// MARK: Deprecated
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

