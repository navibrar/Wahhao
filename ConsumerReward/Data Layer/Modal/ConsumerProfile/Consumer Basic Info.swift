//
//  Consumer Basic Info.swift
//  ConsumerReward
//
//  Created by apple on 26/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import Foundation
struct consumerBasicInfo{
    var port_accountid: String
    var port_acc_prefix: String
    var row_num: String
    var company_name: String
    var username: String
    var full_name: String
    var postlikes : String
    var reviews : String
    var wishlist : String
    var user_media : String
    
    var bio : String
    var dob : String
    var gender : String
    
    
    var referrals : String
    var review_reward : String
    var share_profile : String
    var wishlist_items_count : String
    
    var wishlistinfo : [Product]
    var post_media : [HomePost]
    var reviewsInfo :[HomePost]
    
    var followers : String
    var following : String
    var user_id : String
    var is_following: Bool
    var review_cashback: Float
    var reg_email_id: String
    
    init(dictionary: NSDictionary)
    {
        if let value  = dictionary["port_acc_prefix"]
        {
            self.port_acc_prefix = "\(String(describing: value))"
        }
        else{
            self.port_acc_prefix = ""
        }
        
        if let value  = dictionary["port_accountid"]
        {
            self.port_accountid = "\(String(describing: value))"
        }
        else{
            self.port_accountid = ""
        }
        
        if let value  = dictionary["row_num"]
        {
            self.row_num = "\(String(describing: value))"
        }
        else{
            self.row_num = ""
        }
        
        self.company_name = dictionary["company_name"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        
        let user_media_Dict = dictionary["user_media"] as? NSDictionary ?? ["media":""]
        self.user_media = user_media_Dict["media"] as? String ?? ""
        
        let user_detail_Dict = dictionary["detail"] as! NSDictionary
        self.full_name = user_detail_Dict["full_name"] as? String ?? ""
        
        self.bio = dictionary["bio"] as? String ?? ""
        self.dob = dictionary["dob"] as? String ?? ""
        
        if let value  = dictionary["gender"]
        {
            self.gender = "\(String(describing: value))"
        }
        else{
            self.gender = ""
        }
        
        let user_leaderboard_Dict = dictionary["leaderboard"] as! NSDictionary
        if let referrals_value  = user_leaderboard_Dict["referrals"]
        {
            self.referrals = "\(String(describing: referrals_value))"
        }
        else{
            self.referrals = ""
        }
        self.review_reward = user_leaderboard_Dict["review_reward"] as? String ?? ""
        self.share_profile = user_leaderboard_Dict["share_profile"] as? String ?? ""
        if let referrals_wishlist  = user_leaderboard_Dict["wishlist_items_count"]
        {
            self.wishlist_items_count = "\(String(describing: referrals_wishlist))"
        }
        else{
            self.wishlist_items_count = ""
        }
        
        let user_dict = dictionary["user"] as! NSDictionary
        if let followers_value  = user_dict["followers"]
        {
            self.followers = "\(String(describing: followers_value))"
        }
        else{
            self.followers = ""
        }
        if let following_value  = user_dict["following"]
        {
            self.following = "\(String(describing: following_value))"
        }
        else{
            self.following = ""
        }
        if let user_id_value  = user_dict["id"]
        {
            self.user_id = "\(String(describing: user_id_value))"
        }
        else{
            self.user_id = ""
        }
        self.is_following = user_dict["is_following"] as? Bool ?? false
        
        
        
        let count_Dict = dictionary["count"] as! NSDictionary
        if let value  = count_Dict["likes"]
        {
            self.postlikes = "\(String(describing: value))"
        }
        else{
            self.postlikes = ""
        }
        
        if let value  = count_Dict["reviews"]
        {
            self.reviews = "\(String(describing: value))"
        }
        else{
            self.reviews = ""
        }
        
        if let value  = count_Dict["wishlist"]
        {
            self.wishlist = "\(String(describing: value))"
        }
        else{
            self.wishlist = ""
        }

        self.reviewsInfo  = []
        let user_reviews_Dict = dictionary["reviews"] as! NSDictionary
        if let data = user_reviews_Dict["posts"] as? [NSDictionary]
        {
            self.reviewsInfo.removeAll()
            for dict in data {
                let value = HomePost(dictionary: dict)
                self.reviewsInfo.append(value)
            }
        }
        
        
//        self.reviewsInfo  = []
//        let user_review_Dict = dictionary["reviews"] as! NSDictionary
//        if let user_review_detail = user_review_Dict["posts"] as? [NSDictionary]
//        {
//            self.reviewsInfo = []
//            for dict in user_review_detail {
//                if let user_review = dict["reviews_detail"] as? NSDictionary {
//                    let value = Reviews(dictionary: user_review)
//                    self.reviewsInfo.append(value)
//                }
//                
//            }
//        }
        
        
        self.wishlistinfo  = []
        let user_wishlist_Dict = dictionary["wishlist"] as! NSDictionary
        if let user_wishlist_detail = user_wishlist_Dict["products"] as? [NSDictionary]
        {
            self.wishlistinfo = []
            for dict in user_wishlist_detail {
               
                if let user_product = dict["product"] as? NSDictionary {
            
                    let value = Product(dictionary: user_product)
                    
                    self.wishlistinfo.append(value)
                }
                
            }
        }
        
        self.post_media  = []
        let user_posts_Dict = dictionary["post_likes"] as! NSDictionary
        if let user_post_detail = user_posts_Dict["posts"] as? [NSDictionary]
        {
            self.post_media = []
            for dict in user_post_detail {
                    let value = HomePost(dictionary: dict)
                    self.post_media.append(value)
                }
        }
        self.review_cashback = 0
        if !(dictionary["review_cashback"] is NSNull) {
            if  let value = dictionary["review_cashback"] as? Int {
                self.review_cashback = Float(value)
            }else if  let value = dictionary["review_cashback"] as? Float {
                self.review_cashback = value
            }else {
                let balance = dictionary["review_cashback"] as! String == "" ? "0" : dictionary["review_cashback"] as! String
                if let value = NumberFormatter().number(from: balance) {
                    self.review_cashback = Float(truncating: value)
                }
            }
        }
        
        self.reg_email_id = dictionary["reg_email_id"] as? String ?? ""
    }
}
