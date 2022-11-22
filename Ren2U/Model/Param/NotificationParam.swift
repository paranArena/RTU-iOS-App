//
//  NotificationParam.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/20.
//

import Foundation
import SwiftUI

struct NotificationParam: Codable{
    var title: String = ""
    var content: String = ""
    var imagePath: String = ""
    
    var isCreatable: Bool {
        return !(title.isEmpty || content.isEmpty)
    }
}

struct UpdateNotificationParam: Codable {
    let title: String
    let content: String
    let imagePaths: String
    let isPublic: Bool
}
