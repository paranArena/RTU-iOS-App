//
//  Variables.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/23.
//

import SwiftUI

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

//let BASE_URL = "ren2u.ap-northeast-2.elasticbeanstalk.com"
let BASE_URL = "http://ec2-13-125-234-225.ap-northeast-2.compute.amazonaws.com:8080"
//let BASE_URL = "localhost:8080"

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
