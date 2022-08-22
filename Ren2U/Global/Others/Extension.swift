//
//  Extension.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/12.
//

import SwiftUI

extension Color {
    
    init(hex: String) {
       let scanner = Scanner(string: hex)
       _ = scanner.scanString("#")
       
       var rgb: UInt64 = 0
       scanner.scanHexInt64(&rgb)
       
       let r = Double((rgb >> 16) & 0xFF) / 255.0
       let g = Double((rgb >>  8) & 0xFF) / 255.0
       let b = Double((rgb >>  0) & 0xFF) / 255.0
       self.init(red: r, green: g, blue: b)
     }
    
    // 흰색-회색 계열
    static let gray_ADB5BD = Color(hex: "ADB5BD")
    static let gray_Shadow = Color(hex: "ADB5BD")
    static let Gray_495057 = Color(hex: "495057")
    static let gray_E9ECEF = Color(hex: "E9ECEF")
    static let Gray_DEE2E6 = Color(hex: "DEE2E6")
    static let gray_FFFFFF = Color(hex: "FFFFFF")
    static let gray_F1F2F3 = Color(hex: "F1F2F3")
    static let gray_868E96 = Color(hex: "868E96")
    static let gray_F8F9FA = Color(hex: "F8F9FA")
    
    static let navy_1E2F97 = Color(hex: "1E2F97")
    
    static let red_EB1808 = Color(hex: "EB1808")
    static let red_FF6155 = Color(hex: "FF6155")
    
    static let green_2CA900 = Color(hex: "2CA900")
    
    static let BackgroundColor = Color("BackgroundColor")
    static let LabelColor = Color("LabelColor")
}

extension UIApplication {
    
    // 키보드 종료 
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
    // 키보드 외 영역 터치시에 키보드 내리려면 이 함수를 onAppear에 적용하기
    // 최초 한번만 call 하면 모든 곳에 적용된다. 
    func hideKeyboard() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapRecognizer.cancelsTouchesInView = false
        tapRecognizer.delegate = self
        window!.addGestureRecognizer(tapRecognizer)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

//  Preference Width Key
public struct ViewWidthKey: PreferenceKey {
    public typealias Value = CGFloat
    public static var defaultValue = CGFloat.zero
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

