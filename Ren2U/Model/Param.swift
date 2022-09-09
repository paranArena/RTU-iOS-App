//
//  User.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/29.
//

import Foundation
import UIKit
import SwiftUI

struct AuthField  {
    var email: String = ""
    var password: String = ""
    var passwordCheck: String = ""
    var name: String = ""
    var major: String = ""
    var studentId: String = ""
    var phoneNumber: String = ""
    
    var isShowingPassword = false
    var isShowingPasswordCheck = false
    
    var isDuplicatedEmail = false
    var isCheckedEmailDuplicate = false
    
    
    var checkEmailButtonCondition: Bool {
        if email.count < 6 || email.count > 30 {
            return false
        } else {
            return true
        }
    }

    var checkEmailCondition: Bool {
        if !isDuplicatedEmail && isCheckedEmailDuplicate {
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
        if !isDuplicatedEmail && isCheckedEmailDuplicate && checkNameContion && checkMajorCondition && checkStudentIdCondition && chekcPhonumberCondition && isEqualPassword {
            return true
        } else {
            return false
        }
    }
    
    //  MARK: COLOR
    var emailBottomLineColor: Color {
        if isCheckedEmailDuplicate && !isDuplicatedEmail {
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
}

struct User: Codable {
    var email: String
    var password: String
    var name: String
    var major: String
    var studentId: String
    var phoneNumber: String
    var imageSource: String
    
    static func dummyUser() -> User {
        return  User(email: "temp", password: "12345", name: "Page", major: "소프트웨어학과",
                     studentId: "201820767", phoneNumber: "01012345678", imageSource: "https://picsum.photos/seed/picsum/200/300")
    }
}


//  MARK: NOTIFICATION
struct NotificationModel {
    var title: String
    var content: String
    var image: UIImage?
}

struct UpdateNotificationParam {
    let title: String
    let content: String
    let image: UIImage?
    let isPublic: Bool
}



struct Account: Codable {
    var email: String
    var password: String
}


struct CreateClubFormdata {
    var name: String
    var introduction: String
    var thumbnail: UIImage
    var hashtags: [String]
}

