//
//  HomeVC.swift
//  SwiftLoginScreen
//
//  Created by MacbookPro on 8/16/2559 BE.
//  Copyright (c) 2014 Dipin Krishna. All rights reserved.

import UIKit
import SwiftyJSON

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView = UITableView()
    
    var placeList: JSON = []
    var mockPlace = ["Warm up Cafe", "Good View Village", "The Windmill"]
    var mockTime = ["18:00 - 01:00", "17:00 - 12:00", "17:00 - 12:00"]
    
    // MARK: - MAIN FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.size.height)
        self.view.addSubview(self.tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //This will get data from server side
        
    }
    
    
    // MARK: - TABLEVIEW FUNCs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mockPlace.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.register(UINib(nibName: "placeTableViewCell", bundle: nil), forCellReuseIdentifier: "placeCell")
        let cell: placeTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "placeCell") as! placeTableViewCell
        
        cell.placeName.text = self.mockPlace[indexPath.row]
        cell.placeOpenClose.text = self.mockTime[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        print("click on index: \(indexPath.row)")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "depositWindow") as! DepositVC
        nextViewController.selectIndex = (indexPath as NSIndexPath).row
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    // MARK: - GET DATA FROM SERVER
    func getData() {
        
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
}
