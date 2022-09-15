//
//  Ren2UTests.swift
//  Ren2UTests
//
//  Created by 노우영 on 2022/07/12.
//

import XCTest
@testable import Ren2U

class Ren2UTests: XCTestCase {
    
    let loginViewModel = LoginViewModel()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        loginViewModel.account.email = "ios1@ajou.ac.kr"
        loginViewModel.account.password = "qwerqwer"
        
        print("setUpWithError is called!")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        print("tearDownWithError finish!")
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func test1() {
        let result = !loginViewModel.account.isDisable
        XCTAssertTrue(result)
    }
    
    func test2() {
        print("test2 is called")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
