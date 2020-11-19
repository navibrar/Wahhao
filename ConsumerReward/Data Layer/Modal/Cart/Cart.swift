//
//  CartHomePost.swift
//  Brand
//
//  Created by apple on 29/08/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation


struct Cart{
    var id: String
    var user_id: String
    var product_id: String
    var modified_at: String
    var created_at: String
    var quantity : String
    var quantityCount : Int
    var variant_id : String
    var product: Product

    init(dictionary: NSDictionary)
    {
        if let value  = dictionary["id"]
        {
            self.id = "\(String(describing: value))"
        }
        else{
            self.id = ""
        }
        
        if let value  = dictionary["user_id"]
        {
            self.user_id = "\(String(describing: value))"
        }
        else{
            self.user_id = ""
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

        if let value  = dictionary["quantity"]
        {
            self.quantity = "\(String(describing: value))"
            self.quantityCount = value as! Int
        }
        else{
            self.quantity = ""
            self.quantityCount = 0
        }

        self.modified_at = dictionary["modified_at"] as? String ?? ""
        self.created_at = dictionary["created_at"] as? String ?? ""
        
        if let _ = dictionary["product"] {
            let product_dict = dictionary["product"] as? NSDictionary ?? ["id":"0"]
            self.product = Product(dictionary: product_dict)
        }else if let _ = dictionary["detail"] {
            let product_dict = dictionary["detail"] as? NSDictionary ?? ["id":"0"]
            self.product = Product(dictionary: product_dict)
        }else {
            let product_dict = ["id":"0"]
            self.product = Product(dictionary: product_dict as NSDictionary)
        }
    }
}
