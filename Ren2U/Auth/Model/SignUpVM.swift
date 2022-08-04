//
//  SingUpViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/14.
//

import SwiftUI

extension SignUp {
    enum Field: Int, CaseIterable {
        case email
        case password
        case passwordCheck
        case name
        case department
        case studentId
        case phoneNumber
    }
}


extension SignUp {
    class ViewModel: ObservableObject {
        
        @Published var isOverlappedEmail = false
        @Published var text = [String] (repeating: "", count: 7)
        @Published var isConfirmed = [Bool](repeating: false, count: 7)
        @Published var isShowingPassword = false
        @Published var isShowingPasswordCheck = false
        @Published var goCeritification = false

        func isFilledAll(textArray: [String]) -> Bool {
            
            guard self.isOverlappedEmail else { return false }
            guard self.text[SignUp.Field.password.rawValue] == self.text[SignUp.Field.passwordCheck.rawValue] else { return false }
            
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
        
        func foucsChange(curIndex: Int) -> SignUp.Field? {
            guard curIndex < text.count - 1 else { return nil }
            guard self.text[curIndex + 1].isEmpty else { return nil }
            
            switch curIndex {
            case SignUp.Field.email.rawValue:
                return .password
            case SignUp.Field.password.rawValue:
                return .passwordCheck
            case SignUp.Field.passwordCheck.rawValue:
                return .name
            case SignUp.Field.name.rawValue:
                return .department
            case SignUp.Field.department.rawValue:
                return .studentId
            case SignUp.Field.studentId.rawValue:
                return .phoneNumber
            case SignUp.Field.phoneNumber.rawValue:
                return nil
            default:
                return nil
            }
            
        }
        
        func getUserInfo() -> User {
            return User(email: text[SignUp.Field.email.rawValue], password: text[SignUp.Field.password.rawValue],
                        name: text[SignUp.Field.name.rawValue], major: text[SignUp.Field.department.rawValue],
                        studentId: text[SignUp.Field.studentId.rawValue], phoneNumber: text[SignUp.Field.studentId.rawValue])
        }

    }

}
