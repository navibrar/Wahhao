//
//  ChatUser.swift
//  Brand
//
//  Created by apple on 12/10/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation
struct ChatUserLatestConversation {
    
  
    let chat_created_on: String
    let last_updated:String
    let username: String
    let company_name: String
     let display_name: String
     let chat_id: String
    let avatar: String

    init(dictionary: NSDictionary) {
        if let idValue  = dictionary["chat_id"]
        {
            self.chat_id = "\(String(describing: idValue))"
        }
        else{
            self.chat_id = ""
        }
        self.username = (dictionary["username"] as? String)?.lowercased() ?? ""
        self.company_name = dictionary["company_name"] as? String ?? ""
         self.display_name = dictionary["display_name"] as? String ?? ""
        self.avatar = dictionary["avatar"] as? String ?? ""
        self.chat_created_on = dictionary["chat_created_on"] as? String ?? ""
        self.last_updated = dictionary["last_updated"] as? String ?? ""
    }
}
