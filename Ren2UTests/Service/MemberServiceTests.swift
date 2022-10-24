//
//  MemberServiceTests.swift
//  Ren2UTests
//
//  Created by 노우영 on 2022/10/14.
//

import XCTest
@testable import Ren2U

class MemberServiceTests: XCTestCase {
    
    var memberService: MemberServiceEnable!
    let email = "ios1@ajou.ac.kr"
    let tmpEmail = "nou0jid@ajou.ac.kr"
    let loginParam = LoginParam(email: "ios1@ajou.ac.kr", password: "qwerqwer")
    
    override func setUp() async throws {
        memberService = MemberService(url: ServerURL.devServer.url)
        await login(data: self.loginParam)
    }

    override func tearDownWithError() throws {
        logout()
    }

    private func login(data: LoginParam) async {
        
        let response = await memberService.login(data: data)
        if let value = response.value {
            memberService.bearerToken = value.token
        }
    }
    
    private func logout() {
        UserDefaults.standard.setValue(nil, forKey: JWT_KEY)
    }
    
    func testGetMyInfo() async {
        let expectation = XCTestExpectation()
        
        let response = await memberService.getMyInfo()
        if response.error != nil {
            XCTFail("getMyInfo fail")
        }
        
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetMyClubs() async {
        let expectation = XCTestExpectation()
        let response = await memberService.getMyClubs()
        if response.error != nil {
            XCTFail("getMyClubs fail")
        }
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetMyRentals() async {
        let expectation = XCTestExpectation()
        let response = await memberService.getMyRentals()
        if response.error != nil {
            XCTFail("getMyRentals fail")
        }
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetMyNotifications() async {
        let expectation = XCTestExpectation()
        let response = await memberService.getMyNotifications()
        if response.error != nil {
            XCTFail("getMyNotifications fail")
        }
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetMyProducts() {
        let expectation = XCTestExpectation()
        Task {
            let response = await memberService.getMyProducts()
            if response.error != nil {
                XCTFail("getMyProducts fail")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetMyCouponsAll() {
        let expectation = XCTestExpectation()
        Task {
            let response = await memberService.getMyCouponsAll()
            if response.error != nil {
                XCTFail("getMyCouponsAll fail")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetMyCouponHistoriesAll() {
        
        let expectation = XCTestExpectation()
        Task {
            let response = await memberService.getMyCouponHistoriesAll()
            if response.error != nil {
                XCTFail("getMyCouponHistories fail")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLogin() async {
        let expectation = XCTestExpectation()
        
        let correctParam = [
            "email": "ios1@ajou.ac.kr",
            "password": "qwerqwer"
        ]
        
        let passwordMissmatchParam = [
            "email": "ios1@ajou.ac.kr",
            "password": "asdfasdf"
        ]
        
        let emailDoesntExistParam = [
            "email": "ios",
            "password": "asdfasdf"
        ]
        
            
        var response = await memberService.login(param: passwordMissmatchParam)
        if response.error == nil {
            XCTFail("login fail : password missmatch case")
        }
        
        response = await memberService.login(param: emailDoesntExistParam)
        if response.error == nil {
            XCTFail("login fail : doesn`t exist email case")
        }
        
        response = await memberService.login(param: correctParam)
        if response.error != nil {
            XCTFail("login fail : correct case")
        } else {
            UserDefaults.standard.setValue(response.value!.token, forKey: JWT_KEY)
        }
        
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testCheckEmailDuplicate() async {
        let expectation = XCTestExpectation()
        let emails = ["ios1@ajou.ac.kr", "adszsda2da@ajou..ac.kr", "1234"]
        
        var response = await memberService.checkEmailDuplicate(email: emails[0])
        if !response.value! {
            print(response.debugDescription)
            XCTFail("fail")
        }
        
        response = await memberService.checkEmailDuplicate(email: emails[1])
        if response.value! {
            print(response.debugDescription)
            XCTFail("fail")
        }
        
        response = await memberService.checkEmailDuplicate(email: emails[2])
        if response.value! {
            XCTFail("fail")
        }
        
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testCheckPhoneStudentIdDuplicate() async {
        let expectation = XCTestExpectation()
        let response = await memberService.checkPhoneStudentIdDuplicate(phoneNumber: "01064330824", studentId: "201820767")
        if response.error != nil {
            XCTFail("testCheckPhoneStudentIdDuplicated Fail")
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 1)
    }
    
    func testRequestEmailCode() async {
        let expectation = XCTestExpectation()
        let response = await memberService.requestEmailCode(email: self.tmpEmail)
        if response.error != nil {
            XCTFail("requestEmailCode fail")
            print(response.debugDescription)
        }
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 4.0)
    }
    
    func testSignup() async {

        let signUpParam = SignUpParam(email: self.tmpEmail, password: "12345678", passwordCheck: "12345678", name: "iOS테스트", major: "소프트웨어학과", studentId: "201820768", phoneNumber: "01064330824", code: "111111")
        let expectation = XCTestExpectation()
        
        let _ = await self.testRequestEmailCode()
        let response = await memberService.signUp(data: signUpParam)
        
        if response.error != nil {
            XCTFail("testSignup fail")
            print(response.debugDescription)
        } else {
            //  회원탈퇴를 위해 방금 가입한 계정으로 로그인.
            let data = LoginParam(email: self.tmpEmail, password: "12345678")
            await self.login(data: data)
            await self.testQuitService()
        }

        expectation.fulfill()
        wait(for: [expectation], timeout: 1.0)
    }

    private func testQuitService () async {
        
        let expectation = XCTestExpectation()
        let response = await memberService.quitService()
        if response.error != nil {
            XCTFail("testQuitService fail")
        }
        
        expectation.fulfill()
        wait(for: [expectation], timeout: 1.0)
    }
}
