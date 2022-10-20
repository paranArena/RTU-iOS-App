//
//  SignUpViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/12.
//

import SwiftUI
import Alamofire

class SignUpViewModel: BaseViewModel {
    
    @Published var param = SignUpParam()
    
    //  MARK: NavitaionLink
    @Published var isActiveCertificationView = false
    
    //  MARK: ALERT
    @Published var isDulpicatedStudentId = false
    @Published var isDuplicatedPhoneNumber = false
    
    @Published var callbackAlert: CallbackAlert = CallbackAlert()
    @Published var oneButtonAlert: OneButtonAlert = OneButtonAlert()
    
    
    // MARK: For CertificationView
    let certificationNumLengthLimit = 6
    let time: Double = 5*60
    
    @Published var startTime = Date.now
    @Published var timeRemaining: Double = 5*60
    @Published var isConfirmed: Bool = true
    @Published var timer = Timer()
    @Published var isActiveSignUpSuccess: Bool = false
    
    let memberService: MemberServiceEnable
    
    init(memberSevice: MemberServiceEnable) {
        self.memberService = memberSevice
    }
    
    @MainActor
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError!.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
    
    @MainActor
    func showAlert() {
        
    }
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
        if self.param.code.count == self.certificationNumLengthLimit { UIApplication.shared.endEditing() }
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
        param.clearCode()
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
    
    @MainActor
    func checkPhoneStudentIdDuplicate() async {
        let url = "\(BASE_URL)/members/duplicate/010\(param.phoneNumber)/\(param.studentId)/exists"
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
    
    func emailTextChanged() {
        self.param.emailDuplication = .none
    }
    
    func goCertificationButtonTapped() async {
        let response = await memberService.checkPhoneStudentIdDuplicate(phoneNumber: self.param.phoneNumber, studentId: self.param.studentId)
        
        if let error = response.error {
            await self.showAlert(with: error)
        } else if let value = response.value {
            self.isDulpicatedStudentId = value.data.studentId
            self.isDuplicatedPhoneNumber = value.data.phoneNumber
            if !isDulpicatedStudentId && !isDulpicatedStudentId {
                isActiveCertificationView = true
                requestEmailCode()
            }
        }
    }
    
    func checkDulicateButtonTapped() async {
        let emailForCheck = "\(self.param.email)\(AJOU_EMAIL_SUFFIX)"
        let response = await memberService.checkEmailDuplicate(email: emailForCheck)
        
        if let error = response.error {
            await self.showAlert(with: error)
            param.emailDuplication = .none
        } else if let value = response.value {
            param.emailDuplication.setEmailDuplicate(result: value)
        }
    }
    
    func requestEmailCode() {
        let url = "\(BASE_URL)/members/email/requestCode"
        let param: [String: Any] = [
            "email" : "\(param.email)@ajou.ac.kr"
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
            "email" : "\(param.email)@ajou.ac.kr",
            "password" : param.password,
            "name" : param.name,
            "phoneNumber" : "010\(param.phoneNumber)",
            "studentId" : param.studentId,
            "major" : param.major,
            "verificationCode" : param.code
        ]
        
        let task = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).serializingString()
        let response = await task.response
        self.param.clearCode()
        
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
