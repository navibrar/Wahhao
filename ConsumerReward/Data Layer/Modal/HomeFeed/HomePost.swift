//
//  HomeFeed.swift
//  Brand
//
//  Created by apple on 29/08/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation

struct HomePost{
    
    var id: String
    var fk_accountid: String
    var post_type : Int
    var caption: String
    var asset_type: String
    var brand: BrandBasicInfo
    var product: Cart
    var isLiked : Bool
    var isViewed : Bool
    var viewCount : String
    var likesCount :String
    var type :String
    var showSellerProfile : Bool

    var imageURL :String
    var videoURL : String
    
    var consumer_profile_id : String
    let consumer_username : String
    let consumer_profile_status : String
    let consumer_media : String

    var isShoppable : Bool
    
    var resolutionWidth : Float
    var resolutionHeight : Float

    var rating: String
    var review: String
    var created_at :String
    //Changes made by: Sanjeev
    var totalCashback: String
    //var totalLikes: String
    var postRanking: String

    init(dictionary: NSDictionary)
    {
        self.post_type = dictionary["post_type"] as? Int ?? 2
        self.asset_type = dictionary["asset_type"] as? String ?? ""
        
        let brand_dict = dictionary["brand"] as? NSDictionary ?? ["id":"0"]
        self.brand = BrandBasicInfo(dictionary: brand_dict)
        
        let product_dict = dictionary["product"] as? NSDictionary ?? ["id":"0"]
        self.product = Cart(dictionary: product_dict)
        
        let likedDict = dictionary["is_liked"] as? NSDictionary ?? ["status":0]
        if let value  = likedDict["status"]
        {
            let like = value
            self.isLiked = like as? Bool ?? false
        }
        else{
            self.isLiked = false
        }
        
        let viewedDict = dictionary["is_viewed"] as? NSDictionary ?? ["status":0]
        if let value  = viewedDict["status"]
        {
            self.isViewed = (value as? Bool) ?? false
        }
        else{
            self.isViewed = false
        }
        
        let views_dict = dictionary["views"] as? NSDictionary ?? ["total":"0"]
        
        if let value  = views_dict["total"]
        {
            self.viewCount = "\(String(describing: value))"
        }
        else{
            self.viewCount = "0"
        }
        
        let likes_dict = dictionary["likes"] as? NSDictionary ?? ["total":"0"]
        
        if let value  = likes_dict["total"]
        {
            self.likesCount = "\(String(describing: value))"
        }
        else{
            self.likesCount = "0"
        }
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.isShoppable = dictionary["is_shoppable"] as? Bool ?? true
        self.videoURL = ""
        self.imageURL = ""
        let captionStr = dictionary["caption"] as? String ?? ""
        let decoderString = captionStr.utf8DecodedString()
        self.caption = decoderString
        
        self.showSellerProfile = dictionary["is_seller"] as? Bool ?? false
        
        let post_media = dictionary["post_media"] as?  NSDictionary ?? ["media":"","media_thumbnail":"","width":365,"height":812]
        
        if self.post_type == 1
        {
            self.type = "Image"
        }
        else{
            self.type = "Video"
        }
        
        if self.type == "Image"
        {
            self.imageURL = post_media["media"] as? String ?? ""
        }
        else{
            self.imageURL = post_media["media_thumbnail"] as? String ?? ""
            self.videoURL =   post_media["media"] as? String ?? ""
        }
        
        let resolution_width  = post_media["width"]
        let resolution_height  = post_media["height"]
        
        self.resolutionWidth = Float(resolution_width as? Int ?? 0)
        self.resolutionHeight = Float(resolution_height as? Int ?? 0)
        
        if let idValue  = dictionary["post_id"]
        {
            self.id = "\(String(describing: idValue))"
        }
        else{
            self.id = ""
        }
        if let idValue  = dictionary["fk_accountid"]
        {
            self.fk_accountid = "\(String(describing: idValue))"
        }
        else{
            self.fk_accountid = ""
        }
        
        //CONSUMER DATA FOR REVIEW POST
        let consumer_dict = dictionary["consumer"] as? NSDictionary ?? ["port_accountid":"0"]
        if let value  = consumer_dict["port_accountid"]
        {
            self.consumer_profile_id = "\(String(describing: value))"
        }
        else{
            self.consumer_profile_id = "0"
        }
        self.consumer_username = consumer_dict["username"] as? String ?? ""
        self.consumer_profile_status = consumer_dict["profile_status"] as? String ?? ""
        let consumer_dict_media = consumer_dict["user_media"] as? NSDictionary ?? ["media":""]
        self.consumer_media = consumer_dict_media["media"] as? String ?? ""
        
        //REVIEWS RATING FROM PRODUCT DETAIL
        if let value  = dictionary["rating"]
        {
            self.rating = "\(String(describing: value))"
        }
        else{
            self.rating = ""
        }
        self.review = dictionary["review"] as? String ?? ""
        self.created_at = dictionary["created_at"] as? String ?? ""
        //By Sanjeev
        self.totalCashback = "0"
        if let value  = dictionary["total_cash"] {
            if !(value is NSNull) {
                self.totalCashback = "\(String(describing: value))"
            }
        }
        /*self.totalLikes = "0"
        if let value  = dictionary["total_likes"] {
            if !(value is NSNull) {
                self.totalLikes = "\(String(describing: value))"
            }
        }*/
        self.postRanking = "0"
        if let value  = dictionary["ranking"] {
            if !(value is NSNull) {
                self.postRanking = "\(String(describing: value))"
            }
        }
    }
}
