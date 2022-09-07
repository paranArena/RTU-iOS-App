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
        let parsedString = self.components(separatedBy: .whitespaces)
        var whiteSpaceRemovedString = ""
        
        for i in 0..<parsedString.count {
            if parsedString[i] == "" {
                continue
            }
            
            whiteSpaceRemovedString.append(contentsOf: parsedString[i])
            if i < parsedString.count - 1 {
                whiteSpaceRemovedString.append(contentsOf: " ")
            }
        }
        
        print(whiteSpaceRemovedString)
        return whiteSpaceRemovedString
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: self)
    }
}
