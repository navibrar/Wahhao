//  Created by Navpreet on 11/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import Foundation

struct UserProfileFollowing {
    var id: String
    var user_id: String
    var follower_id: String
    var port_accountid: String
    var username: String
    var reg_type: String
    var full_name: String
    var image: String
    var row_num: String
    var isFollowed: Bool
    
    init(dictionary: NSDictionary) {

        if let value  = dictionary["id"]
        {
            self.id = "\(String(describing: value))"
        }
        else{
            self.id = ""
        }
        

        if let value  = dictionary["follower_id"]
        {
            self.follower_id = "\(String(describing: value))"
        }
        else{
            self.follower_id = ""
        }
        
        self.port_accountid = ""
        self.image = ""
        self.username = ""
        self.reg_type = ""
        self.full_name = ""
        self.row_num = ""
        self.user_id = ""

        if let details = dictionary["detail"]
        {
            let detailsDict = details as? NSDictionary ?? ["username":""]
            if let value  = detailsDict["port_accountid"]
            {
                self.port_accountid = "\(String(describing: value))"
            }
            if let value  = detailsDict["reg_type"]
            {
                self.reg_type = "\(String(describing: value))"
            }
            self.username = detailsDict["username"] as? String ?? ""
            self.full_name = detailsDict["full_name"] as? String ?? ""

            self.image = detailsDict["image"] as? String ?? ""
            
            if let value_row  = detailsDict["row_num"]
            {
                self.row_num =  "\(String(describing: value_row))"
            }
            else{
                self.row_num = ""
            }
            if let value  = detailsDict["user_id"]
            {
                self.user_id = "\(String(describing: value))"
            }
        }
        self.isFollowed = dictionary["is_following"] as? Bool ?? false
        
    }
}
