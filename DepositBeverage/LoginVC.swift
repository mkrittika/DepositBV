//
//  LoginVC.swift
//  SwiftLoginScreen
//
//  Created by MacbookPro on 8/16/2559 BE.
//  Copyright (c) 2014 Dipin Krishna. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    var response: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtPassword.isSecureTextEntry = true
        
        self.activityView.center = self.view.center
        self.view.addSubview(activityView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func signinTapped(_ sender : UIButton) {
        self.activityView.startAnimating() //start activity indecator
        self.view.isUserInteractionEnabled = false //Disable user touch
        
        let username:NSString = txtUsername.text! as NSString
        let password:NSString = txtPassword.text! as NSString
        
        print(username)
        print(password)
        
        if self.validateLogin(username, password: password) {
            
            let parameters = [
                "email": username,
                "password": password
            ]
            
            /*let storyboard = UIStoryboard(name: "Main", bundle: nil) //เอามาจาก story board ไหน
            let vc = storyboard.instantiateViewController(withIdentifier: "tabsWindow") as! UITabBarController //set ว่าให้ไปหน้าไหน
            self.present(vc, animated: true, completion: nil) //เปลี่ยนหน้า*/
            
            apiRequest().loginRequest(parameters as Dictionary<NSString, NSString>, completion: { (result) in
                DispatchQueue.main.async {
                    self.activityView.startAnimating() //start activity indecator
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
                    defaults.set(userData, forKey: "userLoginInfo") //เก็บข้อมูล username กับ password ของ customer ไว้ใน app
                    
                    DispatchQueue.main.async {
                        self.activityView.startAnimating() //start activity indecator
                        let storyboard = UIStoryboard(name: "Main", bundle: nil) //เอามาจาก story board ไหน
                        let vc = storyboard.instantiateViewController(withIdentifier: "tabsWindow") as! UITabBarController //set ว่าให้ไปหน้าไหน
                        self.present(vc, animated: true, completion: nil) //เปลี่ยนหน้า
                    }
                } else {
                    DispatchQueue.main.async {
                        self.activityView.startAnimating() //start activity indecator
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign in Failed!"
                        ///alertView.message = "Error: \(result["error_message"].string!)"
                        alertView.message = "Error, Please try angain"
                        alertView.delegate = self
                        alertView.addButton(withTitle: "OK")
                        alertView.show()
                    }
                    
                }
            })
        } else {
            DispatchQueue.main.async {
                self.activityView.stopAnimating() //stop activity indecator
                self.view.isUserInteractionEnabled = true //Enable user touch
            }
        }
    }
    
    func validateLogin(_ username: NSString, password: NSString) -> Bool {
        if ( username.isEqual(to: "") || password.isEqual(to: "") ) {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
            
            return false
        } else if utilityFuncs().isValidEmail(username as String) == false {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Username should be email format"
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
        } else {
            return true
        }
    }
    
    @IBAction func cancleTapped(_ sender: AnyObject) {
        print("")
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}
