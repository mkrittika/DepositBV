//
//  WithdrawVCTests.swift
//  DepositBeverage
//
//  Created by MacbookPro on 9/27/2559 BE.
//  Copyright © 2559 mintmint. All rights reserved.
//

import XCTest
import SwiftyJSON
import SwiftHTTP
@testable import DepositBeverage

class WithdrawVCTests: XCTestCase {
    
    let urlString = "http://goldhillsidegym.com/mint/api/json/main.php?apikey=3068ee6b8cf692f1b8226bbd177bd9c5&code=vulcv"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWithdrawBeverage() {
        let expectation = self.expectation(description: "Request should succeed")
        
        let param = [
            "userID": "1",
            "depositID": "1",
            "shopID": "1",
            "tableID": "1"
        ]
        
        // When
        apiRequest().withdrawRequest(param as Dictionary<NSString, NSString>) { (result) in
            //let testData: JSON = JSON(data: result.data)
            print(result)
            XCTAssert(result["response_status"].boolValue == true, "should return true")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    /*func testWithdrawBeverageFail() {
        let urlString = ""
        let expectation = self.expectation(description: "withdraw request should sent to server")
        
        var response: DataResponse<Any>?
        
        Alamofire.request(urlString).responseJSON { resp in
            response = resp
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
        let testData: JSON = JSON(data: response!.data!)
        XCTAssert(testData["message"].string! == "invalid password", "should return failed message")
    }*/
}
