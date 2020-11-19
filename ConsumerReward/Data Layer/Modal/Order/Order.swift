//
//  Orders.swift
//  ConsumerReward
//
//  Created by apple on 14/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import Foundation
struct Order {
    
    var id: String
    var order_id: String
    var product_id: String
    var image: String
    var Product_Name: String
    var seller_name: String
    var order_Status: String
    var expected_delivery_date :String
    var order_Status_id :String
    var Price :String
    var customer_final_price :String
    var variant_id :String
    var media_type :String
    var isSelected: Bool
    var currency: String
    var rating_info: String
    var color: String
    var is_video_review: Bool
    
    init(dictionary: NSDictionary)
    {
        if let value  = dictionary["id"]
        {
            self.id = "\(String(describing: value))"
        }
        else{
            self.id = ""
        }
        
        if let value  = dictionary["order_id"]
        {
            self.order_id = "\(String(describing: value))"
        }
        else{
            self.order_id = ""
        }
        
        if let value  = dictionary["product_id"]
        {
            self.product_id = "\(String(describing: value))"
        }
        else{
            self.product_id = ""
        }
        
        if let value  = dictionary["variant_id"]
        {
            self.variant_id = "\(String(describing: value))"
        }
        else{
            self.variant_id = ""
        }
        
        
        if let value  = dictionary["status"]
        {
            self.order_Status_id = "\(String(describing: value))"
        }
        else{
            self.order_Status_id = ""
        }
        
        if let value  = dictionary["status"]
        {
            self.order_Status = "\(String(describing: value))"
        }
        else{
            self.order_Status = ""
        }
        if order_Status_id == "0" {
            self.order_Status = "Canceled"
        } else if order_Status_id == "1" {
            self.order_Status = "Pending"
        } else if order_Status_id == "2" {
            self.order_Status = "confirmed"
        } else if order_Status_id == "3" {
            self.order_Status = "preparing order"
        } else if order_Status_id == "4" {
            self.order_Status = "shipped"
        } else if order_Status_id == "5" {
            self.order_Status = "delivered"
        } else if order_Status_id == "6" {
            self.order_Status = "Completed"
        } else if order_Status_id == "7" {
            self.order_Status = "Returned"
        } else {
            self.order_Status = "Returned"
        }
        
       if let value  = dictionary["product_name"] {
            self.Product_Name = "\(String(describing: value))"
        }else {
            self.Product_Name = ""
        }

        self.seller_name = dictionary["seller_name"] as? String ?? ""
       
        self.expected_delivery_date = dictionary["expected_delivery_date"] as? String ?? ""
       
        self.Price = dictionary["price"] as? String ?? ""
        self.customer_final_price = dictionary["customer_final_price"] as? String ?? ""
        
        let views_dict = dictionary["images"] as? NSDictionary ?? ["thumbnail":""]
        
        if let value  = views_dict["thumbnail"] {
            self.image = value as! String
        } else{
            self.image = ""
        }
        
        if let value1  = views_dict["media_type"] {
            self.media_type = value1 as! String
        } else{
            self.media_type = ""
        }
        
        self.currency = dictionary["currency"] as? String ?? "$"
        
         self.is_video_review  = dictionary["is_video_review"] as? Bool ?? false
         self.rating_info =  dictionary["rating"] as? String ?? ""
         self.isSelected = false
         self.color = dictionary["color"] as? String ?? ""
    }
}
