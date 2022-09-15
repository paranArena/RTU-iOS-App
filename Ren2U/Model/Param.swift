//
//  User.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/29.
//

import Foundation
import UIKit
import SwiftUI

//  MARK: NOTIFICATION
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

struct CreateClubFormdata {
    var name: String
    var introduction: String
    var thumbnail: UIImage
    var hashtags: [String]
}

