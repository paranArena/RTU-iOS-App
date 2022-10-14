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
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testLogin() {
        let expectation = XCTestExpectation()
        
        let correctParam = [
            "email": "ios1@ajou.ac.kr",
            "password": "qwerqwer"
        ]
        
        let wrongParam1 = [
            "email": "ios1@ajou.ac.kr",
            "password": "asdfasdf"
        ]
        
        let wrongParam2 = [
            "email": "ios",
            "password": "asdfasdf"
        ]
        
        Task {
            var response = await memberService.login(param: correctParam)
            if response.error != nil {
                print(response.debugDescription)
                XCTFail("login fail")
            }
            
            response = await memberService.login(param: wrongParam1)
            if response.error == nil {
                XCTFail("login fail")
            }
            
            response = await memberService.login(param: wrongParam2)
            if response.error == nil {
                XCTFail("login fail")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
