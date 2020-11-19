//
//  ChatUserInfo.swift
//  Brand
//
//  Created by Apple on 15/10/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation
struct ChatUserInfo {
    
    let withwhom_id: String
    let company_name: String
    let username:String
    let avatar: String
    let withwhom_group: Int
   
    
    init(dictionary: NSDictionary) {
        
        self.username = (dictionary["username"] as? String)?.lowercased() ?? ""
        self.avatar = dictionary["avatar"] as? String ?? ""
        self.company_name = dictionary["company_name"] as? String ?? ""
        if let idValue  = dictionary["withwhom_id"]
        {
            self.withwhom_id = "\(String(describing: idValue))"
        }
        else{
            self.withwhom_id = ""
        }
        self.withwhom_group = dictionary["withwhom_group"] as? Int ?? 0
    }
}
