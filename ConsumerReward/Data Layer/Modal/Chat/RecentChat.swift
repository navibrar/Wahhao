//
//  RecentChat.swift
//  Brand
//
//  Created by apple on 13/10/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation


//
//  Chat.swift
//  Brand
//
//  Created by apple on 12/10/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation
struct RecentChat
{
    
    var latest_conversation: [Chat]
    var support_conversation: [SupportConversation]
    let support_chat_logo: String
    let support_chat: String
    let support_withwhom_group:Bool
    let business_withwhom_group: Bool
    let support_chat_userID: String
    let unread_conversation: String
    let unread_favorite_conversations: String
    let unread_one2one_conversations: String
    let unread_support_conversations: String

    
    init(dictionary: NSDictionary) {
        
       self.support_chat_logo = dictionary["support_chat_logo"] as?  String ?? ""
       self.support_chat = dictionary["support_chat"] as?  String ?? ""
        
        if let support_chat_userID_value  = dictionary["support_chat_userID"]
        {
            self.support_chat_userID = "\(String(describing: support_chat_userID_value))"
        }
        else{
            self.support_chat_userID = ""
        }
        if let unread_favorite_conversations_value  = dictionary["unread_favorite_conversations"]
        {
            self.unread_favorite_conversations = "\(String(describing: unread_favorite_conversations_value))"
        }
        else{
            self.unread_favorite_conversations = "0"
        }

        if let unread_one2one_conversations_value  = dictionary["unread_one2one_conversations"]
        {
            self.unread_one2one_conversations = "\(String(describing: unread_one2one_conversations_value))"
        }
        else{
            self.unread_one2one_conversations = "0"
        }

        
        if let unread_support_conversations_value  = dictionary["unread_support_conversations"]
        {
            self.unread_support_conversations = "\(String(describing: unread_support_conversations_value))"
        }
        else{
            self.unread_support_conversations = "0"
        }

        
        if let unread_conversation_value  = dictionary["unread_conversations"]
        {
            self.unread_conversation = "\(String(describing: unread_conversation_value))"
        }
        else{
            self.unread_conversation = "0"
        }

        self.business_withwhom_group = dictionary["support_chat_userID"] as? Bool ?? false
        self.support_withwhom_group = dictionary["support_withwhom_group"] as? Bool ?? false
        
        self.support_conversation = []
        let support_conversation_data = dictionary["support_conversation"] as? [NSDictionary] ?? []
        for dict in support_conversation_data {
            let value = SupportConversation(dictionary: dict)
            self.support_conversation.append(value)
        }
        
        self.latest_conversation = []
        let data1 = dictionary["latest_conversation"] as? [NSDictionary] ?? []
        for dict in data1 {
            let value = Chat(dictionary: dict)
            self.latest_conversation.append(value)
        }
    }
}
