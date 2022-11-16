//
//  CouponServiceTests.swift
//  Ren2UTests
//
//  Created by 노우영 on 2022/10/14.
//


import XCTest
@testable import Ren2U

class CouponServiceTests: XCTestCase {
    
    var couponService: CouponServiceProtocol?
    
    override func setUpWithError() throws {
        couponService = CouponService(url: ServerURL.devServer.url)
    }
    
    override func tearDownWithError() throws {
        
    }
}
