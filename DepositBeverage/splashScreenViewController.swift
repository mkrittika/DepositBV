//
//  splashScreenViewController.swift
//  SwiftLoginScreen
//
//  Created by MacbookPro on 8/16/2559 BE.
//  Copyright (c) 2014 Dipin Krishna. All rights reserved.
//

import UIKit

class splashScreenViewController: UIViewController {
    
    //let screenWidth = UIScreen.mainScreen().bounds.width
    //let screenHeight = UIScreen.mainScreen().bounds.height
    
    var image = UIImageView()
    
    
    var splaceTime: Timer?
    var count = 3 //Count down
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.image.frame = CGRect(x: (20*screenWidth)/100, y: 100, width: (60*screenWidth)/100, height: (60*screenWidth)/100)
        self.image.image = UIImage(named: "iTunesArtwork")
        self.view.addSubview(self.image)
        
        // Do any additional setup after loading the view.
        
        //นับถอยหลัง
        splaceTime = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(splashScreenViewController.openLogin), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    func openLogin() {
        if(count > 0){
            print(count)
            count -= 1
        } else if count == 0 {
            
            let userDefault = UserDefaults.standard //check for auto login
            
            if userDefault.object(forKey: "userLoginInfo") != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "tabsWindow") as! UITabBarController
                DispatchQueue.main.async {
                    self.present(vc, animated: true, completion: nil)
                }
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "registerWindow")
                DispatchQueue.main.async {
                    self.present(vc, animated: true, completion: nil)
                }
            }
            
            splaceTime!.invalidate() // This should stop NSTimer
        } else {
            print("This not stop")
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

}
