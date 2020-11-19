//  Created by Navpreet on 17/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.

import Foundation

struct UnitsSold {
    var product_id: Int
    var variant_id: Int
    var product_name: String
    var units_sold: Int
    var product_image: String
    var ranking: Int
    var statusValue : product_status
    var status_description : String
    var qtyCount :Int
    var status : Int
    
    init(dictionary: NSDictionary) {
        self.product_id = 0
        if !(dictionary["product_id"] is NSNull) {
            if  let value = dictionary["product_id"] as? Int {
                self.product_id = value
            }else {
                self.product_id = Int(dictionary["product_id"] as? String ?? "0")!
            }
        }
        self.variant_id = 0
        if !(dictionary["variant_id"] is NSNull) {
            if  let value = dictionary["variant_id"] as? Int {
                self.variant_id = value
            }else {
                self.variant_id = Int(dictionary["variant_id"] as? String ?? "0")!
            }
        }
        self.product_name = ""
        if !(dictionary["product_name"] is NSNull) {
            self.product_name = dictionary["product_name"] as? String ?? ""
        }
        self.units_sold = 0
        if !(dictionary["units_sold"] is NSNull) {
            if  let value = dictionary["units_sold"] as? Int {
                self.units_sold = value
            }else {
                self.units_sold = Int(dictionary["units_sold"] as? String ?? "0")!
            }
        }
        self.product_image = ""
        if !(dictionary["product_image"] is NSNull) {
            self.product_image = dictionary["product_image"] as? String ?? ""
        }
        self.ranking = 0
        if !(dictionary["ranking"] is NSNull) {
            if  let value = dictionary["ranking"] as? Int {
                self.ranking = value
            }else {
                self.ranking = Int(dictionary["ranking"] as? String ?? "0")!
            }
        }
        
        //For product status
        if let value  = dictionary["status"] {
            self.status = value as? Int ?? -1
        }else {
            self.status = -1
        }
        
        let value = product_status.init(rawValue: self.status)
        var status_Str = ""
        self.qtyCount = 0
         if !(dictionary["qty"] is NSNull) {
            if let value  = dictionary["qty"] {
                self.qtyCount = value as! Int
            }else {
                self.qtyCount = 0
            }
        }
        if (value == .active) {
            if self.qtyCount > 0 {
                status_Str = ""
            }else {
                status_Str = "sold out"
            }
        }else if value == .deleted {
            status_Str = "Not Available"
        }else if value == .inactive {
            status_Str = "Not Available"
        }else if value == .disapprove {
            status_Str = "Not Available"
        }else if value == .inreview {
            status_Str = "Not Available"
        }else if value == .draft {
            status_Str = "Not Available"
        }else {
            status_Str = "Not Available"
        }
        self.status_description = status_Str
        self.statusValue = value!
    }
}
