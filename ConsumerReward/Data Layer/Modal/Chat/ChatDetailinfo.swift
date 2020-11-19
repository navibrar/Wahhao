//
//  ChatDetailinfo.swift
//  Brand
//
//  Created by Apple on 15/10/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation
struct ChatDetailinfo {
    
    let message_id: Int
    let chat_created_on: String
    let last_updated:String
    let from_id: Int
    let to_id: Int
    let from_group: Int
    let message: String
    let message_created_on: String
    let avatar:String
    let media: String
    let message_created_fulldate: String
    let chat_id: String
     let media_type: String
     let media_thumbnail: String
    
    init(dictionary: NSDictionary) {
        self.chat_created_on = dictionary["chat_created_on"] as? String ?? ""
        self.message_id = dictionary["message_id"] as? Int ?? 0
        self.last_updated = dictionary["last_updated"] as? String ?? ""
        self.from_id = dictionary["from_id"] as? Int ?? 0
        self.to_id = dictionary["to_id"] as? Int ?? 0
        self.from_group = dictionary["from_group"] as? Int ?? 0
        self.message = dictionary["message"] as? String ?? ""
        self.message_created_on = dictionary["message_created_on"] as? String ?? ""
        self.avatar = dictionary["avatar"] as? String ?? ""
        self.media = dictionary["media"] as? String ?? ""
         self.media_type = dictionary["media_type"] as? String ?? ""
          self.media_thumbnail = dictionary["media_thumbnail"] as? String ?? ""
       self.message_created_fulldate = dictionary["message_created_fulldate"] as? String ?? ""
        if let idValue  = dictionary["chat_id"]
        {
            self.chat_id = "\(String(describing: idValue))"
        }
        else{
            self.chat_id = ""
        }
    }
}

