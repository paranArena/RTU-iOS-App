//
//  ClubServiceTests.swift
//  Ren2UTests
//
//  Created by 노우영 on 2022/10/18.
//

import XCTest
@testable import Ren2U

class ClubServiceTests: XCTestCase {
    
    var memberService: MemberServiceEnable!
    var clubService: ClubServiceEnable!
    
    override func setUp() async throws {
        memberService = MemberService(url: ServerURL.devServer.url)
        clubService = ClubService(url: ServerURL.devServer.url)
        await login()
    }
    
    func testSearchClubsAll() {
        
        let expectation = XCTestExpectation()
        
        Task {
            let response = await clubService.searchClubsAll()
            if response.error != nil {
                XCTFail("searchClubsAll fail")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSearchClubsWithName() {
        
        let expectation = XCTestExpectation()
        
        Task {
            let response = await clubService.searchClubsWithName(groupName: "한터")
            for club in response.value!.data {
                if !club.name.contains("한터") {
                    XCTFail("searchClubsWithName fail")
                }
            }
            
            if response.error != nil {
                XCTFail("searchClubsWithName fail")
            }

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    func login() async {
        let correctParam = [
            "email": "ios1@ajou.ac.kr",
            "password": "qwerqwer"
        ]
        
        let response = await memberService.login(param: correctParam)
        if let value = response.value {
            clubService.bearerToken = value.token
        }
    }
}
