//
//  SupportConversation.swift
//  Brand
//
//  Created by apple on 13/10/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation
struct SupportConversation {
    
    let chat_id: String
    let message_id: Int
    let chat_created_on: String
    let last_updated:String
    let from_id: Int
    let to_id: Int
    let message: String
    let message_created_on: String
    let media: String
    let chat_from: String
    
    init(dictionary: NSDictionary) {
        if let idValue  = dictionary["chat_id"]
        {
            self.chat_id = "\(String(describing: idValue))"
        }
        else{
            self.chat_id = ""
        }
        self.message_id = dictionary["message_id"] as? Int ?? 0
        self.chat_created_on = dictionary["chat_created_on"] as? String ?? ""
        self.last_updated = dictionary["last_updated"] as? String ?? ""
        self.from_id = dictionary["from_id"] as? Int ?? 0
        self.to_id = dictionary["to_id"] as? Int ?? 0
        self.message = dictionary["message"] as? String ?? ""
        self.message_created_on = dictionary["message_created_on"] as? String ?? ""
        self.media = dictionary["media"] as? String ?? ""
        self.chat_from = (dictionary["chat_from"] as? String)?.lowercased() ?? "wahhaosupport"
    }
}
