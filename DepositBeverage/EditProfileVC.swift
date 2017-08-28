//
//  EditProfileVC.swift
//  SwiftLoginScreen
//
//  Created by MacbookPro on 8/18/2559 BE.
//  Copyright © 2559 Dipin Krishna. All rights reserved.
//

import UIKit
import SwiftyJSON
//import SwiftHTTP

class EditProfileVC: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var txtCurrentPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var changePassButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        /*self.txtMobileNumber.keyboardType = .PhonePad
        self.currentPass.secureTextEntry = true
        self.newPass.secureTextEntry = true
        self.confirmPass.secureTextEntry = true*/
        
        let defaults = UserDefaults.standard
        if let profileInfo = defaults.object(forKey: "userLoginInfo") {
            let userData = JSON(profileInfo)
            print(userData)
            
            self.txtName.text = userData["name"].string!
            self.txtMobileNumber.text = userData["mobileNumber"].string!
        }
        
        self.updateButton.layer.cornerRadius = 5
        self.changePassButton.layer.cornerRadius = 5
    }

    @IBAction func updateAction(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        if let profileInfo = defaults.object(forKey: "userLoginInfo") {
            let getUserData = JSON(profileInfo)
            
            let parameters = [
                "userID": getUserData["userID"].string!,
                "newName": self.txtName.text!,
                "newMobileNumber": self.txtMobileNumber.text!,
                //"password": getUserData["password"].string!
            ]
            
            apiRequest().updateProfileRequest(parameters as Dictionary<NSString, NSString>) { (reps) in
                if reps["response_status"].boolValue {
                    let userData = [
                        "userID": getUserData["userID"].string!,
                        "name": self.txtName.text!,
                        "email": getUserData["email"].string!,
                        "mobileNumber": self.txtMobileNumber.text!
                        //"password": self.txtNewPass.text!
                    ]
                    defaults.set(userData, forKey: "userLoginInfo") //save user login data
                    
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func changePassAction(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        
        if self.txtCurrentPass.text != "" {
            print("current password is required")
        } else if self.txtNewPass.text != "" {
            print("current new password is required")
        } else if self.txtConfirmPass.text != "" {
            print("current confirm password is required")
        } else if self.txtCurrentPass.text == self.txtNewPass.text {
            print("Your current password and new password are the same")
        } else if self.txtNewPass.text != self.txtConfirmPass.text {
            print("Your new password and confirm password are not matches")
        } else {
            if let profileInfo = defaults.object(forKey: "userLoginInfo") {
                let getUserData = JSON(profileInfo)
                
                let parameters = [
                    "userID": getUserData["userID"].string!,
                    "oldPassword": self.txtCurrentPass.text!,
                    "newPassword": self.txtNewPass.text!
                ]
                
                apiRequest().changePasswordRequest(parameters as Dictionary<NSString, NSString>) { (reps) in
                    if reps["response_status"].boolValue {
                        let userData = [
                            "userID": getUserData["userID"].string!,
                            "name": getUserData["name"].string!,
                            "email": getUserData["email"].string!,
                            "mobileNumber": getUserData["mobileNumber"].string!,
                            "password": self.txtNewPass.text!
                        ]
                        defaults.set(userData, forKey: "userLoginInfo") //save user login data
                        
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        
                    }
                }
            }
        }
    }
    
    // MARK: - FUNCTIONs
    func validateProfile(_ name: String, mobile_number: String) -> Bool {
        if name.characters.count > 20  {
            
            return false
        } else if mobile_number.characters.count != 10 {
            
            return false
        } else {
            return true
        }
    }
    
    func validatePass(_ currentPass: String, newPass: String, confirmNewPass: String) -> Bool {
        if currentPass == "" {
            
            return false
        } else if newPass == "" {
            
            return false
        } else if confirmNewPass == "" {
            
            return false
        } else if newPass != confirmNewPass {
            
            return false
        } else {
            
            return true
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
}
