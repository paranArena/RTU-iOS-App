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
    @Published var oneButtonAlert = OneButtonAlert()
    //  MARK: PUT
    
    
    func checkCondition() {
        print("????????")
        if input.checkCondition {
            Task {
                await resetPassword()
            }
        } else {
            showAlert()
        }
    }
    
    @MainActor
    func resetPassword() async {
        
        let url = "\(BASE_URL)/info/password"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "")]
        
        let param: [String: Any] = [
            "password": input.password
        ]
          
        let request = AF.request(url, method: .put, parameters: param, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let response = await request.response
        
        switch response.result {
        case .success(_):
            print("[resetPassword success]")
        case .failure(let err):
            print("[resetPassword err]")
            print(err)
        }
    }
    
    private func showAlert() {
        oneButtonAlert.title = "변경 불가능"
        oneButtonAlert.message = "비밀번호를 다시 입력해주세요."
        oneButtonAlert.isPresented = true
    }
}
