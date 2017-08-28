//
//  DepositBeverageTests.swift
//  DepositBeverageTests
//
//  Created by MacbookPro on 8/16/2559 BE.
//  Copyright © 2559 mintmint. All rights reserved.
//

import XCTest
import SwiftyJSON
import SwiftHTTP
@testable import DepositBeverage
//@testable import DepositBeverage

class DepositBeverageTests: XCTestCase {
    
    let urlString = "http://www.arcadecarrent.com/mm/"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - REGISTER TEST CASE
    func testRegisterInvalidName() {
        //This will invalid name more than 20 charactor
        let vc = RegisterVC()
        
        let validateReturn = vc.validateInputData("test@gmail.com", name: "ttttttttttttttttttttttt", mobile_number: "0123456789", password: "testpass", confirm_password: "testpass")
        
        XCTAssertFalse(validateReturn)
    }
    
    func testRegisterInvalidUsername() {
        //This will invalid name more than 20 charactor
        let vc = RegisterVC()
        let validateReturn = vc.validateInputData("test", name: "test", mobile_number: "0123456789", password: "testpass", confirm_password: "testpass")
        
        XCTAssertFalse(validateReturn) //this should return false
    }
    
    func testRegisterWithValidData() { //This will fail
        let expectation = self.expectation(description: "testRegisterWithValidData")
        let param = [
            "email": "test102@gmail.com",
            "password": "012345678",
            "name": "test name1",
            "mobileNumber": "0123456789"
        ]
        
        // When
        do {
            let opt = try HTTP.POST(urlString, parameters: param)
            opt.start { response in
                if response.error != nil {
                    XCTAssert(false, "Failure")
                }
                
                let testData: JSON = JSON(data: response.data)
                XCTAssert(testData["response_data"]["email"].string! == "test102@gmail.com", "should return email")
                XCTAssert(testData["response_data"]["name"].string! == "test name1", "should return name")
                XCTAssert(testData["response_data"]["mobileNumber"].string! == "0123456789", "should return name")
                expectation.fulfill()
            }
        } catch {
            XCTAssert(false, "Failure")
        }
        
        waitForExpectations(timeout: 30, handler: nil)
        
    }
    
    func testRegisterWithExistUsername() { //
        let expectation = self.expectation(description: "testRegisterWithExistUsername")
        let param = [
            "email": "test102@gmail.com",
            "password": "012345678",
            "name": "test name1",
            "mobileNumber": "012345678"
        ]
        
        // When
        do {
            let opt = try HTTP.POST(urlString, parameters: param)
            opt.start { response in
                if response.error != nil {
                    XCTAssert(false, "Failure")
                }
                
                let testData: JSON = JSON(data: response.data)
                XCTAssert(testData["response_message"].string! == "email already exists", "Fail to register")
                expectation.fulfill()
            }
        } catch {
            XCTAssert(false, "Failure")
        }
        
        waitForExpectations(timeout: 30, handler: nil)
        
    }
    
    // MARK: - LOGIN TEST CASE
    func testLoginWithInvalidUsername() { // INVALID USERNAME FORMAT
        let loginVC = LoginVC()
        let validateResult = loginVC.validateLogin("test", password: "testtest")
        
        XCTAssertFalse(validateResult)
    }
    
    func testLoginWithInvalidPassword() { // INVALID PASSWORD
        let expectation = self.expectation(description: "testLoginWithInvalidPassword")
        
        let param = [
            "email": "test1@gmail.com",
            "password": "testtest1"
        ]
        
        // When
        do {
            let opt = try HTTP.POST(urlString, parameters: param)
            opt.start { response in
                if response.error != nil {
                    XCTAssert(false, "Failure")
                }
                
                let testData: JSON = JSON(data: response.data)
                XCTAssert(testData["response_message"].string! == "login credential not match", "Fail to login")
                expectation.fulfill()
            }
        } catch {
            XCTAssert(false, "Failure")
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testLoginWithValidData() { // VALID LOGIN DATA
        let expectation = self.expectation(description: "testLoginWithValidData")
        
        let param = [
            "email": "test1@gmail.com",
            "password": "testtest"
        ]
        
        // When
        do {
            let opt = try HTTP.POST(urlString, parameters: param)
            opt.start { response in
                if response.error != nil {
                    XCTAssert(false, "Failure")
                }
                
                let testData: JSON = JSON(data: response.data)
                print(testData)
                XCTAssert(testData["response_data"]["email"].string! == "test1@gmail.com", "should return email")
                XCTAssert(testData["response_data"]["name"].string! == "name1", "should return name")
                XCTAssert(testData["response_data"]["mobileNumber"].string! == "0123456789", "should return name")
                expectation.fulfill()
            }
        } catch {
            XCTAssert(false, "Failure")
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    // MARK: - VIEW CUSTOMER PROFILE
    func testLoadProfileView() {
        let profileVC = ProfileVC()
        
        XCTAssertNotNil(profileVC.view, "Load profile view")
    }
    
    // MARK: - UPDATE CUSTOMER PROFILE
    func testLoadEditProfileView() {
        let editProfileVC = EditProfileVC()
        
        XCTAssertNotNil(editProfileVC.view, "Load edit profile view")
    }
    
    func testWithValidData() {
        let editProfileVC = EditProfileVC()
        let validData = editProfileVC.validateProfile("test name", mobile_number: "0123456789")
        
        XCTAssertTrue(validData)
    }
    
    func testWithInvalidName() {
        let editProfileVC = EditProfileVC()
        let invalidName = editProfileVC.validateProfile("tttttttttttttttttttttttttt", mobile_number: "0123456789")
        
        XCTAssertFalse(invalidName)
    }
    
    func testWidthInvalidMobile() {
        let editProfileVC = EditProfileVC()
        let invalidMobileNumber = editProfileVC.validateProfile("tttttttttt", mobile_number: "01234567890")
        
        XCTAssertFalse(invalidMobileNumber)
    }
    
    func testEditProfile() {
        let expectation = self.expectation(description: "testEditProfile")
        
        let param = [
            "userID": "1",
            "name": "edit name",
            "mobileNumber": "1234567890",
            "password": "testtest"
        ]
        
        // When
        do {
            let opt = try HTTP.POST(urlString, parameters: param)
            opt.start { response in
                if response.error != nil {
                    XCTAssert(false, "Failure")
                }
                
                let testData: JSON = JSON(data: response.data)
                print(testData)
                XCTAssert(testData["response_message"].string! == "success", "should return successful")
                expectation.fulfill()
            }
        } catch {
            XCTAssert(false, "Failure")
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
}
