//
//  BrandProfile.swift
//  Consumer
//
//  Created by apple on 9/5/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation
final class BrandProfileServices {
    
    static let sharedInstance = BrandProfileServices()
    var brandProfile : BrandProfile? = nil
//    var collectionImagesList = [HomePostModel]()
//    var collectionVideosList = [HomePostModel]()
//    var collectionWhatsNewList = [HomePostModel]()
//    static let sharedInstance = GetProfileDataService()
    

    func fetchBrandProfileInfo(value:String,showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.brandProfile.rawValue + "/" + value
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            self.brandProfile = nil
            if let value = success["status"] as? Bool {
                print(value )
                if value
                {
                    let result = success["response"] as! NSDictionary
                    
                    //                    let data = result["products"] as? [NSDictionary]
                    //                    for dict in data! {
                    let value = BrandProfile(dictionary: result)
                    self.brandProfile = value
                    //                        self.list.append(value)
                    //                    }
                    aBlock (self as AnyObject)
                }
                else {
                    self.brandProfile = nil
                    failBlock(success)
                }
            }
            else {
                self.brandProfile = nil
                failBlock(success)
            }
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            self.brandProfile = nil
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
}

