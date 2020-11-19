//  Created by Krishna_Mac_6 on 09/10/17.
//  Copyright © 2017 Krishna_Mac_6. All rights reserved.

import Foundation

struct Login {
    var email : String
    var fullname : String
    var id : Int
    var registered_mobile : String
    var registered_mobile_area_code : String
    var access_token: String
    var username: String
    var has_username: Bool
    var is_brand: Bool
    var profile_status : String
    var gender : Int
    var dob : String
    var profile_image : String
    var level : String
    var followers : String
    var followings : String
    var posts : String
    var unreadmessages : Int
    var social_id : String
    var total_cart_items : Int

    func saveToKeychain() -> Bool {
        let saveEmail = KeychainWrapper.standard.set(email, forKey:"email")
        let saveFullname = KeychainWrapper.standard.set(fullname, forKey:"fullname")
        let saveId = KeychainWrapper.standard.set(id, forKey:"id")
        let saveRegistered_mobile = KeychainWrapper.standard.set(registered_mobile, forKey: "registered_mobile")
        let saveRegistered_mobile_area_code = KeychainWrapper.standard.set(registered_mobile_area_code, forKey:"registered_mobile_area_code")
        let saveAccess_token = KeychainWrapper.standard.set(access_token, forKey:"access_token")
        let saveUsername = KeychainWrapper.standard.set("@"+username, forKey:"username")
        let saveHas_username = KeychainWrapper.standard.set(has_username, forKey:"has_username")
        let saveis_brand = KeychainWrapper.standard.set(is_brand, forKey:"is_brand")
        
        let saveprofile_status = KeychainWrapper.standard.set(profile_status, forKey:"profile_status")
        let savedob = KeychainWrapper.standard.set(dob, forKey:"dob")
        let saveprofile_image = KeychainWrapper.standard.set(profile_image, forKey:"profile_image")
        let savegender = KeychainWrapper.standard.set(gender, forKey:"gender")
        let savelevel = KeychainWrapper.standard.set(level, forKey:"level")
        let savefollowers = KeychainWrapper.standard.set(followers, forKey:"followers")
        let savefollowings = KeychainWrapper.standard.set(followings, forKey:"followings")
        let saveposts = KeychainWrapper.standard.set(followings, forKey:"posts")
        let saveunreadmessages = KeychainWrapper.standard.set(gender, forKey:"unreadmessages")
        let savesocialId = KeychainWrapper.standard.set(social_id, forKey:"social_id")
        let save_total_cart_items = KeychainWrapper.standard.set(total_cart_items, forKey:"total_cart_items")

        return saveEmail && saveFullname && saveId && saveRegistered_mobile && saveRegistered_mobile_area_code && saveAccess_token && saveUsername && saveHas_username && saveis_brand && saveprofile_status && savedob && saveprofile_image && savegender && savelevel && savefollowers && savefollowings && saveposts && saveunreadmessages && savesocialId && save_total_cart_items
    }
    
    static func loadFromKeychain(registered_mobile_email:String) -> Login?{
        let email = KeychainWrapper.standard.string(forKey:"email") ?? ""
        let fullname = KeychainWrapper.standard.string(forKey: "fullname") ?? ""
        let id = KeychainWrapper.standard.integer(forKey: "id") ?? 0
        let registered_mobile = KeychainWrapper.standard.string(forKey: "registered_mobile") ?? ""
        let registered_mobile_area_code = KeychainWrapper.standard.string(forKey: "registered_mobile_area_code") ?? ""
        let access_token = KeychainWrapper.standard.string(forKey: "access_token") ?? ""
        let username = KeychainWrapper.standard.string(forKey: "username") ?? ""
        let has_username = KeychainWrapper.standard.bool(forKey: "has_username") ?? false
        let is_brand = KeychainWrapper.standard.bool(forKey: "is_brand") ?? false
        let profile_status = KeychainWrapper.standard.string(forKey: "profile_status") ?? ""
        let dob = KeychainWrapper.standard.string(forKey: "dob") ?? ""
        let profile_image = KeychainWrapper.standard.string(forKey: "profile_image") ?? ""
        let gender = KeychainWrapper.standard.integer(forKey: "gender") ?? 0
        let level = KeychainWrapper.standard.string(forKey: "level") ?? "0"
        let followers = KeychainWrapper.standard.string(forKey: "followers") ?? "0"
        let followings = KeychainWrapper.standard.string(forKey: "followings") ?? "0"
        let posts = KeychainWrapper.standard.string(forKey: "posts") ?? "0"
        let unreadmessages = KeychainWrapper.standard.integer(forKey: "unreadmessages") ?? 0
        let social_id = KeychainWrapper.standard.string(forKey: "social_id") ?? ""
        let save_total_cart_items = KeychainWrapper.standard.integer(forKey:"total_cart_items") ?? 0

        if registered_mobile_email.caseInsensitiveCompare(registered_mobile) == .orderedSame || registered_mobile_email.caseInsensitiveCompare(email) == .orderedSame {
            return Login(email: email, fullname: fullname, id: id, registered_mobile: registered_mobile, registered_mobile_area_code: registered_mobile_area_code, access_token: access_token, username: username, has_username: has_username, is_brand: is_brand, profile_status: profile_status, gender: gender, dob: dob, profile_image: profile_image, level: level, followers: followers, followings: followings, posts: posts, unreadmessages: unreadmessages, social_id: social_id, total_cart_items: save_total_cart_items)
        }
        return nil
    }
    
    static func loadCustomerInfoFromKeychain() -> Login?{
        let email = KeychainWrapper.standard.string(forKey:"email") ?? ""
        let fullname = KeychainWrapper.standard.string(forKey: "fullname") ?? ""
        let id = KeychainWrapper.standard.integer(forKey: "id") ?? 0
        let registered_mobile = KeychainWrapper.standard.string(forKey: "registered_mobile") ?? ""
        let registered_mobile_area_code = KeychainWrapper.standard.string(forKey: "registered_mobile_area_code") ?? ""
        let access_token = KeychainWrapper.standard.string(forKey: "access_token") ?? ""
        let username = KeychainWrapper.standard.string(forKey: "username") ?? ""
        let has_username = KeychainWrapper.standard.bool(forKey: "has_username") ?? false
        let is_brand = KeychainWrapper.standard.bool(forKey: "is_brand") ?? false
        let profile_status = KeychainWrapper.standard.string(forKey: "profile_status") ?? ""
        let dob = KeychainWrapper.standard.string(forKey: "dob") ?? ""
        let profile_image = KeychainWrapper.standard.string(forKey: "profile_image") ?? ""
        let gender = KeychainWrapper.standard.integer(forKey: "gender") ?? 0
        let level = KeychainWrapper.standard.string(forKey: "level") ?? "0"
        let followers = KeychainWrapper.standard.string(forKey: "followers") ?? "0"
        let followings = KeychainWrapper.standard.string(forKey: "followings") ?? "0"
        let posts = KeychainWrapper.standard.string(forKey: "posts") ?? "0"
        let unreadmessages = KeychainWrapper.standard.integer(forKey: "unreadmessages") ?? 0
        let social_id = KeychainWrapper.standard.string(forKey: "social_id") ?? ""
        let total_cart_items = KeychainWrapper.standard.integer(forKey: "total_cart_items") ?? 0

        return Login(email: email, fullname: fullname, id: id, registered_mobile: registered_mobile, registered_mobile_area_code: registered_mobile_area_code, access_token: access_token, username: username, has_username: has_username, is_brand: is_brand, profile_status: profile_status, gender: gender, dob: dob, profile_image: profile_image, level: level, followers: followers, followings: followings, posts: posts, unreadmessages: unreadmessages, social_id: social_id, total_cart_items: total_cart_items)
    }
    
    func updateTotalItemCount(count: Int) -> Bool  {
        KeychainWrapper.standard.removeObject(forKey: "total_cart_items")
        let save = KeychainWrapper.standard.set(count, forKey: "total_cart_items")
        return save
    }
}

