//
//  UserProfileServices.swift
//  Consumer
//
//  Created by apple on 12/13/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation

final class UserProfileServices {
    
    static let sharedInstance = UserProfileServices()
    // fileprivate init() {}
    var usersFollowingList: [UserProfileFollowing] = []
    var usersFollowersList: [UserProfileFollowing] = []
    var total_followers = "0"
    var total_followwings = "0"
    
    var ConsumerProfile : consumerBasicInfo? = nil

    //FETCH API TO BAG ITEMS
    func fetchFollowingAndFollowersList(showLoader loader: Bool,value:String, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        var url = Network.APIEndPoints.follower.rawValue
        if value != ""
        {
            url = url + "/\(value)"
        }
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            self.usersFollowingList.removeAll()
            self.usersFollowersList.removeAll()

            if let value = success["status"] as? Bool {
                print(value )
                if value
                {
                    if let result = success["response"] as? NSDictionary
                    {
                        if let followers = result["followers"] as? NSDictionary
                        {
                            if let data = followers["users"] as? [NSDictionary]
                            {
                                for dict in data {
                                    let value = UserProfileFollowing(dictionary: dict)
                                    self.usersFollowersList.append(value)
                                }
                            }
                            if let total = followers["total"]
                            {
                                self.total_followers = "\(String(describing: total))"
                            }
                            else{
                                self.total_followers = "0"
                            }
                        }
                   
                        if let followings = result["followings"] as? NSDictionary
                        {
                            if let data = followings["users"] as? [NSDictionary]
                            {
                                for dict in data {
                                    let value = UserProfileFollowing(dictionary: dict)
                                    self.usersFollowingList.append(value)
                                }
                            }
                            if let total = followings["total"]
                            {
                                self.total_followwings = "\(String(describing: total))"
                            }
                            else{
                                self.total_followwings = "0"
                            }
                        }
                    }
                    aBlock (success as AnyObject)
                }
                else {
                    self.usersFollowingList.removeAll()
                    self.usersFollowersList.removeAll()
                    failBlock(success)
                }
            }
            else {
                self.usersFollowingList.removeAll()
                self.usersFollowersList.removeAll()
                failBlock(success)
            }
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            self.usersFollowingList.removeAll()
            self.usersFollowersList.removeAll()
            failBlock(failBlock as AnyObject)
        }
    }
    
    
    func callWebserviceForUpdateConsumerProfile (parameters: [String: Any], showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void))
    {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.ConsumerEditProfile.rawValue
        service.postAPIs (urlName: url, andParams: parameters, showLoader: true, outhType: "", success: { (success) -> Void in
            if let value = success["status"] as? Bool {
                if value == true {
                    //user_info
                    let result = success as! NSDictionary
                    print(result)
                    
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
    
    
    //FETCH API TO Profile item
    func fetchProfileData(value:String,showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.ConsumerProfile.rawValue + "/" + value
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
           
            
            if let value = success["status"] as? Bool {
                print(value)
                if value
                {
                    if let result = success["response"] as? NSDictionary
                    {
                        let value = consumerBasicInfo(dictionary: result)
                        self.ConsumerProfile = value
                        print("get data",result)
                    }
                    aBlock (success as AnyObject)
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
    
    func callFollowBrandAPI(parameters: [String: Any], showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.follower.rawValue
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
    func callUnFollowBrandAPI(parameters: [String: Any], showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.follower.rawValue
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
    
    
    func callUpdateUserPhoneNumber(parameters: [String: Any], showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.ConsumerupdatePhone.rawValue
        service.postAPIs (urlName: url, andParams: parameters, showLoader: loader, outhType: outhType, success: { (success) -> Void in
                    aBlock (success)
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            failBlock(failBlock as AnyObject)
        }
    }
    func callUpdateUseremail(parameters: [String: Any], showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.ConsumerupdateEmail.rawValue
        service.postAPIs (urlName: url, andParams: parameters, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            aBlock (success)
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            failBlock(failBlock as AnyObject)
        }
    }
    func callVerifyOTPAPI (parameters: [String: Any], isLogin: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.ConsumerphoneOtp.rawValue
        service.postAPIs (urlName: url, andParams: parameters, showLoader: true, outhType: "", success: { (success) -> Void in
            aBlock (success)
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            failBlock(failBlock as AnyObject)
        }
    }
    
}
