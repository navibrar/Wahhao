//
//  ChatDetails.swift
//  Brand
//
//  Created by Apple on 15/10/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation
struct ChatDetails {
    
    var ChatUserInfo_conversation: ChatUserInfo
    let support_chat_logo: String
     let support_chat: String
    var ChatDetailInfo_conversation: [ChatDetailinfo]
    
    init(dictionary: NSDictionary) {
    
        
    self.support_chat_logo = dictionary["support_chat_logo"] as?  String ?? ""
   self.support_chat = dictionary["support_chat"] as?  String ?? ""
   
        self.ChatDetailInfo_conversation = []
        let data = dictionary["chat_detail"] as? [NSDictionary] ?? []
        for dict in data {
            let value1 = ChatDetailinfo(dictionary: dict)
            self.ChatDetailInfo_conversation.append(value1)
        }
        
    
   
    let data1 = dictionary["chat_user_info"] as! NSDictionary
    let value1 = ChatUserInfo(dictionary: data1)
    self.ChatUserInfo_conversation = value1
    }
}
