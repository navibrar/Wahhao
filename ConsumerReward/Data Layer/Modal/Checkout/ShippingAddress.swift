//  Created by Navpreet on 18/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import Foundation

struct ShippingAddress {
    var id: Int
    var user_id: Int
    var full_name: String
    var address1: String
    var address2: String
    var zipcode: Int
    var city: String
    var province: String
    var address_type: String
    var country: String
    var isSelected: Bool
    var phone: String
    var isTitleDisplayed: Bool
    
    init(dictionary: NSDictionary) {
        if  let value = dictionary["id"] as? Int {
            self.id = value
        }else {
            self.id = Int(dictionary["id"] as! String == "" ? "0" : dictionary["id"] as! String)!
        }
        
        if  let value = dictionary["user_id"] as? Int {
            self.user_id = value
        }else {
            self.user_id = Int(dictionary["user_id"] as! String == "" ? "0" : dictionary["user_id"] as! String)!
        }
        
        self.full_name = dictionary["full_name"] as? String ?? ""
        self.address1 = dictionary["address1"] as? String ?? ""
        self.address2 = dictionary["address2"] as? String ?? ""
        
        if  let value = dictionary["zipcode"] as? Int {
            self.zipcode = value
        }else {
            self.zipcode = Int(dictionary["zipcode"] as! String == "" ? "0" : dictionary["zipcode"] as! String)!
        }
        
        self.city = dictionary["city"] as? String ?? ""
        self.province = dictionary["province"] as? String ?? ""
        self.address_type = dictionary["address_type"] as? String ?? ""
        self.country = dictionary["country"] as? String ?? ""
        self.isSelected = dictionary["isSelected"] as? Bool ?? false
        
        if  let _ = dictionary["phone"] {
            self.phone = "\(dictionary["phone"] ?? "")"
        }else {
            self.phone = ""
        }
        self.isTitleDisplayed = false
    }
}
