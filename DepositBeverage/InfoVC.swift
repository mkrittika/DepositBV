//
//  InfoVC.swift
//  SwiftLoginScreen
//
//  Created by MacbookPro on 8/16/2559 BE.
//  Copyright © 2559 Dipin Krishna. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toucan

class InfoVC: UIViewController {
    
    var bottleHolderView = UIView()
    var bottleID = UILabel()
    var bottleVolume = UIView()
    var bottleImage = UIImageView()
    var volumeLabel = UILabel()
    
    var customerName = UILabel()
    var productName = UILabel()
    var staffName = UILabel()
    var depositDate = UILabel()
    var expireDate = UILabel()
    var descriptionLabel = UILabel()
    var withdrawButton = UIButton()
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var userData: JSON = []
    var selectIndex: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if let profileInfo = defaults.object(forKey: "userLoginInfo") {
            self.userData = JSON(profileInfo)
        }
        
        print("selected index")
        print(selectIndex)
        
        
        self.createBottleView()
        self.createDepositInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isScan && QRCode != "" {
            
            self.activityView.startAnimating() //start activity indecator
            self.view.isUserInteractionEnabled = false //Disable user touch
            self.withdrawButton.isUserInteractionEnabled = false
            self.withdrawButton.isHidden = true
            
            let param = [
                "userID": self.userData["userID"].string!,
                "depositID": self.selectIndex["depositID"].string!
            ]
            
            apiRequest().withdrawRequest(param as Dictionary<NSString, NSString>, completion: { (result) in
                DispatchQueue.main.async {
                    self.view.isUserInteractionEnabled = true //Enable user touch
                }
                
                if result["response_status"].boolValue {
                    DispatchQueue.main.async {
                        self.withdrawButton.isUserInteractionEnabled = true
                        self.activityView.stopAnimating() //stop activity indecator
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Successful"
                        alertView.message = result["response_message"].string!
                        alertView.delegate = self
                        alertView.addButton(withTitle: "OK")
                        alertView.show()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.withdrawButton.isUserInteractionEnabled = true
                        self.activityView.stopAnimating() //stop activity indecator
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Failed to withdraw"
                        alertView.message = "\(result["response_message"].string!), Please try again later"
                        alertView.delegate = self
                        alertView.addButton(withTitle: "OK")
                        alertView.show()
                    }
                }
            })
            
            isScan = false
            QRCode = ""
        }
    }
    
    func createBottleView() {
        
        //Volume
        self.bottleHolderView.frame = CGRect(x: 0, y: 90, width: 100, height: 100)
        self.view.addSubview(self.bottleHolderView)
        
        let volumeHeight: CGFloat = (CGFloat(arc4random_uniform(90) + 20)*self.bottleHolderView.frame.size.height)/100
        print(volumeHeight)
        self.bottleVolume.frame = CGRect(x: 0, y: volumeHeight, width: 100, height: 100-volumeHeight)
        self.bottleVolume.backgroundColor = UIColor(red: 255/255, green: 170/255, blue: 63/255, alpha: 1)
        //self.bottleHolderView.addSubview(self.bottleVolume)
        
        //Volume label
        self.volumeLabel.frame = CGRect(x: 0, y: 210, width: 100, height: 30)
        self.volumeLabel.textAlignment = .center
        self.volumeLabel.text = "Vol. \(100-volumeHeight)"
        self.volumeLabel.font = self.volumeLabel.font.withSize(14)
        //self.view.addSubview(self.volumeLabel)
        
        self.bottleImage.frame = CGRect(x: 10, y: 0, width: 100, height: 100)
        self.bottleImage.contentMode = .scaleAspectFill
        self.bottleImage.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(M_PI)) / 360.0)
        self.bottleHolderView.addSubview(self.bottleImage)
        
        DispatchQueue.global(qos: .background).async {
            if let imageStringURL = self.selectIndex["image"].string {
                let url = URL(string: imageStringURL)
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.bottleImage.contentMode = .scaleAspectFit
                    self.bottleImage.image = Toucan(image: UIImage(data: data!)!).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.crop).image
                }
            } else {
                DispatchQueue.main.async {
                    self.bottleImage.contentMode = .scaleAspectFit
                    self.bottleImage.image = Toucan(image: UIImage(named: "logo2")!).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.crop).image
                }
            }
        }
        
        //Product ID label
        self.bottleID.frame = CGRect(x: 10, y: 215, width: 100, height: 30)
        self.bottleID.textAlignment = .center
        self.bottleID.text = "ID: \(self.selectIndex["depositID"].string!)"
        self.bottleID.font = self.volumeLabel.font.withSize(14)
        self.view.addSubview(self.bottleID)
    }
    
    func createDepositInfo() {
        var topPosition: CGFloat = 80
        //Customer name
        self.customerName.frame = CGRect(x: 120, y: topPosition, width: screenWidth-130, height: 30)
        self.customerName.textAlignment = .left
        self.customerName.text = self.userData["name"].string!
        self.customerName.font = self.customerName.font.withSize(16)
        self.view.addSubview(self.customerName)
        
        //Product name
        //topPosition += 30
        self.productName.frame = CGRect(x: 120, y: topPosition, width: screenWidth-130, height: 30)
        self.productName.textAlignment = .left
        if let produnctStringName = self.selectIndex["tableID"].string {
            self.productName.text = produnctStringName
        } else {
            self.productName.text = "item"
        }
        self.productName.font = self.productName.font.withSize(16)
        //self.view.addSubview(self.productName)
        
        //Staff name
        topPosition += 30
        /*self.staffName.frame = CGRect(x: 120, y: topPosition, width: screenWidth-130, height: 30)
         self.staffName.textAlignment = .left
         self.staffName.text = self.selectIndex["shop"]["name"].string!
         self.staffName.font = self.staffName.font.withSize(16)
         self.view.addSubview(self.staffName)*/
        
        //Deposit date
        topPosition += 30
        self.depositDate.frame = CGRect(x: 120, y: topPosition, width: screenWidth-130, height: 30)
        self.depositDate.textAlignment = .left
        self.depositDate.text = "Deposit date: "
        if let depositDate = self.selectIndex["date"].string {
            self.depositDate.text = "Deposit date: \(depositDate)"
        }
        
        self.depositDate.font = self.depositDate.font.withSize(16)
        self.view.addSubview(self.depositDate)
        
        //Expire date
        topPosition += 30
        self.expireDate.frame = CGRect(x: 120, y: topPosition, width: screenWidth-130, height: 30)
        self.expireDate.textAlignment = .left
        //self.expireDate.text = "Expire date: \(self.selectIndex["expiredDate"].string!)"
        self.expireDate.text = "Expire date: "
        if let expireDate = self.selectIndex["expiredDate"].string {
            self.expireDate.text = "Expire date: \(expireDate)"
        }
        self.expireDate.font = self.expireDate.font.withSize(16)
        self.view.addSubview(self.expireDate)
        
        let testText = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus."
        let textHeight = heightForView(testText , font: UIFont(name: "Helvetica", size: 16)!, width: screenWidth-20)
        self.descriptionLabel.frame = CGRect(x: 10, y: 245, width: screenWidth-20, height: textHeight)
        self.descriptionLabel.textAlignment = .left
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.text = testText
        self.descriptionLabel.font = self.descriptionLabel.font.withSize(14)
        //self.view.addSubview(self.descriptionLabel)
        
        self.withdrawButton.frame = CGRect(x: 10, y: 250, width: screenWidth-20, height: 35)
        self.withdrawButton.setTitle("Withdraw", for: UIControlState())
        self.withdrawButton.backgroundColor = UIColor(red: 255/255, green: 170/255, blue: 63/255, alpha: 1)
        self.withdrawButton.tintColor = UIColor.white
        self.withdrawButton.layer.cornerRadius = 3
        self.withdrawButton.addTarget(self, action: #selector(InfoVC.withdrawAction(_:)), for: .touchUpInside)
        self.view.addSubview(self.withdrawButton)
        if let produnctStatus = self.selectIndex["status"].string {
            if produnctStatus == "pending" {
                self.withdrawButton.isHidden = true
            }
        }
        
        self.activityView.center = self.view.center
        self.view.addSubview(activityView)
    }
    
    func withdrawAction(_ sender: UIButton) {
        print("click on withdraw")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "barcodeWindow") as! QRcodeController
        secondViewController.scanType = "withdraw"
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
