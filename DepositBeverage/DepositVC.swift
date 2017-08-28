//
//  DepositVC.swift
//  DepositBeverage
//
//  Created by MacbookPro on 8/16/2559 BE.
//  Copyright © 2559 mintmint. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toucan

class DepositVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var refreshControl = UIRefreshControl()
    var tableView = UITableView()
    var userData: JSON = []
    var depositList: JSON = []
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    var selectIndex = 0
    //let itmeExp = ["15/09/2016", "20/09/2016", "24/09/2016", "28/09/2016"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let defaults = UserDefaults.standard
        if let profileInfo = defaults.object(forKey: "userLoginInfo") {
            self.userData = JSON(profileInfo)
        }
        
        self.activityView.center = self.view.center
        self.view.addSubview(activityView)
        
        self.createView()
        self.getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //check QR code is scan?
        if isScan && QRCode != "" {
            //this will go to input deposit data
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "inputDepositDataWindow") as! inputDepositDataVC
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
            isScan = false
            QRCode = ""
        }
        
        self.getData()
    }
    
    func createView() {
        self.tableView.frame = CGRect(x: 0, y: 65, width: screenWidth, height: screenHeight-115)
        self.view.addSubview(self.tableView)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        self.getData()
    }
    
    func getData() {
        self.activityView.startAnimating() //start activity indecator
        self.view.isUserInteractionEnabled = false //Disable user touch
        
        let param = [
            "userID": self.userData["userID"].string!
        ]
        
        apiRequest().depositListRequest(param as Dictionary<NSString, NSString>) { (result) in
            self.activityView.stopAnimating() //stop activity indecator
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true //Enable user touch
            }
            
            if result["response_data"] != nil {
                self.depositList = result["response_data"]
                
                DispatchQueue.main.async {
                    //Add notification
                    for index in 0...self.depositList.count {
                        print(index)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        dateFormatter.timeZone = NSTimeZone.local
                        if let getDate = self.depositList[index]["expiredDate"].string {
                            if let date = dateFormatter.date(from: getDate) {
                                utilityFuncs().createNotification(notiDate: date)
                            }
                        }
                        
                    }
                    let date = Date()
                    utilityFuncs().createNotification(notiDate: date)
                    
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - TABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.depositList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.register(UINib(nibName: "placeTableViewCell", bundle: nil), forCellReuseIdentifier: "placeCell")
        let cell: placeTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "placeCell") as! placeTableViewCell
        
        /*if let url = NSURL(string: self.depositList["image"].string!) {
         if let data = NSData(contentsOf: url as URL) {
         cell.placeLogo.image = UIImage(data: data as Data)
         }
         }*/
        DispatchQueue.global(qos: .background).async {
            if let imageStringURL = self.depositList[indexPath.row]["image"].string {
                let url = URL(string: imageStringURL)
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.placeLogo.contentMode = .scaleAspectFit
                    //cell.placeLogo.image = Toucan(image: UIImage(data: data!)!).maskWithEllipse().image
                    cell.placeLogo.image = Toucan(image: UIImage(data: data!)!).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.crop).image
                    cell.placeLogo.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(M_PI)) / 360.0)
                }
            }
        }
        
        if let depositID = self.depositList[indexPath.row]["depositID"].string {
            cell.placeName.text = "Beverage ID: \(depositID)"
        } else {
            cell.placeName.text = "item: \(indexPath.row+1)"
        }
        
        if self.depositList[indexPath.row]["status"].string == "pending" {
            cell.pandingView.isHidden = false
        } else {
            cell.pandingView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        print("This will show info of index: \((indexPath as NSIndexPath).row)")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "infoWindow") as! InfoVC
        nextViewController.selectIndex = self.depositList[indexPath.row]
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    // MARK: - BUTTON ACTIONs
    @IBAction func depositAction(_ sender: AnyObject) {
        print("This will show scan QR code")
        self.scanQRCode()
    }
    
    func scanQRCode() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "barcodeWindow") as! QRcodeController
        secondViewController.scanType = "deposit"
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
