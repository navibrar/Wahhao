//
//  UserHomePost.swift
//  Brand
//
//  Created by apple on 29/08/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation

struct UserHomePost{
    var id: String
    var email: String
    var mobile_no: String
    var country_code: String
    var business_type: String
    var access_token: String
    var port_accountid: String
    var port_acc_prefix: String
    var created_at: String
    var cart_items_count: Int
    var updated_at :String
    var cart :[Cart]
    var rewards : [RewardsHomePost]
    var userImage :String

    init(dictionary: NSDictionary)
    {
        if let value  = dictionary["id"]
        {
            self.id = "\(String(describing: value))"
        }
        else{
            self.id = ""
        }
        
        self.email = dictionary["email"] as? String ?? ""
        self.mobile_no = dictionary["mobile_no"] as? String ?? ""
        self.access_token = dictionary["access_token"] as? String ?? ""
        self.created_at = dictionary["created_at"] as? String ?? ""
        self.updated_at = dictionary["updated_at"] as? String ?? ""


        if let value  = dictionary["country_code"]
        {
            self.country_code = "\(String(describing: value))"
        }
        else{
            self.country_code = ""
        }
        
        if let value  = dictionary["cart_items_count"]
        {
            self.cart_items_count =  (value as? Int) ?? 0
        }
        else{
            self.cart_items_count = 0
        }
        
        if let value  = dictionary["business_type"]
        {
            self.business_type = "\(String(describing: value))"
        }
        else{
            self.business_type = ""
        }
        
        if let value  = dictionary["port_accountid"]
        {
            self.port_accountid = "\(String(describing: value))"
        }
        else{
            self.port_accountid = ""
        }
        if let value  = dictionary["port_acc_prefix"]
        {
            self.port_acc_prefix = "\(String(describing: value))"
        }
        else{
            self.port_acc_prefix = ""
        }
        
        self.cart = []
        self.rewards = []

        if let data = dictionary["cart"] as? [NSDictionary]
        {
            self.cart.removeAll()
            for dict in data {
                let value = Cart(dictionary: dict)
                self.cart.append(value)
            }
        }
        if let data = dictionary["rewards"] as? [NSDictionary]
        {
            self.rewards.removeAll()
            for dict in data {
                let value = RewardsHomePost(dictionary: dict)
                self.rewards.append(value)
            }
        }
        self.userImage = ""
        let user_media = dictionary["user_media"] as? NSDictionary ?? ["media":""]
        self.userImage = user_media["media"] as? String ?? ""

    }
}
