//  Created by Navpreet on 22/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import Foundation

struct Leaderboard {
    var referrals: Int
    var cash: Int
    var username: String
    var reg_type: Int
    var consumer_image: String
    var seller_image: String
    var profile_image: String
    var ranking: Int
    
    init(dictionary: NSDictionary) {
        self.referrals = 0
        if !(dictionary["referrals"] is NSNull) {
            if  let value = dictionary["referrals"] as? Int {
                self.referrals = value
            }else {
                self.referrals = Int(dictionary["referrals"] as! String == "" ? "0" : dictionary["referrals"] as! String)!
            }
        }
        
        self.cash = 0
        if !(dictionary["cash"] is NSNull) {
            if  let value = dictionary["cash"] as? Int {
                self.cash = value
            }else {
                self.cash = Int(dictionary["cash"] as! String == "" ? "0" : dictionary["cash"] as! String)!
            }
        }
        
        self.username = ""
        if !(dictionary["username"] is NSNull) {
            self.username = dictionary["username"] as? String ?? ""
            if self.username.count > 0 {
                self.username = "@\(self.username)"
            }
        }
        self.reg_type = 0
        if !(dictionary["reg_type"] is NSNull) {
            if  let value = dictionary["reg_type"] as? Int {
                self.reg_type = value
            }else {
                self.reg_type = Int(dictionary["reg_type"] as! String == "" ? "0" : dictionary["reg_type"] as! String)!
            }
        }
        
        self.consumer_image = ""
        if !(dictionary["reg_type"] is NSNull) {
            self.consumer_image = dictionary["consumer_image"] as? String ?? ""
        }
        self.seller_image = ""
        if !(dictionary["reg_type"] is NSNull) {
            self.seller_image = dictionary["seller_image"] as? String ?? ""
        }
        self.profile_image = ""
        if !(dictionary["reg_type"] is NSNull) {
            self.profile_image = dictionary["profile_image"] as? String ?? ""
        }
        self.ranking = 0
        if !(dictionary["ranking"] is NSNull) {
            if  let value = dictionary["ranking"] as? Int {
                self.ranking = value
            }else {
                self.ranking = Int(dictionary["ranking"] as! String == "" ? "0" : dictionary["ranking"] as! String)!
            }
        }
    }
}
