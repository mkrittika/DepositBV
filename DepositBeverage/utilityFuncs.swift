 //
 //  utilityFuncs.swift
 //  DepositBeverage
 //
 //  Created by MacbookPro on 8/18/2559 BE.
 //  Copyright © 2559 mintmint. All rights reserved.
 //
 
 import Foundation
 import UserNotifications
 import UserNotificationsUI //framework to customize the notification
 
 
 var QRCode: String = ""
 var isScan: Bool = false
 
 class utilityFuncs: NSObject, UNUserNotificationCenterDelegate {
    
    let requestIdentifier = "depositExpire" //identifier is to cancel the notification request
    
    // MARK: - Validate email format
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = testStr.range(of: emailRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    // MARK: - Validate password format
    func isValidPass(_ pass: String) -> Bool {
        //let emailRegEx = "^([a-zA-Z0-9]).{8,16}$"
        let passRegEx = "[A-Za-z]{8,14}"
        let range = pass.range(of: passRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    func isValidQRCode(code: String) -> Bool {
        
        let sepCode = code.components(separatedBy: "-")
        if sepCode[0] == "DB" {
            return true
        } else {
            return false
        }
    }
    
    func createNotification(notiDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Deposit Beverage"
        //content.subtitle = "Lets code,Talk is cheap"
        content.body = "Your deposit beverage about to expire"
        content.sound = UNNotificationSound.default()
        
        //To Present image in notification
        /*if let path = Bundle.main.path(forResource: "monkey", ofType: "png") {
         let url = URL(fileURLWithPath: path)
         
         do {
         let attachment = try UNNotificationAttachment(identifier: "sampleImage", url: url, options: nil)
         content.attachments = [attachment]
         } catch {
         print("attachment not found.")
         }
         }*/
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 10.0, repeats: false)
        
        
        // Set real expire date;
        //let nexSevenDays = Calendar.current.date(byAdding: .day, value: 7, to: notiDate)
        //let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: nexSevenDays!)
        //let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,repeats: true)
        
        let request = UNNotificationRequest(identifier:requestIdentifier, content: content, trigger: trigger)
        
        
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            if (error != nil){
                print(error?.localizedDescription as Any)
            }
        }    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier {
            completionHandler( [.alert,.sound,.badge])
        }
    }
 }
 
 /*extension utilityFuncs: UNUserNotificationCenterDelegate {
  
  
  
  }*/
