//  Created by Navpreet on 24/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import Foundation

struct ConsumerWishlist {
    
    var id: Int
    var user_id: Int
    var product_id: Int
    var quantity: Int
    var like_count: Int
    var type: String
    var media: String
    var media_thumbnail: String
    
    init(dictionary: NSDictionary) {
        self.id = 0
        if !(dictionary["id"] is NSNull) {
            if  let value = dictionary["id"] as? Int {
                self.id = value
            }else {
                self.id = Int(dictionary["id"] as! String == "" ? "0" : dictionary["id"] as! String)!
            }
        }
        
        self.user_id = 0
        if !(dictionary["fk_accountid"] is NSNull) {
            if  let value = dictionary["fk_accountid"] as? Int {
                self.user_id = value
            }else {
                self.user_id = Int(dictionary["fk_accountid"] as! String == "" ? "0" : dictionary["fk_accountid"] as! String)!
            }
        }
        
        self.product_id = 0
        if !(dictionary["product_id"] is NSNull) {
            if  let value = dictionary["product_id"] as? Int {
                self.product_id = value
            }else {
                self.product_id = Int(dictionary["product_id"] as! String == "" ? "0" : dictionary["product_id"] as! String)!
            }
        }
        
        self.quantity = 0
        if !(dictionary["quantity"] is NSNull) {
            if  let value = dictionary["quantity"] as? Int {
                self.quantity = value
            }else {
                self.quantity = Int(dictionary["quantity"] as! String == "" ? "0" : dictionary["quantity"] as! String)!
            }
        }
        
        self.like_count = 0
        if !(dictionary["total_love"] is NSNull) {
            if  let value = dictionary["total_love"] as? Int {
                self.like_count = value
            }else {
                self.like_count = Int(dictionary["total_love"] as! String == "" ? "0" : dictionary["total_love"] as! String)!
            }
        }
        
        self.type = ""
        if !(dictionary["type"] is NSNull) {
            self.type = dictionary["type"] as? String ?? ""
        }
        
        self.media = ""
        if !(dictionary["media"] is NSNull) {
            self.media = dictionary["media"] as? String ?? ""
        }
        
        self.media_thumbnail = ""
        if !(dictionary["media_thumbnail"] is NSNull) {
            self.media_thumbnail = dictionary["media_thumbnail"] as? String ?? ""
        }
    }
}
