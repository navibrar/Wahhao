//  Created by Navpreet on 24/10/18.
//  Copyright © 2018 wahhao. All rights reserved.

import Foundation

struct UserNotification {
  /*  "row_num": 1869,
    "fk_accountid": 90897,
    "message": "12345678 likes your video.",
    "type": "like_video",
    "is_read": 0,
    "redirect_url": "54",
    "created_at": "2019-01-31 12:09:00",
    "created_by": 91242,
    "updated_at": "2019-01-31 12:09:00",
    "profile_image": "https://dev-cdn.wahhao.com/user_91242/profile/1548936234.jpg",
    "follower_id": "0",
    "is_following": false,
    "reg_type": 2,
    "order_id": "",
    "product_id": "",
    "variant_id": "",
    "user_id": "",
    "seller_id": "",
    "post_id": "",
    "review_id": "54" */
    var image: String
    var created_by: Int
    var created_at: String
    var fk_accountid: String
    var is_read: Bool
    var message: String
    var redirect_url: String
    var row_num: String
    var updated_at: String
    var type: String
    var Notification_type: Int//1-Follow/Following,2-like,comment, mention
    var is_following: Bool
    var isTitleShowing:Bool
    var profile_image:String
    var follower_id: String
    var reg_type:String
    var order_id:String
    var product_id:String
    var variant_id:String
    var user_id:String
    var seller_id:String
    var post_id:String
    var review_id:String
    var consumer_id:String
    var brand_id:String
    
    init(dictionary: NSDictionary) {
        self.image = dictionary["image"] as? String ?? ""
        self.created_by = dictionary["created_by"] as? Int ?? 0
        self.created_at = dictionary["created_at"] as? String ?? ""
        self.is_following = dictionary["is_following"] as? Bool ?? false
        self.is_read = dictionary["is_read"] as? Bool ?? false
        
        if let value  = dictionary["fk_accountid"]
        {
            self.fk_accountid = "\(String(describing: value))"
        }
        else{
            self.fk_accountid = ""
        }
        
        
        self.message = dictionary["message"] as? String ?? ""
        self.type = dictionary["type"] as? String ?? ""
        self.updated_at = dictionary["updated_at"] as? String ?? ""
        
        if let value  = dictionary["redirect_url"]
        {
            self.redirect_url = "\(String(describing: value))"
        }
        else{
            self.redirect_url = ""
        }
        
        if let value  = dictionary["row_num"]
        {
            self.row_num = "\(String(describing: value))"
        }
        else{
            self.row_num = ""
        }
        
        self.Notification_type = 0
        
        
        if dictionary["isTitleShowing"] != nil{
            self.isTitleShowing = (dictionary["isTitleShowing"] as? Bool ?? false)!
        }else{
            self.isTitleShowing = false
        }
        
        self.profile_image = dictionary["profile_image"] as? String ?? ""
        
          self.follower_id = dictionary["follower_id"] as? String ?? ""
        
        if let value  = dictionary["reg_type"]
        {
            self.reg_type = "\(String(describing: value))"
        }
        else{
            self.reg_type = ""
        }
        
        if let value  = dictionary["order_id"]{
            self.order_id = "\(String(describing: value))"
        }else{
            self.order_id = ""
        }
        if let value  = dictionary["product_id"]{
            self.product_id = "\(String(describing: value))"
        }else{
            self.product_id = ""
        }
        if let value  = dictionary["variant_id"]{
            self.variant_id = "\(String(describing: value))"
        }else{
            self.variant_id = ""
        }
        if let value  = dictionary["user_id"]{
            self.user_id = "\(String(describing: value))"
        }else{
            self.user_id = ""
        }
        if let value  = dictionary["seller_id"]{
            self.seller_id = "\(String(describing: value))"
        }else{
            self.seller_id = ""
        }
        if let value  = dictionary["post_id"]{
            self.post_id = "\(String(describing: value))"
        }else{
            self.post_id = ""
        }
        if let value  = dictionary["review_id"]{
            self.review_id = "\(String(describing: value))"
        }else{
            self.review_id = ""
        }
        
        if let value  = dictionary["consumer_id"]{
            self.consumer_id = "\(String(describing: value))"
        }else{
            self.consumer_id = ""
        }
        if let value  = dictionary["brand_id"]{
            self.brand_id = "\(String(describing: value))"
        }else{
            self.brand_id = ""
        }
        
    }}

