//
//  Alert.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/10.
//

import Foundation
import SwiftUI

struct Alert {
    var title = ""
    var isPresented = false
    var callback: () -> () = { print("callback") }
}

struct OneButtonAlert {
    var title = ""
    var isPresented = false
    var messageText = ""
    
    var message: Text {
        return Text(messageText)
    }
    static let okButton = Button("확인", role: .cancel) { }
}


