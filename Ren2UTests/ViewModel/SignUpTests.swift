//
//  SignUpTests.swift
//  Ren2UTests
//
//  Created by 노우영 on 2022/10/20.
//

import XCTest
@testable import Ren2U

final class SignUpTests: XCTestCase {
    
    var vm: SignUpViewModel!
    
    override func setUpWithError() throws {
        vm = SignUpViewModel(memberSevice: MemberService(url: ServerURL.devServer.url))
    }

    override func tearDownWithError() throws {
        vm = nil
    }

    func testCheckDuplicateButtonTapped() async {
        
        vm.param.email = "ios1"
        await vm.checkDulicateButtonTapped()
        
        var actual = vm.param.emailDuplication
        var expected = SignUpParam.EmailDuplication.duplicated
        XCTAssertEqual(actual, expected)
        
        vm.param.email = "doesntExistEmail"
        await vm.checkDulicateButtonTapped()
        
        actual = vm.param.emailDuplication
        expected = SignUpParam.EmailDuplication.notDuplicated
        XCTAssertEqual(actual, expected)
    }
    
    func testGoCertificationButtonTapped() async {
        
        XCTAssertFalse(vm.isDuplicatedStudentId)
        XCTAssertFalse(vm.isDuplicatedPhoneNumber)
        
        vm.param.phoneNumber = "00000013"
        vm.param.studentId = "201800013"
        await vm.goCertificationButtonTapped()
        
        XCTAssertTrue(vm.isDuplicatedPhoneNumber)
        XCTAssertTrue(vm.isDuplicatedStudentId)
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
