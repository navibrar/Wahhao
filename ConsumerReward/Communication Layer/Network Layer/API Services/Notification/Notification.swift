//
//  Notification.swift
//  ConsumerReward
//
//  Created by apple on 17/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.
//

import Foundation
final class NotificationServices {
    
    static let sharedInstance = NotificationServices()
    var array_Notifications = [NotificationTimeLine]()


func fetchNotificationInfo(showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
    let service = WebAPIServices()
    let url = Network.APIEndPoints.notification.rawValue
    service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
        self.array_Notifications.removeAll()
        if let value = success["status"] as? Bool {
            print(value)
            
            if value
            {
                 if let result = success["response"] as? NSDictionary {
                    if let data  = result["notify"] as? [NSDictionary]{
                       for dict in data {
                    let value = NotificationTimeLine(dictionary: dict)
                    self.array_Notifications.append(value)
                }
             }
         }
            aBlock (success)
            }
            else {
                self.array_Notifications.removeAll()
                failBlock(success)
            }
        }
        else {
            self.array_Notifications.removeAll()
            failBlock(success)
        }
        // your successful handle
    }) { (failure) -> Void in
        // your failure handle
        self.array_Notifications.removeAll()
        failBlock(failBlock as AnyObject)
    }
}
   /* func callReadNotification(parameters: String, showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
       let url = Network.APIEndPoints.notificationRead.rawValue + "/" + parameters
        service.postAPIs (urlName: url, andParams: "", showLoader: loader, outhType: outhType, success: { (success) -> Void in
            if let value = success["status"] as? Bool {
                print(value)
                if value == true {
                    aBlock (success)
                }else{
                    failBlock(success)
                }
            }else {
                failBlock(success)
            }
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            failBlock(failBlock as AnyObject)
        }
    }*/
    
    func callReadNotification(value:String,showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.notificationRead.rawValue + "/" + value
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            if let value = success["status"] as? Bool {
                print(value )
                if value
                {
                    aBlock (self as AnyObject)
                }
                else {
                    failBlock(success)
                }
            }
            else {
                failBlock(success)
            }
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            failBlock(failBlock as AnyObject)
        }
    }

    
}
