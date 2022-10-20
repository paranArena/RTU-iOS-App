//
//  SignUpParam.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/14.
//

import SwiftUI

struct SignUpParam  {
    var email: String = ""
    var password: String = ""
    var passwordCheck: String = ""
    var name: String = ""
    var major: String = ""
    var studentId: String = ""
    var phoneNumber: String = ""
    var code: String = "" 
    
    var isShowingPassword = false
    var isShowingPasswordCheck = false
    
    var emailDuplication: EmailDuplication = .none
    
    private let minEmailLength = 3
    private let maxEmailLength = 30

    mutating func clearLogin() {
        self.email = ""
        self.password = ""
    }
    
    mutating func clearCode() {
        self.code = "" 
    }
    
    var fgColorLoginButton: Color {
        if email.isEmpty || password.isEmpty {
            return Color.gray_E9ECEF
        } else {
            return Color.navy_1E2F97
        }
    }
    
    var isDisableLoginButton: Bool {
        if email.isEmpty || password.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    
    var checkEmailButtonCondition: Bool {
        if email.count < minEmailLength || email.count > maxEmailLength {
            return false
        } else {
            return true
        }
    }

    var checkEmailCondition: Bool {
        if emailDuplication == .notDuplicated {
            return true
        } else {
            return false
        }
    }
    
    var isEqualPassword: Bool {
        if password == passwordCheck && checkPasswordCondition{
            return true
        } else {
            return false
        }
    }
    
    var checkPasswordCondition: Bool {
        if password.count < 8 || password.count > 30 {
            return false
        } else {
            return true
        }
    }
    
    var checkPasswordCheckCondition: Bool {
        if passwordCheck.count < 8 || passwordCheck.count > 30 {
            return false
        } else {
            return true
        }
    }
    
    var checkNameContion: Bool {
        if name.count < 2 || name.count > 10 {
            return false
        } else {
            return true
        }
    }
    
    var checkMajorCondition: Bool {
        if major.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    var checkStudentIdCondition: Bool {
        if studentId.count < 6 || studentId.count > 15 {
            return false
        } else {
            return true
        }
    }
    
    var chekcPhonumberCondition: Bool {
        if phoneNumber.count == 8 {
            return true
        } else {
            return false
        }
    }
    
    var checkAll: Bool {
        if checkEmailCondition && checkNameContion && checkMajorCondition && checkStudentIdCondition && chekcPhonumberCondition && isEqualPassword {
            return true
        } else {
            return false
        }
    }
    
    //  MARK: COLOR
    
    var emailButtonColor: Color {
        if isDisabledButton {
            return .gray_ADB5BD
        } else {
            return .navy_1E2F97
        }
    }
    
    var emailBottomLineColor: Color {
        if checkEmailCondition {
            return Color.navy_1E2F97
        } else {
            return Color.gray_DEE2E6
        }
    }
    
    var passwordBottomeLineColor: Color {
        if checkPasswordCondition { return Color.navy_1E2F97 }
        else { return Color.gray_DEE2E6 }
    }
    
    var passwordCheckBottomeLineColor: Color {
        if checkPasswordCheckCondition { return Color.navy_1E2F97 }
        else { return Color.gray_DEE2E6 }
    }
    
    var nameBottomLineColor: Color {
        if checkNameContion { return Color.navy_1E2F97 }
        else { return Color.gray_DEE2E6 }
    }
    
    var majorBottomLineColor: Color {
        if checkMajorCondition { return Color.navy_1E2F97 }
        else { return Color.gray_DEE2E6 }
    }
    
    var studentIdLineColor: Color {
        if checkStudentIdCondition { return Color.navy_1E2F97 }
        else { return Color.gray_DEE2E6 }
    }
    
    var phoneNumberColor: Color {
        if chekcPhonumberCondition { return Color.navy_1E2F97 }
        else { return Color.gray_DEE2E6 }
    }
    
    var wrongEmailColor: Color {
        if checkEmailCondition {
            return Color.green_2CA900
        } else {
            return Color.red_EB1808
        }
    }
    
    var wrongPasswordColor: Color {
        if password.count < 8 || password.count > 30 {
            return Color.red_EB1808
        } else {
            return Color.green_2CA900
        }
    }
    
    var wrongPasswordCheckColor: Color {
        if password != passwordCheck {
            return Color.red_EB1808
        } else {
            return Color.green_2CA900
        }
    }
    
    var wrongNameColor: Color {
        if checkNameContion {
            return Color.green_2CA900
        } else {
            return Color.red_EB1808
        }
    }
    
    var wrongStudentIdColor: Color {
        if checkStudentIdCondition {
            return Color.green_2CA900
        } else {
            return Color.red_EB1808
        }
    }
    
    //  MARK: STRING
    
    var wrongEmail: String {
        if emailDuplication == .none {
            if email.count > 0 && email.count < minEmailLength {
                return "이메일이 너무 짧습니다."
            } else if email.count > 30 {
                return "이메일이 너무 깁니다."
            } else {
                return " "
            }
        } else {
            if emailDuplication == .duplicated {
                return "이미 가입된 이메일입니다."
            } else {
                return "사용할 수 있는 이메일입니다."
            }
        }
    }
    
    var wrongPassword: String {
        if password.count > 0 && password.count < 8 {
            return "비밀번호가 너무 짧습니다."
        } else if password.count > 30 {
            return "비밀번호가 너무 깁니다."
        } else {
            return " "
        }
    }
    
    var wrongPasswordCheck: String {
        if passwordCheck.count < 8 || password.count < 8 {
            return ""
        } else if password != passwordCheck {
            return "비밀번호가 일치하지 않습니다."
        } else {
            return "비밀번호가 일치합니다."
        }
    }
    
    var wrongName: String {
        if name.count > 0 && name.count < 2 {
            return "이름이 너무 짧습니다."
        } else if name.count > 10 {
            return "이름이 너무 깁니다."
        } else {
            return " "
        }
    }
    
    var wrongStudentId: String {
        if studentId.count > 0 && studentId.count < 6 {
            return "학번이 너무 짧습니다."
        } else if studentId.count > 15 {
            return "학번이 너무 깁니다."
        } else {
            return " "
        }
    }
    
    //  MARK: BOOL
    
    var isDisabledButton: Bool {
        if emailDuplication != .none || !checkEmailButtonCondition {
            return true
        } else {
            return false
        }
    }
}

extension SignUpParam {
    enum EmailDuplication {
        case none
        case duplicated
        case notDuplicated
        
        var text: String {
            switch self {
            case .none:
                return ""
            case .duplicated:
                return "이미 가입된 이메일입니다."
            case .notDuplicated:
                return "사용할 수 있는 이메일입니다."
            }
        }
        
        mutating func setEmailDuplicate(result: Bool) {
            if result {
                self = .duplicated
            } else {
                self = .notDuplicated
            }
        }
    }
}
