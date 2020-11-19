//  Created by Navpreet on 22/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import Foundation

final class ShareEarnServices {
    static let sharedInstance = ShareEarnServices()
    var referralDetails: ReferralDetails? = nil

    func callShareCodeAPI(showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.referalCode.rawValue
        service.getAPIs(urlName: url, showLoader: loader, outhType: "", success: { (success) -> Void in
            if let value = success["status"] {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool {
                    if let result = success["response"] as? NSDictionary {
                        self.referralDetails = ReferralDetails(dictionary: result)
                    }
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
