//
//  BrandBasicInfo.swift
//  Brand
//
//  Created by apple on 29/08/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation


struct BrandBasicInfo{
    var id: String
    var brand_id: String

    var display_name: String
    var username: String
    var details_bio: String
    var about_us_desc: String
    var regst_reg_country_code :String
    var regst_reg_mobile_no :String
    var regst_reg_email_id :String
    var regst_company_name :String
    var profile_status :String
    var record_status :String
    var created_on :String
    var created_by :String
    var modified_on : String
    var modified_by :String
    var resource_id : String
    var brandImage : String
    
    //FROM SELLER PROFILE API
    var is_active : Bool
    var username_already_set : Bool
    var share_url : String
    var rating : String
    var followers : String
    var following : String
    var active_products : String    
    var bought: String

    //Follow/Unfollow
    var is_following: Bool
    var following_id : String
    var follow_user_id : String
    var displayName: String{
        get{
            return display_name
        }
    }
    
    init(dictionary: NSDictionary)
    {
        if let value  = dictionary["id"]
        {
            self.id = "\(String(describing: value))"
        }
        else{
            self.id = ""
        }
        
        if let value  = dictionary["record_status"]
        {
            self.record_status = "\(String(describing: value))"
        }
        else{
            self.record_status = ""
        }
        if let value  = dictionary["profile_status"]
        {
            self.profile_status = "\(String(describing: value))"
        }
        else{
            self.profile_status = ""
        }
        if let value  = dictionary["fk_accountid"]
        {
            self.brand_id = "\(String(describing: value))"
        }
        else{
            self.brand_id = ""
        }
        
        self.display_name = dictionary["display_name"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.details_bio = dictionary["details_bio"] as? String ?? ""
        self.about_us_desc = dictionary["about_us_desc"] as? String ?? ""
        self.regst_reg_country_code = dictionary["regst_reg_country_code"] as? String ?? ""
        self.regst_reg_mobile_no = dictionary["regst_reg_mobile_no"] as? String ?? ""
        self.regst_reg_email_id = dictionary["regst_reg_email_id"] as? String ?? ""
        self.regst_company_name = dictionary["regst_company_name"] as? String ?? ""
        self.created_on = dictionary["created_on"] as? String ?? ""
        self.created_by = dictionary["created_by"] as? String ?? ""
        self.modified_on = dictionary["modified_on"] as? String ?? ""
        self.modified_by = dictionary["modified_by"] as? String ?? ""
        self.resource_id = ""
        self.brandImage = ""
        
        let profile_image_data = dictionary["brand_image"] as? NSDictionary ?? ["media":""]
        self.brandImage = profile_image_data["media"] as? String ?? ""
                
        if let value  =  profile_image_data["resource_id"]
        {
            self.resource_id = "\(String(describing: value))"
        }
        
        //FROM SELLER PROFILE API
        self.is_active = dictionary["is_active"] as? Bool ?? false
        self.username_already_set  = dictionary["username_already_set"] as? Bool ?? false
        self.share_url = dictionary["share_url"] as? String ?? ""
        self.rating  = dictionary["rating"] as? String ?? "0"
        self.followers  = "0"
        self.following  = "0"
        self.active_products  = "0"
        
        if let value  =  dictionary["followers"]
        {
            self.followers = "\(String(describing: value))"
        }
        if let value  =  dictionary["following"]
        {
            self.following = "\(String(describing: value))"
        }
        if let value  =  dictionary["active_products"]
        {
            self.active_products = "\(String(describing: value))"
        }
        let following_dict = dictionary["is_following"] as? NSDictionary ?? ["status":0]
        self.is_following = following_dict["status"] as? Bool ?? false
        if let value  = following_dict["id"]
        {
            self.following_id = "\(String(describing: value))"
        }
        else{
            self.following_id = ""
        }
        
        if let value  = following_dict["user_id"]
        {
            self.follow_user_id = "\(String(describing: value))"
        }
        else{
            self.follow_user_id = ""
        }
        
//        let completed_orders = dictionary["completed_orders"] as?  NSDictionary ?? ["total":"0"]
        if let value  = dictionary["sold_products"]
        {
            self.bought = "\(String(describing: value))"
        }
        else{
            self.bought = "0"
        }
        

    }
}
