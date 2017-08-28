//
//  utillityFunctionTest.swift
//  DepositBeverage
//
//  Created by MacbookPro on 8/16/2559 BE.
//  Copyright © 2559 mintmint. All rights reserved.
//

import XCTest
import SwiftyJSON
import Alamofire
@testable import DepositBeverage

class utillityFunctionTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /////////////////////////////////////
    ////////// isValidateEmail //////////
    /////////////////////////////////////
    
    //Test with invalid email format
    func testInvalidEmail() {
        XCTAssertFalse(utilityFuncs().isValidEmail("testgmail.com"))
    }
    
    //Test with valid email format
    func testValidateEmail() {
        XCTAssertTrue(utilityFuncs().isValidEmail("test@gmail.com"))
    }
    
    ////////////////////////////////////////
    ////////// isValidatePassword //////////
    ////////////////////////////////////////
    func testInvalidPass() {
        XCTAssertFalse(utilityFuncs().isValidPass("test1234%$#+*&&"))
    }
    
    //Test with valid pass format
    func testValidatePass() {
        XCTAssertTrue(utilityFuncs().isValidPass("testpass1234"))
    }
    
    ////////////////////////////////////
    ////////// isValidatePass //////////
    ////////////////////////////////////
    //Test with invalid QR code format
    func testDepositBeverageWithInvalidQRcode() {
        let wrongQRCodeFormat = "1" //wrong format
        
        XCTAssertFalse(utilityFuncs().isValidQRCode(code: wrongQRCodeFormat), "This should return false")
    }
    
    //Test with valid QR code format
    func testDepositBeverageWithValidQRcode() {
        let wrongQRCodeFormat = "DB-1-1" //right format
        
        XCTAssertTrue(utilityFuncs().isValidQRCode(code: wrongQRCodeFormat), "This should return true")
    }
}
