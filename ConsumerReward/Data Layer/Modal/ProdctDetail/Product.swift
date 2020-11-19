//
//  Product.swift
//  Brand
//
//  Created by apple on 29/08/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation

enum product_status: Int {
    case deleted = -1
    case draft = 0
    case inreview = 1
    case active = 2
    case inactive = 3
    case disapprove = 4
}


struct Product{
    
    var product_id: String
    var set_attributes: String
    var name: String
    var sku: String
    var price: String
    var hc_code: String
    var upc: String
    var gtin :String
    var description :String
    var final_price: String
    var productImage: String
    var product_images : [ProductImages]
    var other_images : [ProductImages]
    var all_image : [ProductImages]
    var variant_id: String

    var weight_type :String
    var length_type :String
    var width_type :String
    var height_type :String
    var created_on :String
    
    var qty :String
    var qtyCount :Int

    var weight : String
    var length :String
    var width : String
    var height : String
    var status_description : String
    var status : Int
    var statusValue : product_status

    var bought: String
    var brand: BrandBasicInfo
    var sellerName: String
    var product_type :String
    
    var is_selected: Bool
    var color_name: String
    var color_type_image :Bool
    var color_image: String
    var color_code :String

    //Added by NAV
    var productDeliveryDate : String
    var currency :String

    var total_love :String
    //Added by Sanjeev
    var isAddedToWishlist: Bool
    
    init(dictionary: NSDictionary) {
        if let value  = dictionary["product_id"] {
            self.product_id = "\(String(describing: value))"
        } else if let value  = dictionary["id"] {
            self.product_id = "\(String(describing: value))"
        }else {
            self.product_id = ""
        }
        
        if let value  = dictionary["set_attributes"]
        {
            self.set_attributes = "\(String(describing: value))"
        }
        else{
            self.set_attributes = ""
        }
        
        self.name = dictionary["name"] as? String ?? ""
        self.sku = dictionary["sku"] as? String ?? ""
//        self.price = dictionary["price"] as? String ?? ""
//        self.final_price = dictionary["customer_final_price"] as? String ?? ""

        if let value  = dictionary["price"]
        {
            self.price = "\(String(describing: value))"
        }
        else{
            self.price = ""
        }

        if let value  = dictionary["customer_final_price"]
        {
            self.final_price = "\(String(describing: value))"
        }
        else{
            self.final_price = ""
        }

        if self.price == self.final_price
        {
            self.price = ""
        }
        
        self.hc_code = dictionary["hc_code"] as? String ?? ""
        self.upc = dictionary["upc"] as? String ?? ""
        self.gtin = dictionary["gtin"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.weight_type = dictionary["weight_type"] as? String ?? ""
        self.created_on = dictionary["created_on"] as? String ?? ""
        self.length_type = dictionary["length_type"] as? String ?? ""
        self.width_type = dictionary["width_type"] as? String ?? ""
        self.height_type = dictionary["height_type"] as? String ?? ""
    
        if let value  = dictionary["qty"]
        {
            self.qty = "\(String(describing: value))"
            self.qtyCount = value as? Int ?? 0
        }
        else{
            self.qty = ""
            self.qtyCount = 0
        }
        
        if let value  = dictionary["product_type"]
        {
            self.product_type = "\(String(describing: value))"
        }
        else{
            self.product_type = ""
        }

        if let value  = dictionary["weight"]
        {
            self.weight = "\(String(describing: value))"
        }
        else{
            self.weight = ""
        }
        if let value  = dictionary["length"]
        {
            self.length = "\(String(describing: value))"
        }
        else{
            self.length = ""
        }
        if let value  = dictionary["width"]
        {
            self.width = "\(String(describing: value))"
        }
        else{
            self.width = ""
        }
        if let value  = dictionary["height"]
        {
            self.height = "\(String(describing: value))"
        }
        else{
            self.height = ""
        }
       

        let images = dictionary["images"] as?  NSDictionary ?? ["thumbnail":""]
        self.productImage = images["thumbnail"] as? String ?? ""
        
        self.product_images  = []
        self.other_images  = []
        self.all_image = []

        self.product_images.removeAll()
        self.other_images.removeAll()
        self.all_image.removeAll()

        if let data = dictionary["images"]
        {
            let value = ProductImages(dictionary: data as! NSDictionary)
            self.product_images.append(value)
        }
        
        if let data = dictionary["other_images"] as? [NSDictionary]
        {
            for dict in data {
                let value = ProductImages(dictionary: dict )
                self.other_images.append(value)
            }
        }
        
        self.all_image  = self.product_images + other_images
        
        let completed_orders = dictionary["completed_orders"] as?  NSDictionary ?? ["total":"0"]
        if let value  = completed_orders["total"]
        {
            self.bought = "\(String(describing: value))"
        }
        else{
            self.bought = "0"
        }
        
        let brand_dict = dictionary["brand"] as? NSDictionary ?? ["id":"0"]
        self.brand = BrandBasicInfo(dictionary: brand_dict)
        self.sellerName =  self.brand.display_name
        
        //Added by NAV
        self.productDeliveryDate = dictionary["productDeliveryDate"] as? String ?? ""
        self.currency = dictionary["currency"] as? String ?? "$"
        
        if let value  = dictionary["variant_id"]
        {
            self.variant_id = "\(String(describing: value))"
        }
        else{
            self.variant_id = ""
        }
        
        self.is_selected = dictionary["is_selected"] as? Bool ?? false
        self.color_name = dictionary["color_name"] as? String ?? "n/a"
        self.color_type_image = dictionary["color_type_image"] as? Bool ?? false
        self.color_image = dictionary["color_image"] as? String ?? ""
        self.color_code = dictionary["color_code"] as? String ?? ""

        self.total_love = dictionary["total_love"] as? String ?? ""
        
        let wishlist = dictionary["in_wishlist"] as?  NSDictionary ?? ["status":false]
        if let value  = wishlist["status"] {
            self.isAddedToWishlist = value as! Bool
        }else  {
            self.isAddedToWishlist = false
        }
        
        if let love  = dictionary["total_love"]
        {
            self.total_love  = "\(String(describing: love))"
        }else{
            self.total_love = ""
            
        }
        
        if let value  = dictionary["status"]
        {
            self.status = value as? Int ?? -1
        }
        else{
            self.status = -1
        }
        
        let value = product_status.init(rawValue: self.status)

        var status_Str = ""
        
        if (value == .active)
        {
            if self.qtyCount > 0
            {
                status_Str = ""
            }
            else
            {
                status_Str = "sold out"
            }
        }
        else if value == .deleted
        {
            status_Str = "Not Available"
        }
        else if value == .inactive
        {
            status_Str = "Not Available"
        }
        else if value == .disapprove
        {
            status_Str = "Not Available"
        }
        else if value == .inreview
        {
            status_Str = "Not Available"
        }
        else if value == .draft
        {
            status_Str = "Not Available"
        }
        else{
            status_Str = "Not Available"
        }
        self.status_description = status_Str
        self.statusValue = value!
    }
}

