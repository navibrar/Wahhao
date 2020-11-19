//  Created by Navpreet on 25/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import Foundation

struct LogoutServices{
    func callLogoutUser(parameters: [String: Any], showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.logout.rawValue
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
