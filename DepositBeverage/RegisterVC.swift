//
//  SignupVC.swift
//  SwiftLoginScreen
//
//  Created by MacbookPro on 8/16/2559 BE.
//  Copyright (c) 2014 Dipin Krishna. All rights reserved.
//

import UIKit
import SwiftyJSON

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var response: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtUsername.delegate = self
        txtName.delegate = self
        txtMobileNumber.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
        
        self.registerButton.layer.cornerRadius = 5
        
        
        self.activityView.center = self.view.center
        self.view.addSubview(activityView)
        
    }
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func registerTapped(_ sender : UIButton) {
        self.activityView.startAnimating() //start activity indecator
        self.view.isUserInteractionEnabled = false //Disable user touch
        
        
        let username:NSString = txtUsername.text! as NSString
        let name:NSString = txtName.text! as NSString
        let mobile_number:NSString = txtMobileNumber.text! as NSString
        let password:NSString = txtPassword.text! as NSString
        let confirm_password:NSString = txtConfirmPassword.text! as NSString
        
        if validateInputData(username, name: name, mobile_number: mobile_number, password: password, confirm_password: confirm_password) {
            
            print(username)
            print(password)
            
            let parameters = [
                "email": username, //email
                "password": password, //password
                "name": name,
                "mobileNumber": mobile_number
            ]
            
            apiRequest().registerRequest(parameters as Dictionary<NSString, NSString>, completion: { (result) in
                DispatchQueue.main.async {
                    self.activityView.stopAnimating()
                    self.view.isUserInteractionEnabled = true //Enable user touch
                }
                
                if result["response_status"].boolValue {
                    let defaults = UserDefaults.standard
                    let userData = [
                        "userID": result["response_data"]["userID"].string!,
                        "name": result["response_data"]["name"].string!,
                        "email": username,
                        "mobileNumber": result["response_data"]["mobileNumber"].string!,
                        "password": password
                    ] as [String : Any]
                    defaults.set(userData, forKey: "userLoginInfo") //save user login data
                    
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "loginWindow") as! LoginVC
                        self.present(vc, animated: true, completion: nil)
                    }
                } else {
                    if let errorMessage = result["response_message"].string {
                        let alertView = UIAlertView()
                        alertView.title = "Register Failed!"
                        alertView.message = "Error: \(errorMessage)"
                        alertView.delegate = self
                        alertView.addButton(withTitle: "OK")
                        DispatchQueue.main.async {
                            alertView.show()
                        }
                        
                    }
                }
            })
        } else {
            self.activityView.stopAnimating()
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true //Enable user touch
            }
        }
    }
    
    func validateInputData(_ username: NSString, name: NSString, mobile_number: NSString, password: NSString, confirm_password: NSString) -> Bool {
        
        print(utilityFuncs().isValidEmail(username as String))
        print(utilityFuncs().isValidPass(password as String))
        
        if ( username.isEqual(to: "") || password.isEqual(to: "") ) {
            
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Register Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
            
            return false
        } else if ( name.isEqual(to: "") ) {
            
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Register Failed!"
            alertView.message = "Please enter name"
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
            
            return false
        } else if ( mobile_number.isEqual(to: "") ) {
            
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Register Failed!"
            alertView.message = "Please enter mobile number"
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
            
            return false
        } else if name.length > 20 {
            
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Register Failed!"
            alertView.message = "Name should less than 20 charactors"
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
            
            return false
        } else if password.length < 8 || password.length > 16 {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Register Failed!"
            alertView.message = "Password input between 8 to 16 charactors"
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
            
            return false
        } else if utilityFuncs().isValidEmail(username as String) == false {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Register Failed!"
            alertView.message = "Invalid username should be email format"
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
            
            return false
        } else if ( !password.isEqual(confirm_password) ) {
            
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Register Failed!"
            alertView.message = "Passwords doesn't Match"
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
            
            return false
        }  else {
            return true
        }
    }

    @IBAction func loginTapped(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginWindow")
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        print("this is test")
    }
    
    ////////// TESTING METHODs //////////
    func setUpVar(_ username: String!, name: String, mobileNumber: String, pass: String, confirmPass: String) {
        print(username)
        print(name)
        print(mobileNumber)
        print(pass)
        print(confirmPass)
        
        self.txtUsername.text = username
        self.txtName.text = name
        self.txtMobileNumber.text = mobileNumber
        self.txtPassword.text = pass
        self.txtConfirmPassword.text = confirmPass
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}
