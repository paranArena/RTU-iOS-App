//
//  NavigationBarColor.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/14.
//
//  Reference : https://blog.techchee.com/navigation-bar-title-style-color-and-custom-back-button-in-swiftui/

import UIKit

class Theme {
    static func navigationBarColors(tintColor: UIColor? = nil) {
        UINavigationBar.appearance().tintColor = tintColor ?? .clear
    }
}
