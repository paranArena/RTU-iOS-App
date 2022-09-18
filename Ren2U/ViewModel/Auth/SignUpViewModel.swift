//
//  SignUpViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/12.
//

import SwiftUI
import Alamofire

class SignUpViewModel: ObservableObject {
    
    @Published var authField = AuthField()
    
    //  MARK: NavitaionLink
    @Published var isActiveCertificationView = false
    
    //  MARK: ALERT
    @Published var isDulpicatedStudentId = false
    @Published var isDuplicatedPhoneNumber = false
    
    // MARK: For CertificationView
    let certificationNumLengthLimit = 6
    let time: Double = 5*60
    
    @Published var startTime = Date.now
    @Published var timeRemaining: Double = 5*60
    @Published var isConfirmed: Bool = true
    @Published var timer = Timer()
    @Published var isActiveSignUpSuccess: Bool = false
    
    //  MARK: LOCAL
    
    func startTimer() {
        self.timer.invalidate()
        startTime = Date.now
        timeRemaining = time
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { Timer in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer.invalidate()
            }
        })
    }
    
    func endEditingIfLengthLimitReached() {
        if self.authField.code.count == self.certificationNumLengthLimit { UIApplication.shared.endEditing() }
    }
    
    func isReachedMaxLength(num: String) -> Bool {
        guard num.count == certificationNumLengthLimit else { return false }
        return true
    }
    
    func getTimeString(time: Double) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    func setTimeRemaining() {
        let curTime = Date.now
        let diffTime = curTime.distance(to: startTime)
        let result = Double(diffTime.formatted())!
        timeRemaining = 5*60 + result
        
        if timeRemaining < 0 {
            timeRemaining = 0
        }
    }
    
    func resend() {
        requestEmailCode()
        startTimer()
        authField.clearCode()
    }
    
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
    
    //  MARK: get
    
    @MainActor
    func checkPhoneStudentIdDuplicate() async {
        let url = "\(BASE_URL)/members/duplicate/010\(authField.phoneNumber)/\(authField.studentId)/exists"
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default).serializingDecodable(CheckPhoneStudentIdDuplicateResponse.self)
        
        let resposne = await request.response
        
        if let statusCode = resposne.response?.statusCode {
            switch statusCode {
            case 200:
                print("[checkPhoneStudentIdDuplicate success]")
                if let value = resposne.value {
                    isDulpicatedStudentId = value.data.studentId
                    isDuplicatedPhoneNumber = value.data.phoneNumber
                    
                    if !isDulpicatedStudentId && !isDulpicatedStudentId {
                        isActiveCertificationView = true
                        requestEmailCode()
                    }
                }
                
            default:
                print("[checkPhoneStudentIdDuplicated unexpected result")
                print(resposne.debugDescription)
            }
        }
    }
    
    @MainActor
    func checkEmailDuplicate() async -> Bool{
        let url = "\(BASE_URL)/members/email/\(authField.email)@ajou.ac.kr/exists"
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default).serializingDecodable(Bool.self)
        
        let response = await request.response
//          email이 존재하면 true, 아니면 false 반환
        
        if response.response?.statusCode == 404 {
            print(response.debugDescription)
        }
        
        switch response.result {
        case .success(let value):
            print("[checkEmailDuplicate success]")
            print(value)
            
            if value {
                authField.emailDuplication = .duplicated
            } else {
                authField.emailDuplication = .notDuplicated
            }
            return value
        case .failure(let err):
            print("[checkEmailDuplicate err]")
            print(err)
            authField.emailDuplication = .duplicated
        }

        return true
    }
    
    //  MARK: post
    
    func requestEmailCode() {
        let url = "\(BASE_URL)/members/email/requestCode"
        let param: [String: Any] = [
            "email" : "\(authField.email)@ajou.ac.kr"
        ]
        
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).responseString { res in
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
    func signUp() async {
        
        let url = "\(BASE_URL)/signup"
        let param: [String: Any] = [
            "email" : "\(authField.email)@ajou.ac.kr",
            "password" : authField.password,
            "name" : authField.name,
            "phoneNumber" : "010\(authField.phoneNumber)",
            "studentId" : authField.studentId,
            "major" : authField.major,
            "verificationCode" : authField.code
        ]
        
        let task = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).serializingString()
        let response = await task.response
        authField.clearCode()
        
        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 200:
                print("[signUp status code \(statusCode)")
                isActiveSignUpSuccess = true
            default:
                isConfirmed = false
                print("[signUp unexpected result : \(statusCode)]")
                print(response.debugDescription)
            }
        }
    }
}
