//  Created by Navpreet on 18/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import Foundation
import UIKit

struct CardDetail {
    
    var card_id: String
    var stripe_customer_id: String
    var brand: String
    var card_type: String
    var last4digits: String
    var exp_month: String
    var exp_year: String
    var isSelected: Bool
    var isSavedForFasterPurchase: Bool
    
    init(dictionary: NSDictionary) {
        self.card_id = ""
        if !(dictionary["card_id"] is NSNull) {
            self.card_id = dictionary["card_id"] as? String ?? ""
        }
        self.stripe_customer_id = ""
        if !(dictionary["stripe_customer_id"] is NSNull) {
            self.stripe_customer_id = dictionary["stripe_customer_id"] as? String ?? ""
        }
        self.brand = ""
        if !(dictionary["brand"] is NSNull) {
            self.brand = dictionary["brand"] as? String ?? ""
        }
        self.card_type = ""
        if !(dictionary["card_type"] is NSNull) {
            self.card_type = dictionary["card_type"] as? String ?? ""
        }
        self.last4digits = ""
        if !(dictionary["last4digits"] is NSNull) {
            if  let value = dictionary["last4digits"] as? Int {
                self.last4digits = String(value)
            }else {
                self.last4digits = dictionary["last4digits"] as? String ?? ""
            }
        }
        self.exp_month = ""
        if !(dictionary["exp_month"] is NSNull) {
            if  let value = dictionary["exp_month"] as? Int {
                self.exp_month = String(value)
            }else {
                self.exp_month = dictionary["exp_month"] as? String ?? ""
            }
        }
        self.exp_year = ""
        if !(dictionary["exp_year"] is NSNull) {
            if  let value = dictionary["exp_year"] as? Int {
                self.exp_year = String(value)
            }else {
                self.exp_year = dictionary["exp_year"] as? String ?? ""
            }
        }
        self.isSavedForFasterPurchase = false
        if !(dictionary["save_type"] is NSNull) {
            self.isSavedForFasterPurchase = dictionary["save_type"] as? Bool ?? false
        }
        self.isSelected = dictionary["isSelected"] as? Bool ?? false
    }
}
