//
//  UserChat.swift
//  Brand
//
//  Created by Navpreet on 15/10/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation
final class UserChat{
    
    static let sharedInstance = UserChat()
    var arrayUserLatestConversation = [ChatUserLatestConversation]()
    var arrayUserBrand = [ChatUserLatestBrand]()
 
    func callWebserviceForGetUsersList(isShowLoader: Bool,completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        
        let url = Network.APIEndPoints.chatNew.rawValue
        service.getAPIs(urlName: url, showLoader: true, outhType: "",success: { (success) -> Void in
            self.arrayUserLatestConversation.removeAll()
            self.arrayUserBrand.removeAll()
            if let value = success["status"] {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool
                {
                    let result = success["response"] as? NSDictionary
                    let list_brands_data = result!["list_brands"] as? [NSDictionary]
                    let latest_conversation_data = result!["latest_conversation"] as? [NSDictionary]

                    for dict in list_brands_data! {
                        let value = ChatUserLatestBrand(dictionary: dict)
                        self.arrayUserBrand.append(value)
                    }
                    for dict in latest_conversation_data! {
                        let value = ChatUserLatestConversation(dictionary: dict)
                        self.arrayUserLatestConversation.append(value)
                    }
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
            self.arrayUserLatestConversation.removeAll()
            self.arrayUserBrand.removeAll()
            failBlock(failBlock as AnyObject)
        }
    }
}
