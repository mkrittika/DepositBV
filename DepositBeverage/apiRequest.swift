//
//  apiRequest.swift
//  SwiftLoginScreen
//
//  Created by MacbookPro on 8/18/2559 BE.
//  Copyright © 2559 Dipin Krishna. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftHTTP

class apiRequest {
    
    let mainURL = "http://www.arcadecarrent.com/mm/"
    
    //////////////////////////////////
    ////////// REGISTER API //////////
    //////////////////////////////////
    func registerRequest(_ param: Dictionary<NSString, NSString>, completion: @escaping (_ result: JSON) -> Void) {
        do {
            let opt = try HTTP.POST(mainURL+"api_user_register.php", parameters: param)
            opt.start { response in
                let toJSON = JSON(data: response.data)
                print(toJSON)
                completion(toJSON)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    ///////////////////////////////
    ////////// LOGIN API //////////
    ///////////////////////////////
    func loginRequest(_ param: Dictionary<NSString, NSString>, completion: @escaping (_ result: JSON) -> Void) {
        do {
            let opt = try HTTP.POST(mainURL+"api_user_login.php", parameters: param)
            opt.start { response in
                let toJSON = JSON(data: response.data)
                print(toJSON)
                completion(toJSON)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    ////////////////////////////////////
    ////////// UPDATE PROFILE //////////
    ////////////////////////////////////
    func updateProfileRequest(_ param: Dictionary<NSString, NSString>, completion: @escaping (_ result: JSON) -> Void) {
        do {
            let opt = try HTTP.POST(mainURL+"api_user_edit_profile.php", parameters: param)
            opt.start { response in
                let toJSON = JSON(data: response.data)
                print(toJSON)
                completion(toJSON)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    /////////////////////////////////////
    ////////// CHANGE PASSWORD //////////
    /////////////////////////////////////
    func changePasswordRequest(_ param: Dictionary<NSString, NSString>, completion: @escaping (_ result: JSON) -> Void) {
        do {
            let opt = try HTTP.POST(mainURL+"api_user_edit_password.php", parameters: param)
            opt.start { response in
                let toJSON = JSON(data: response.data)
                print(toJSON)
                completion(toJSON)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    //////////////////////////////////////
    ////////// DEPOSIT LIST API //////////
    //////////////////////////////////////
    func depositListRequest(_ param: Dictionary<NSString, NSString>, completion: @escaping (_ result: JSON) -> Void) {
        do {
            let opt = try HTTP.POST(mainURL+"api_stock_get_deposit_list.php", parameters: param)
            opt.start { response in
                let toJSON = JSON(data: response.data)
                print(toJSON)
                completion(toJSON)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    //////////////////////////////////
    ////////// WITHDRAW API //////////
    //////////////////////////////////
    func withdrawRequest(_ param: Dictionary<NSString, NSString>, completion: @escaping (_ result: JSON) -> Void) {
        do {
            let opt = try HTTP.POST(mainURL+"api_stock_withdraw.php", parameters: param)
            opt.start { response in
                let toJSON = JSON(data: response.data)
                print(toJSON)
                completion(toJSON)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    /////////////////////////////////
    ////////// DEPOSIT API //////////
    /////////////////////////////////
    func depositRequest(_ param: Dictionary<NSString, AnyObject>, completion: @escaping (_ result: JSON) -> Void) {
        do {
            let opt = try HTTP.POST(mainURL+"api_stock_deposit.php", parameters: param)
            opt.start { response in
                let toJSON = JSON(data: response.data)
                print(toJSON)
                completion(toJSON)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
}
