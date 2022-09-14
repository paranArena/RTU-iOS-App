//
//  DateExtension.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/10.
//

import Foundation

extension Date {
    func toYMDformat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: self)
    }
    
    func toReturnString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd"
        return dateFormatter.string(from: self)
    }
  
    func getTemp() -> Double {
        let now = Date.now
        let diff = now.timeIntervalSince(self)
        
        print("now: \(now)")
        print("diff: \(self)")
        return diff 
    }
}
