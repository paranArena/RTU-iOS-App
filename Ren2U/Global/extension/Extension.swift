//
//  Extension.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/12.
//

import SwiftUI
import CoreLocation


//  MARK: CLLocationCoordinate2D

extension CLLocationCoordinate2D {
    
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return from.distance(from: to)
    }
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


//  MARK: INT extensions

//  for product cell
extension Int {
    func productStatus() -> String {
        if self == 0 {
            return "대여불가"
        } else {
            return "남은 수량"
        }
    }
    
    func productColor() -> Color {
        if self == 0 {
            return Color.red_EB1808
        } else {
            return Color.gray_868E96
        }
    }
}


//  MARK: Date extensions
//  Date to String
extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
}


