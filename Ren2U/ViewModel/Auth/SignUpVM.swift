//
//  SingUpViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/14.
//

import SwiftUI
import Alamofire

extension SignUp {
    class ViewModel: ObservableObject {
        
        @Published var authField = AuthField()
        @Published var oneButtonAlert = OneButtonAlert()
        
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
        
        @MainActor
        func checkPhoneStudentIdDuplicate() async -> Bool{
            let url = "\(BASE_URL)/members/duplicate/010\(authField.phoneNumber)/\(authField.studentId)/exists"
            let request = AF.request(url, method: .get, encoding: JSONEncoding.default).serializingDecodable(CheckPhoneStudentIdDuplicateResponse.self)
            
            let result = await request.result
            switch result {
            case .success(let value):
                print("checkPhoneStudentIdDuplicate success")
                let value1 = value.data.studentId
                let value2 = value.data.phoneNumber
                
                if value1 {
                    oneButtonAlert.title = "학번 중복"
                    oneButtonAlert.message = "본인의 학번일 경우 개발자에게 문의 해주세요."
                    oneButtonAlert.isPresented = true
                    return true
                }
                
                if value2 {
                    oneButtonAlert.title = "휴대폰 번호 중복"
                    oneButtonAlert.message = "본인의 번호일 경우 개발자에게 문의 해주세요."
                    oneButtonAlert.isPresented = true
                    return true
                }
                
                return false
                
            case .failure(_):
                return true
            }
        }

    }

}
