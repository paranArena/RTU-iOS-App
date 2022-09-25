//
//  PasswordViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/13.
//

import SwiftUI
import Alamofire

class PasswordViewModel: ObservableObject {
    
    @Published var input = PasswordReset()
    @Published var myInfoparam = UpdateMyInfoParam()
    
    @Published var oneButtonAlert = OneButtonAlert()
    @Published var dismissAlert = OneButtonAlert()
    
    @Published var isCodeRequested = false
    //  MARK: PUT
    
    init() {}
    
    init(email: String) {
        self.input.email = email
    }
    
    private func showAlert() {
        oneButtonAlert.title = "변경 불가능"
        oneButtonAlert.messageText = "비밀번호를 다시 입력해주세요."
        oneButtonAlert.isPresented = true
    }
    
    
    func requestEmailCode(email: String) {
        let url = "\(BASE_URL)/members/email/requestCode"
        let param: [String: Any] = [
            "email" : "\(email)"
        ]
        
        self.isCodeRequested = true
        
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).responseString { res in
            print(res.debugDescription)
            switch res.result {
            case .success(let value):
                print("[requestEmailCode success]")
                print(value)
            case .failure(let err):
                print("[requestEmailCode err]")
                print(err)
            }
        }
    }
    
    @MainActor
    func passwordResetWithVerificationCode() async {
        let url = "\(BASE_URL)/password/reset/verify"
        let param: [String: Any] = [
            "email" : "\(input.email)",
            "code" : "\(input.code)",
            "password" : "\(input.password)"
        ]
        
        if !input.checkCondition {
            showAlert()
            return
        }
        
        let request = AF.request(url, method: .put, parameters: param, encoding: JSONEncoding.default).serializingString()
        let response = await request.response
        
        if let statusCode = response.response?.statusCode {
            print(response.debugDescription)
            switch statusCode {
            case 200:
                dismissAlert.title = "변경 성공"
                dismissAlert.isPresented = true
                dismissAlert.messageText = "비밀번호를 변경했습니다."
                break
            default:
                if let data = response.data {
                    let error = try? JSONDecoder().decode(ServerError.self, from: data)
                    if let code = error?.code {
                        switch code {
                        case "WRONG_VERIFICATION_CODE":
                            print("print4")
                            oneButtonAlert.title = "인증번호 에러"
                            oneButtonAlert.isPresented = true
                            oneButtonAlert.messageText = "인증번호를 확인해주세요."
                        default:
                            showAlert()
                        }
                    }
                }
            }
        }
    }
}
