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
    
    @MainActor
    func testCompleteButtonTappedWhenClubNameIsEmpty() async {
        vm.clubProfileParam.introduction = "그룹 소개"
        await vm.completeButtonTapped { }
        
        let actual = vm.alertCase
        let expected = ClubProfileViewModel.AlertCase.lackOfInformation
        XCTAssertEqual(actual, expected)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
