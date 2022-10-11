//
//  StringExtension.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/07.
//

import Foundation

//  MARK: String extensions

//  SubString 구하기
extension String {
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1)
        
        return String(self[startIndex ..< endIndex])
    }
    
    func removeWhiteSpace() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
//        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
//        dateFormatter.locale = Locale(identifier: "ko_KR")
        let date = dateFormatter.date(from: self) ?? Date.now
//        date.addTimeInterval(60*60*9)
        
        return date
    }
    
    func toDateType2() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return dateFormatter.date(from: self) ?? Date.now
    }
    
    func toDateType3() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return dateFormatter.date(from: self) ?? Date.now
    }
}
