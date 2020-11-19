//
//  Chat.swift
//  Brand
//
//  Created by apple on 12/10/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation
struct Chat {
    
   let chat_id: String
   let initiated_by: String
   let withwhom: String
   let chat_created_on: String
   let last_updated:String
   let from_group: String
   let message: String
   let message_created_on: String
   let is_read_from: Bool
   var is_read_to: Bool
   let chat_from: String
   let chat_to: String
   let chat_image: String
   let is_one2oneConvo: Bool
   var is_favorite: Bool
    let media: String
    let media_type: String
   let Color: String
   let TextImage: String
   let isTribe: Bool
    let media_thumbnail : String
    var is_convo_unread: Bool
   
   
    init(dictionary: NSDictionary) {
        
        if let idValue  = dictionary["chat_id"]
        {
            self.chat_id = "\(String(describing: idValue))"
        }
        else{
            self.chat_id = ""
        }
        
        if let initiated_by_value  = dictionary["initiated_by"]
        {
            self.initiated_by = "\(String(describing: initiated_by_value))"
        }
        else{
            self.initiated_by = ""
        }
        
        
        if let withwhomValue  = dictionary["withwhom"]
        {
            self.withwhom = "\(String(describing: withwhomValue))"
        }
        else{
            self.withwhom = ""
        }
        
        self.chat_image = dictionary["chat_image"] as? String ?? ""
        self.Color = dictionary["Color"] as? String ?? ""
        self.chat_from = (dictionary["chat_from"] as? String)?.lowercased() ?? ""
        self.message = dictionary["message"] as? String ?? ""
        self.chat_created_on = dictionary["chat_created_on"] as? String ?? ""
        self.TextImage = dictionary["TextImage"] as? String ?? ""
        self.isTribe = dictionary["isTribe"] as? Bool ?? false
      //  self.from_group = dictionary["from_group"] as? Bool ?? false
        // self.from_group = dictionary["withwhom_group"] as? Bool ?? false
        if let idValue  = dictionary["withwhom_group"]
        {
            self.from_group = "\(String(describing: idValue))"
        }
        else{
            self.from_group = ""
        }
        self.is_favorite = dictionary["is_favorite"] as? Bool ?? false
        self.is_read_to = dictionary["is_read_to"] as? Bool ?? false
        self.is_convo_unread = dictionary["is_convo_unread"] as? Bool ?? false
        self.is_read_from = dictionary["is_read_from"] as? Bool ?? false
        self.is_one2oneConvo = dictionary["is_one2oneConvo"] as? Bool ?? false
        self.chat_to = dictionary["chat_to"] as? String ?? ""
        self.message_created_on = dictionary["message_created_on"] as? String ?? ""
        self.last_updated = dictionary["last_updated"] as? String ?? ""
        self.media_type = dictionary["media_type"] as? String ?? ""
        self.media = dictionary["media"] as? String ?? ""
        self.media_thumbnail = dictionary["media_thumbnail"] as? String ?? ""
    }
}
