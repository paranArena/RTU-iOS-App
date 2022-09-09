//
//  SingUpViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/14.
//

import SwiftUI


extension SignUp {
    class ViewModel: ObservableObject {
        
//        @Published var isOverlappedEmail = false
//        @Published var text = [String] (repeating: "", count: 7)
//        @Published var isConfirmed = [Bool](repeating: false, count: 7)
//        @Published var isShowingPassword = false
//        @Published var isShowingPasswordCheck = false
        
        @Published var authField = AuthField()
        
        func changeFocus(curIndex: Int) -> SignUp.Field? {
            switch curIndex {
            case SignUp.Field.email.rawValue:
                return .password
            case SignUp.Field.password.rawValue:
                return .passwordCheck
            case SignUp.Field.passwordCheck.rawValue:
                return .name
            case SignUp.Field.name.rawValue:
                return .major
            case SignUp.Field.major.rawValue:
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
            return User(email: authField.email, password: authField.password,
                        name: authField.name, major: authField.major,
                        studentId: authField.studentId, phoneNumber: authField.phoneNumber, imageSource: "")
        }

    }

}
