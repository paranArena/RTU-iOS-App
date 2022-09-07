//
//  Variables.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/23.
//

import SwiftUI


let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let SAFE_AREA_TOP_HEIGHT: CGFloat = 44
let SAFE_AREA_BOTTOM_HEIGHT: CGFloat = 34 

//let BASE_URL = "http://ec2-15-165-38-225.ap-northeast-2.compute.amazonaws.com:8080"
let BASE_URL = "https://ren2u.shop"

let JWT_KEY = "jwt"


public struct ViewOffsetKey: PreferenceKey {
    public typealias Value = CGFloat
    public static var defaultValue = CGFloat.zero
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

public struct ViewWidthKey: PreferenceKey {
    public typealias Value = CGFloat
    public static var defaultValue = CGFloat.zero
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

public struct ViewHeightKey: PreferenceKey {
    public typealias Value = CGFloat
    public static var defaultValue = CGFloat.zero
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

public struct ViewMaxYKey: PreferenceKey {
    public typealias Value = CGFloat
    public static var defaultValue = CGFloat.zero
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
