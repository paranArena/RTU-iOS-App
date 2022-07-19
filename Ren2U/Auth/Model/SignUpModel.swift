//
//  SingUpViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/14.
//

import SwiftUI

enum SignUpField: Int, CaseIterable {
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
    @Published var isShowingPassword = false
    @Published var isShowingPasswordCheck = false

    func isFilledAll(textArray: [String]) -> Bool {
        
        guard self.isOverlappedEmail else { return false }
        guard self.text[SignUpField.password.rawValue] == self.text[SignUpField.passwordCheck.rawValue] else { return false }
        
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
    
    func foucsChange(curIndex: Int) -> SignUpField? {
        guard curIndex < text.count - 1 else { return nil }
        guard self.text[curIndex + 1].isEmpty else { return nil }
        
        switch curIndex {
        case SignUpField.email.rawValue:
            return .password
        case SignUpField.password.rawValue:
            return .passwordCheck
        case SignUpField.passwordCheck.rawValue:
            return .name
        case SignUpField.name.rawValue:
            return .department
        case SignUpField.department.rawValue:
            return .studentId
        case SignUpField.studentId.rawValue:
            return .phoneNumber
        case SignUpField.phoneNumber.rawValue:
            return nil
        default:
            return nil
        }
        
    }
    
    func getUserInfo() -> User {
        return User(email: text[SignUpField.email.rawValue], password: text[SignUpField.password.rawValue],
                    name: text[SignUpField.name.rawValue], department: text[SignUpField.department.rawValue],
                    studentId: text[SignUpField.studentId.rawValue], phoneNumber: text[SignUpField.studentId.rawValue],
                    deviceToken: "")
    }

}
