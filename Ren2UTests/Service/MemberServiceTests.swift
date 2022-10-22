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
    
    override func setUp() async throws {
        memberService = MemberService(url: ServerURL.devServer.url)
        await login()
    }

    override func tearDownWithError() throws {
        logout()
    }

    func login() async {
        let correctParam = [
            "email": "ios1@ajou.ac.kr",
            "password": "qwerqwer"
        ]
        
        let response = await memberService.login(param: correctParam)
        if let value = response.value {
            memberService.bearerToken = value.token
        }
    }
    
    func logout() {
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
    
    func testRequestEmailCode() {
        let expectation = XCTestExpectation()
        Task {
            let response = await memberService.requestEmailCode(email: self.email)
            if response.error != nil {
                XCTFail("requestEmailCode fail")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}
