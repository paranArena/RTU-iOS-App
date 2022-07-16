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
    
    static let Gray_ADB5BD = Color(hex: "ADB5BD")
    static let Gray_495057 = Color(hex: "495057")
    static let Gray_E9ECEF = Color(hex: "E9ECEF")
    static let Navy_1E2F97 = Color(hex: "1E2F97")
    static let Red_EB1808 = Color(hex: "EB1808")
    static let Green_2CA900 = Color(hex: "2CA900")
    
    static let BackgroundColor = Color("BackgroundColor")
    static let LabelColor = Color("LabelColor")
}

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func hideKeyboard() {
        guard let window = windows.first else { return }
        let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapRecognizer.cancelsTouchesInView = false
        tapRecognizer.delegate = self
        window.addGestureRecognizer(tapRecognizer)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
