//
//  ProductDetails.swift
//  ConsumerReward
//
//  Created by apple on 14/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import Foundation
struct PurchaseDetails {
    var product_id: String
    var product_name: String
    var image: ProductImages
    var qty: String
    var color: String
    var final_price: String
    var fk_accountid: String
    var rating: String
    var seller_name: String
    var tracking_id: String
    var variant_id: String
    
    // self added by Nav
    var currency: String

    init(dictionary: NSDictionary)
    {
        
        if let value  = dictionary["product_id"]
        {
            self.product_id = "\(String(describing: value))"
        }
        else{
            self.product_id = ""
        }
        if let value  = dictionary["tracking_id"]
        {
            self.tracking_id = "\(String(describing: value))"
        }
        else{
            self.tracking_id = ""
        }
        if let value  = dictionary["variant_id"]
        {
            self.variant_id = "\(String(describing: value))"
        }
        else{
            self.variant_id = ""
        }

        if let value  = dictionary["customer_final_price"]
        {
            self.final_price = "\(String(describing: value))"
        }
        else{
            self.final_price = ""
        }
        if let value  = dictionary["fk_accountid"]
        {
            self.fk_accountid = "\(String(describing: value))"
        }
        else{
            self.fk_accountid = ""
        }
        if let value  = dictionary["qty"]
        {
            self.qty = "\(String(describing: value))"
        }
        else{
            self.qty = ""
        }
        
        let data = dictionary["images"] as?  NSDictionary ?? ["thumbnail":""]
        self.image = ProductImages(dictionary: data )
        
        self.product_name = dictionary["product_name"] as? String ?? ""
        self.color = dictionary["color"] as? String ?? ""
        self.rating = dictionary["rating"] as? String ?? ""
        self.seller_name = dictionary["seller_name"] as? String ?? ""
        self.currency = dictionary["currency"] as? String ?? "$"
    }
}
