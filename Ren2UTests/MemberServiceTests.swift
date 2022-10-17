//
//  MemberServiceTests.swift
//  Ren2UTests
//
//  Created by 노우영 on 2022/10/14.
//

import XCTest
@testable import Ren2U

class MemberServiceTests: XCTestCase {
    
    var memberService: MemberServiceProtocol!
    
    override func setUpWithError() throws {
        memberService = MemberService(url: ServerURL.devServer.url)
        print("Generated Token : \(memberService.bearerToken)")
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testLogin() {
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
        
        Task {
            
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
                print(response.debugDescription)
                XCTFail("login fail : correct case")
            } else {
                print("token : \(response.value!.token)")
                UserDefaults.standard.setValue(response.value!.token, forKey: JWT_KEY)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetMyInfo() {
        let expectation = XCTestExpectation()
        
        Task {
            let response = await memberService.getMyInfo()
            
            if response.error != nil {
                XCTFail("getMyInfo fail")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetMyClubs() {
        let expectation = XCTestExpectation()
        Task {
            let response = await memberService.getMyClubs()
            if response.error != nil {
                XCTFail("getMyClubs fail")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetMyRentals() {
        let expectation = XCTestExpectation()
        Task {
            let response = await memberService.getMyRentals()
            if response.error != nil {
                XCTFail("getMyRentals fail")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetMyNotifications() {
        let expectation = XCTestExpectation()
        Task {
            let response = await memberService.getMyNotifications()
            if response.error != nil {
                XCTFail("getMyNotifications fail")
            }
            expectation.fulfill()
        }
        
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
}
