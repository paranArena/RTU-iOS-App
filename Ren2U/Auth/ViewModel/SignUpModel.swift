//
//  SingUpViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/14.
//

import SwiftUI

enum SignUpTextField: Int, CaseIterable {
    case email
    case password
    case passwordCheck
    case name
    case department
    case studentId
    case phoneNumber
}

class SignUpModel: ObservableObject {
    
    @Published var isOverlappedEmail = false
    @Published var text = [String] (repeating: "", count: 7)
    @Published var isConfirmed = [Bool](repeating: false, count: 7)
    @Published var isShowingPassword = [Bool](repeating: false, count: 2)

    func isFilledAll(textArray: [String]) -> Bool {
        
        guard self.isOverlappedEmail else { return false }
        guard self.text[SignUpTextField.password.rawValue] == self.text[SignUpTextField.passwordCheck.rawValue] else { return false }
        
        for i in 0 ..< text.count {
            if textArray[i].isEmpty {
                return false
            }
        }
        return true 
    }
    
    func isFilledAny(text1: String, text2: String) -> Bool {
        guard !text1.isEmpty && !text2.isEmpty else { return false }
        return true 
    }
    
    func isFilledAnyAndEqualText(text1: String, text2: String) -> Bool {
        guard isFilledAny(text1: text1, text2: text2) && text1 == text2 else { return false }
        return true
    }
    
    func isNextFieldIsEmpty(curIndex: Int) -> Bool {
        guard self.text[curIndex + 1].isEmpty else { return false }
        return true 
    }
}
