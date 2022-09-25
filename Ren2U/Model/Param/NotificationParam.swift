//
//  NotificationParam.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/20.
//

import Foundation
import SwiftUI

struct NotificationModel {
    var title: String
    var content: String
    var image: UIImage?
}

struct UpdateNotificationParam {
    let title: String
    let content: String
    let image: UIImage?
    let isPublic: Bool
}
