//  Created by Navpreet on 25/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.

import Foundation

final class SettingsServices {
    static let sharedInstance = SettingsServices()
    
    func callGetNotificationSettingsStatusAPI(showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.notificationSettings.rawValue
        service.getAPIs(urlName: url, showLoader: loader, outhType: "", success: { (success) -> Void in
            if let value = success["status"] {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool {
                    aBlock (success)
                }else {
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
    }
    
    func callUpdateNotificationSettingsStatusAPI (parameters: [String: Any], showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.notificationSettings.rawValue
        service.postAPIs (urlName: url, andParams: parameters, showLoader: loader, outhType: "", success: { (success) -> Void in
            if let value = success["status"] {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool {
                    aBlock (success)
                }else {
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
    }
}

