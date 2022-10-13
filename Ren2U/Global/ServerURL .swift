//
//  ServerURL .swift
//  Ren2U
//
//  Created by 노우영 on 2022/10/13.
//

import SwiftUI

enum ServerURL {
    case runningServer
    case prodServer
    case devServer
    
    var url: String {
        switch self {
        case .runningServer:
            return "http://15.165.38.225:8080"
        case .prodServer:
            return "https://ren2u.shop"
        case .devServer:
            return "http://15.165.38.225:8080"
        }
    }
}
