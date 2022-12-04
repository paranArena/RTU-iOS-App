//
//  ClubProfileVIewModelTests.swift
//  Ren2UTests
//
//  Created by 노우영 on 2022/10/31.
//

import XCTest
@testable import Ren2U

final class ClubProfileViewModelTests: XCTestCase {
    
    var vm: ClubProfileViewModel!

    override func setUpWithError() throws {
        vm = ClubProfileViewModel(clubService: ClubProfileService(url: ServerURL.devServer.url))
    }

    override func tearDownWithError() throws {
        vm = nil
    }

    func testHashtagEditEnded() {
        let tests = [
            "#아나바다 #Ren2U",
            "###     #태그파싱",
            "#소프트웨어학과 #미디어학과 #아주대    ##",
            "#아나바다#Ren2U #     ##아주대",
            "아나바다 태그파싱 Ren2U"
        ]
        
        let expectedOutputs = [
            ["아나바다", "Ren2U"],
            ["##", "태그파싱"],
            ["소프트웨어학과", "미디어학과", "아주대", "#"],
            ["아나바다#Ren2U", "#아주대"],
            []
        ]
        
        for i in tests.indices {
            vm.clubProfileParam.hashtagText = tests[i]
            vm.hashtagEditEnded()
            
            let actual = vm.clubProfileParam.hashtags
            let expected = expectedOutputs[i]
            XCTAssertEqual(actual, expected)
            
            let actualText = vm.clubProfileParam.hashtagText
            let expectedText = ""
            XCTAssertEqual(actualText, expectedText)
            
            vm.clubProfileParam = ClubProfileParam()
        }
    }
    
    func testXmarkTapped() {
        let input = ["소프트웨어학과", "미디어학과", "아주대", "#"]
        let expected = ["소프트웨어학과", "아주대", "#"]
        
        vm.clubProfileParam.hashtags = input
        vm.xmarkTapped(index: 1)
        
        let actual: [String] = vm.clubProfileParam.hashtags
        XCTAssertEqual(actual, expected)
    }
    
    @MainActor
    func testCompleteButtonTappedWhenClubNameIsEmpty() async {
        vm.clubProfileParam.introduction = "그룹 소개"
        await vm.completeButtonTapped()
        
        if let actual = vm.alertCase?.alertID {
            let expected = ClubProfileViewModel.AlertCase.lackOfInformation.alertID
            XCTAssertEqual(actual, expected)
        } else {
            XCTAssert(true)
        }
    }
    
    @MainActor
    func testCompleteButtonTappedWhenCreatable() async {
        vm.clubProfileParam.name = "그룹명"
        vm.clubProfileParam.introduction = "그룹 소개"
        await vm.completeButtonTapped()
        
        if let actual = vm.alertCase?.alertID {
            let expected = ClubProfileViewModel.AlertCase.postClub(MockupClubProfileService(), ClubProfileParam()) { _ in }.alertID
            XCTAssertEqual(actual , expected)
        } else {
            XCTAssert(true)
        }
    }
    
    func testFocusFieldChangedWhenNameFieldFocused() {
        vm.focusFieldChanged(focusedField: .name)
        let actual: Bool = vm.isShowingTagPlaceholder
        let expected: Bool = true
        XCTAssertEqual(actual, expected)
    }
    
    func testFocusFieldChangedWhenTagFieldFocused() {
        vm.focusFieldChanged(focusedField: .tag)
        let actual: Bool = vm.isShowingTagPlaceholder
        let expected: Bool = false
        XCTAssertEqual(actual, expected)
    }
}
