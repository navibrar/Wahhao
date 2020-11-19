//
//  BrandProfile.swift
//  Consumer
//
//  Created by apple on 14/12/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation

struct BrandProfile{
    
    var company_name: String
    var port_acc_prefix: String
    var port_accountid: String
    var row_num: String
    var profile_details : BrandBasicInfo
    var store_media : [Product]
    var home_media : NSDictionary
    var post_media : [HomePost]
    var reviews :[HomePost]
    var user_id: String
    var user_mobile_no: String
    var user_port_accountid: String
    
    var displayName: String{
        get{
            return company_name
        }
    }
    
    init(dictionary: NSDictionary)
    {
        if let value  = dictionary["port_acc_prefix"]
        {
            self.port_acc_prefix = "\(String(describing: value))"
        }
        else{
            self.port_acc_prefix = ""
        }
        
        if let value  = dictionary["port_accountid"]
        {
            self.port_accountid = "\(String(describing: value))"
        }
        else{
            self.port_accountid = ""
        }
        if let value  = dictionary["row_num"]
        {
            self.row_num = "\(String(describing: value))"
        }
        else{
            self.row_num = ""
        }

        self.company_name = dictionary["company_name"] as? String ?? ""
        
        let profile_details_dict = dictionary["profile_details"] as? NSDictionary ?? ["row_num":"0"]
        self.profile_details = BrandBasicInfo(dictionary: profile_details_dict)
     
        self.store_media  = []
        if let data = dictionary["store_media"] as? [NSDictionary]
        {
            self.store_media.removeAll()
            for dict in data {
                let value = Product(dictionary: dict)
                self.store_media.append(value)
            }
        }
        
        self.reviews  = []
        if let data = dictionary["reviews"] as? [NSDictionary]
        {
            self.reviews.removeAll()
            for dict in data {
                let value = HomePost(dictionary: dict)
                self.reviews.append(value)
            }
        }

        self.post_media  = []
        if let data = dictionary["post_media"] as? [NSDictionary]
        {
            self.post_media.removeAll()
            for dict in data {
                let value = HomePost(dictionary: dict)
                self.post_media.append(value)
            }
        }
        self.home_media = dictionary["home_media"] as? NSDictionary ?? ["about":"","media":[]]
        
        self.user_id = ""
        self.user_mobile_no = ""
        self.user_port_accountid = ""

        
        if let user_dict =  dictionary["user"] as? NSDictionary
        {
            if let value  = user_dict["id"]
            {
                self.user_id = "\(String(describing: value))"
            }

            if let value  = dictionary["port_accountid"]
            {
                self.user_port_accountid = "\(String(describing: value))"
            }
            self.user_mobile_no = user_dict["mobile_no"] as? String ?? ""
        }
    }
}
