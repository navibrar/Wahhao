//
//  UserProfileServices.swift
//  Consumer
//
//  Created by apple on 12/13/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation

final class ReferralTrackerServices {
    
    static let sharedInstance = ReferralTrackerServices()
    // fileprivate init() {}
    var referralUsersList: [ReferralTrackerData] = []
    var referralDetails: ReferralDetails? = nil

    //FETCH API TO BAG ITEMS
    func fetchContactsList(showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.trackerList.rawValue

        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            self.referralUsersList.removeAll()

            if let value = success["status"] as? Bool {
                print(value )
                if value
                {
                    if let result = success["response"] as? NSDictionary
                    {
                        if let data = result["track_list"] as? [NSDictionary]
                        {
                            for dict in data {
                                let value = ReferralTrackerData(dictionary: dict)
                                self.referralUsersList.append(value)
                            }
                        }
                        if let referal_details_dict = result["referal_details"] as? NSDictionary {
                            self.referralDetails = ReferralDetails(dictionary: referal_details_dict)
                        }
                    }
                    aBlock (success as AnyObject)
                }
                else {
                    self.referralUsersList.removeAll()
                    failBlock(success)
                }
            }
            else {
                self.referralUsersList.removeAll()
                failBlock(success)
            }
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            self.referralUsersList.removeAll()
            failBlock(failBlock as AnyObject)
        }
    }
    
    
    
    func contactSave(parameters: [String: Any], showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.contactSave.rawValue
        service.postAPIs (urlName: url, andParams: parameters, showLoader: loader, outhType: outhType, success: { (success) -> Void in
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
    }
    func contactInviteAPI(parameters: [String: Any], showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.contactInvite.rawValue
        service.postAPIs (urlName: url, andParams: parameters, showLoader: loader, outhType: outhType, success: { (success) -> Void in
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
    }
}
