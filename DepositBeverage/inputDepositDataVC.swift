//
//  inputDepositDataVC.swift
//  DepositBeverage
//
//  Created by MacbookPro on 9/24/2559 BE.
//  Copyright © 2559 mintmint. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

class inputDepositDataVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var beverageImage = UIImageView()
    var customerName = UILabel()
    var depositTime = UILabel()
    var depositDate = UILabel()
    var depositButton = UIButton()
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var currentDate: String = ""
    var currentTime: String = ""
    
    var userData: JSON = []
    var videoPath: String = ""
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        
        let defaults = UserDefaults.standard
        if let profileInfo = defaults.object(forKey: "userLoginInfo") {
            self.userData = JSON(profileInfo)
        }
        
        //GET CURRENT DATE
        let todaysDate:NSDate = NSDate()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.currentDate = dateFormatter.string(from: todaysDate as Date)
        
        //GET CURRENT TIME
        dateFormatter.dateFormat = "HH:mm"
        self.currentTime = dateFormatter.string(from: todaysDate as Date)
        

        // Do any additional setup after loading the view.
        createView()
    }

    func createView() {
        
        self.view.backgroundColor = UIColor.white
        
        var topPosition: CGFloat = 75
        
        //Bevrage picture
        self.beverageImage.frame = CGRect(x: screenWidth/2-100, y: topPosition, width: 200, height: 200)
        self.beverageImage.image = UIImage(named: "selectImage")
        self.beverageImage.contentMode = .scaleAspectFit
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(inputDepositDataVC.imageTapped(sender:)))
        self.beverageImage.isUserInteractionEnabled = true
        self.beverageImage.addGestureRecognizer(tapGestureRecognizer)
        self.view.addSubview(self.beverageImage)
        
        //Customer name
        topPosition += 210
        self.customerName.frame = CGRect(x: 0, y: topPosition, width: screenWidth, height: 30)
        self.customerName.text = "Customer name"
        self.customerName.textAlignment = .center
        self.customerName.font = self.customerName.font.withSize(18)
        self.customerName.textColor = UIColor.black
        self.view.addSubview(self.customerName)
        
        if let userName = userData["name"].string {
            self.customerName.text = userName
        }
        
        //Deposit time
        topPosition += 40
        self.depositTime.frame = CGRect(x: 0, y: topPosition, width: screenWidth, height: 30)
        self.depositTime.text = "Deposit time: \(self.currentTime)"
        self.depositTime.textAlignment = .center
        self.depositTime.font = self.customerName.font.withSize(18)
        self.depositTime.textColor = UIColor.black
        self.view.addSubview(self.depositTime)
        
        //Deposit date
        topPosition += 40
        self.depositDate.frame = CGRect(x: 0, y: topPosition, width: screenWidth, height: 30)
        self.depositDate.text = "Deposit time: \(self.currentDate)"
        self.depositDate.textAlignment = .center
        self.depositDate.font = self.customerName.font.withSize(18)
        self.depositDate.textColor = UIColor.black
        self.view.addSubview(self.depositDate)
        
        //Deposit Button
        topPosition += 40
        self.depositButton.frame = CGRect(x: 20, y: topPosition, width: screenWidth-40, height: 40)
        self.depositButton.setTitle("Deposit", for: .normal)
        self.depositButton.addTarget(self, action: #selector(inputDepositDataVC.depositAction(sender:)), for: .touchUpInside)
        self.depositButton.tintColor = UIColor.white
        self.depositButton.layer.cornerRadius = 3
        self.depositButton.backgroundColor = UIColor(red: 255/255, green: 170/255, blue: 63/255, alpha: 1)
        self.view.addSubview(self.depositButton)
        
        self.activityView.center = self.view.center
        self.view.addSubview(activityView)
    }
    
    // MARK: - BUTTON ACTIONs
    func depositAction(sender: UIButton) {
        self.activityView.startAnimating() //start activity indecator
        self.view.isUserInteractionEnabled = false //Disable user touch
        
        print("Clcik on deposit button")
        let fileUrl = URL(fileURLWithPath: self.videoPath)
        
        let url:NSURL = NSURL(string: self.videoPath)!
        //Now use image to create into NSData format
        let imageData:NSData = NSData.init(contentsOf: url as URL)!
        let strBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)
        
        let param = [
            "userID": userData["userID"].string!,
            "shopID": "1",
            "tableID": "1",
            "image": "data:image/jpg;base64,\(strBase64)"
        ] as [String : Any]
        
        //make deposit request
        apiRequest().depositRequest(param as Dictionary<NSString, AnyObject>) { (result) in
            self.activityView.stopAnimating() //stop activity indecator
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true //Enable user touch
            }
            
            if result["response_status"].boolValue {
                //pop to previous view
                isScan = false
                QRCode = ""
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                print("Fail to deposit")
            }
        }
    }
    
    
    func imageTapped(sender: AnyObject) {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                imagePicker.cameraCaptureMode = .photo
                self.present(imagePicker, animated: true, completion: {})
            } else {
                //postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
            }
        }
    }
    
    // MARK: - TAKE PHOTO DELEGATE
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Got an image")
        if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
            self.beverageImage.image = pickedImage
            UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil)
            saveImageToDocuments(image: pickedImage, fileNameWithExtension: "test.jpg")
        }
        
        imagePicker.dismiss(animated: true, completion: {
            // Anything you want to happen when the user saves an image
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("User canceled image")
        dismiss(animated: true, completion: {
            // Anything you want to happen when the user selects cancel
        })
    }
    
    // MARK: - HTTP FUNCs
    func saveImageToDocuments(image: UIImage, fileNameWithExtension: String){
        let fileDirectory : NSURL  = {
            return try! FileManager.default.url(for: .documentDirectory , in: .userDomainMask , appropriateFor: nil, create: true)
        }() as NSURL
        let imagePath = fileDirectory.appendingPathComponent("\(fileNameWithExtension)")
        
        guard let imageData = UIImageJPEGRepresentation(image, 1) else {
            // handle failed conversion
            print("jpg error")
            return
        }
        do {
            try imageData.write(to: URL(string: "file://\(imagePath!.path)")!)
            self.videoPath = "file://\(imagePath!.path)"
        } catch let error as NSError {
            print("Failed writing to URL: \(imagePath!.path), Error: " + error.localizedDescription)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
