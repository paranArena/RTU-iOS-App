//
//  Variables.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/23.
//

import SwiftUI
import MapKit


let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let SAFE_AREA_TOP_HEIGHT: CGFloat = 44
let SAFE_AREA_BOTTOM_HEIGHT: CGFloat = 34

let JWT_KEY = "jwt"
let FCM_TOKEN = "FCM_TOKEN"

let DEFAULT_REGION = CLLocationCoordinate2D(latitude: 37.28, longitude: 127.0489)
let DEFAULT_SPAN = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)

let AJOU_EMAIL_SUFFIX = "@ajou.ac.kr"


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
