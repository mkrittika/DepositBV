//
//  ProfileVC.swift
//  SwiftLoginScreen
//
//  Created by MacbookPro on 8/16/2559 BE.
//  Copyright © 2559 Dipin Krishna. All rights reserved.
//

import UIKit
import SwiftyJSON
//import SwiftHTTP

class ProfileVC: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*self.txtMobileNumber.keyboardType = .PhonePad
        self.currentPass.secureTextEntry = true
        self.newPass.secureTextEntry = true
        self.confirmPass.secureTextEntry = true
        
        */
        
        //self.nameLabel.text! = ""
        //self.mobileNumberLabel.text = ""
        self.editButton.layer.cornerRadius = 5
        self.logoutButton.layer.cornerRadius = 5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let customerProfile:JSON = getUserProfile() {
            self.usernameLabel.text = customerProfile["email"].string!
            self.nameLabel.text! = customerProfile["name"].string!
            self.mobileNumberLabel.text = customerProfile["mobile_number"].string!
        }
    }
    
    func getUserProfile() -> JSON {
        
        var getUserData = [String: String]()
        var username = ""
        var name = ""
        var mobileNumber = ""
        
        
        // GET SAVED USER PROFILE
        let defaults = UserDefaults.standard
        if let profileInfo = defaults.object(forKey: "userLoginInfo") {
            let userData = JSON(profileInfo)
            
            //self.nameLabel.text! = userData["name"].string!
            //self.mobileNumberLabel.text = userData["mobileNumber"].string!
            name = userData["name"].string!
            if let getPhone = userData["mobileNumber"].string {
                mobileNumber = getPhone
            }
        }
        
        // GET SAVED USERNAME AND DISPLAY
        if let loginInfo = defaults.object(forKey: "userLoginInfo") {
            let loginData = JSON(loginInfo)
            
            //self.usernameLabel.text = loginData["username"].string!
            username = loginData["email"].string!
            if let getPhone = loginData["mobileNumber"].string {
                mobileNumber = getPhone
            }
            
        }
        
        getUserData = [
            "email": username,
            "name": name,
            "mobile_number": mobileNumber
        ]
        
        
        return JSON(getUserData)
    }
    
    @IBAction func updateAction(_ sender: UIButton) {
        print("this will open update profile")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "editProfileWindow") as! EditProfileVC
        //self.presentViewController(nextViewController, animated:true, completion:nil)
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    @IBAction func logoutAction(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userLoginInfo")
        defaults.removeObject(forKey: "userProfileInfo")
        print("Logout")
        
        // เปิดหน้าอื่นขึ้นมาหลังจาล๊อคเอ้าท์
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "registerWindow")
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
