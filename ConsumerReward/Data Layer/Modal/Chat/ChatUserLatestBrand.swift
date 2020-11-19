//
//  ChatUser.swift
//  Brand
//
//  Created by apple on 12/10/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation
struct ChatUserLatestBrand {
    
    let port_acc_prefix: String
    let port_acc__invokeountid: String
    let username: String
    let company_name: String
    let chat_id: String
    let display_name: String
    let withwhom_group: String
    let avatar: String

    init(dictionary: NSDictionary) {
        self.company_name = dictionary["company_name"] as? String ?? ""
         self.display_name = dictionary["display_name"] as? String ?? ""
        self.username = (dictionary["username"] as? String)?.lowercased() ?? ""
        if let idValue  = dictionary["port_acc_prefix"]
        {
            self.port_acc_prefix = "\(String(describing: idValue))"
        }
        else{
            self.port_acc_prefix = ""
        }
        
        if let idValue  = dictionary["port_accountid"]
        {
            self.port_acc__invokeountid = "\(String(describing: idValue))"
        }
        else{
            self.port_acc__invokeountid = ""
        }
        
        if let idValue  = dictionary["chat_id"]
        {
            self.chat_id = "\(String(describing: idValue))"
        }
        else{
            self.chat_id = ""
        }
        
        if let idValue  = dictionary["withwhom_group"]
        {
            self.withwhom_group = "\(String(describing: idValue))"
        }
        else{
            self.withwhom_group = ""
        }
        
//        if let idValue  = dictionary["is_support"]
//        {
//            self.is_support = "\(String(describing: idValue))"
//        }
//        else{
//            self.is_support = ""
//        }
        
        self.avatar = dictionary["avatar"] as? String ?? ""
    }
}
