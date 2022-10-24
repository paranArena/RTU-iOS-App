//
//  LoginTests.swift
//  Ren2UTests
//
//  Created by 노우영 on 2022/10/20.
//

import XCTest
@testable import Ren2U

final class LoginTests: XCTestCase {
    
    var vm: LoginViewModel!
    
    override func setUpWithError() throws {
        vm = LoginViewModel(memberService: MemberService(url: ServerURL.devServer.url))
    }

    override func tearDownWithError() throws {
        vm = nil 
    }

    func testButtonTapped() async {
        
        //  MARK: Check initial login state
        var actual = vm.missInput
        var expected = LoginViewModel.MissInput.default
        XCTAssertEqual(actual, expected)
        
        //  MARK: CORRET ACOOUNT
        vm.account.email = "ios1@ajou.ac.kr"
        vm.account.password = "qwerqwer"
        await vm.buttonTapped()
        actual = vm.missInput
        expected = LoginViewModel.MissInput.default
        XCTAssertEqual(actual, expected)
        
        //  MARK: WRONG ACCOUNT
        vm.account.email = "ios1@ajou.ac.kr"
        vm.account.password = "wrong password"
        await vm.buttonTapped()
        actual = vm.missInput
        expected = LoginViewModel.MissInput.wrong
        XCTAssertEqual(actual, expected)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
