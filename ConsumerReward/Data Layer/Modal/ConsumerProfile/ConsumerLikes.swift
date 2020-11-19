//
//  ConsumerLikes.swift
//  ConsumerReward
//
//  Created by apple on 26/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import Foundation


struct ConsumerLikes {
    
    var created_on: String
    var fk_acc_prefix: String
    var fk_accountid: String
    var fk_post_id: String
    var id: String
    var type: String
    var media: String
    var media_thumbnail: String
    var status: String
    var total: String
    var post_detail : [HomePost]
    
    init(dictionary: NSDictionary) {
        
        self.created_on = dictionary["created_on"] as? String ?? ""
        
        if let value  = dictionary["fk_acc_prefix"]
        {
            self.fk_acc_prefix = "\(String(describing: value))"
        }
        else{
            self.fk_acc_prefix = ""
        }
        
        if let value  = dictionary["fk_accountid"]
        {
            self.fk_accountid = "\(String(describing: value))"
        }
        else{
            self.fk_accountid = ""
        }
        
        if let value  = dictionary["fk_post_id"]
        {
            self.fk_post_id = "\(String(describing: value))"
        }
        else{
            self.fk_post_id = ""
        }
        
        if let value  = dictionary["id"]
        {
            self.id = "\(String(describing: value))"
        }
        else{
            self.id = ""
        }
        self.media = dictionary["media"] as? String ?? ""
        self.media_thumbnail = dictionary["media_thumbnail"] as? String ?? ""
        self.type = dictionary["type"] as? String ?? ""
        
        if let value  = dictionary["status"]
        {
            self.status = "\(String(describing: value))"
        }
        else{
            self.status = ""
        }
        
        if let value  = dictionary["total"]
        {
            self.total = "\(String(describing: value))"
        }
        else{
            self.total = ""
        }
        
        self.post_detail  = []
        if let data = dictionary["post_detail"] as? [NSDictionary]
        {
            self.post_detail.removeAll()
            for dict in data {
                let value = HomePost(dictionary: dict)
                self.post_detail.append(value)
            }
        }
    }
}
