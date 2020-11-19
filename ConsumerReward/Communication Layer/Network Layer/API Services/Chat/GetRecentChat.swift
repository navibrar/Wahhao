//
//  GetRecentChat.swift
//  Brand
//
//  Created by apple on 13/10/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation


final class GetRecentChat
{
    static let sharedInstance = GetRecentChat()
   
    var recentChat :RecentChat? = nil
    var ChatDeatil : ChatDetails? = nil
    func callRecentChatData(completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.chatrecent.rawValue
         service.getAPIs(urlName: url, showLoader: true, outhType: "",success: { (success) -> Void in
            if let value = success["status"]
            {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool
                {
                    let result = success["response"] as? NSDictionary
                    // let profileDetal = result!["profile_details"] as? NSDictionary
                    self.recentChat = nil
                    let value = RecentChat(dictionary: result!)
                    self.recentChat = value
                    aBlock (success as AnyObject)
                }
                else {
                    failBlock(success)
                }
            } else {
                failBlock(success)
            }
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            failBlock(failBlock as AnyObject)
        }
    }
    
    
    func callChatDetailData(value : String,completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let getUrl = Network.APIEndPoints.chatDetail.rawValue
        let url = getUrl + value
         service.getAPIs(urlName: url, showLoader: true, outhType: "",success: { (success) -> Void in
            if let value = success["status"]
            {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool
                {
                    let result = success["response"] as? NSDictionary
                    // let profileDetal = result!["profile_details"] as? NSDictionary
                    self.ChatDeatil = nil
                    let value = ChatDetails(dictionary: result!)
                    self.ChatDeatil = value
                    aBlock (success as AnyObject)
                }
                else {
                    failBlock(success)
                }
            } else {
                failBlock(success)
            }
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            failBlock(failBlock as AnyObject)
        }
    }
    
    func callWebserviceForAddToFavoritePost (value: String, showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.chataddass.rawValue + "\(value)"
        service.putAPIs(urlName: url, showLoader: loader, outhType: "", success: { (success) -> Void in
            if let value = success["status"]
            {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool
                {
                    aBlock (success)
                }
                else
                {
                    failBlock(success)
                }
            }
            else
            {
                failBlock(success)
            }
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            failBlock(failBlock as AnyObject)
        }
    }
    func callWebserviceForRemoveFromFavoritePost (value: String, showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.chatremoveass.rawValue + "\(value)"
        service.putAPIs(urlName: url, showLoader: loader, outhType: "", success: { (success) -> Void in
            if let value = success["status"]
            {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool
                {
                    aBlock (success)
                }
                else
                {
                    failBlock(success)
                }
            }
            else
            {
                failBlock(success)
            }
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            failBlock(failBlock as AnyObject)
        }
    }
}
