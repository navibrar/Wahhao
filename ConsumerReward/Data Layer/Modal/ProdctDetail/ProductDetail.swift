//
//  Product.swift
//  Brand
//
//  Created by apple on 29/08/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation


struct ProductDetail{
    
    var all_variants : [Product]
    var relatedProducts : [Product]
    var reviews : [HomePost]
    var rating : String
    var total_reviews : String

    init(dictionary: NSDictionary) {
        self.all_variants = []
        if let data = dictionary["all_variants"] as? [NSDictionary]
        {
            self.all_variants.removeAll()
            for dict in data {
                let value = Product(dictionary: dict)
                self.all_variants.append(value)
            }
        }
        
        self.relatedProducts = []
        if let data = dictionary["related_products"] as? [NSDictionary]
        {
            self.relatedProducts.removeAll()
            for dict in data {
                let value = Product(dictionary: dict)
                self.relatedProducts.append(value)
            }
        }
        
        self.reviews = []
        if let data = dictionary["reviews"] as? [NSDictionary]
        {
            self.reviews.removeAll()
            for dict in data {
                let value = HomePost(dictionary: dict)
                self.reviews.append(value)
            }
        }
        
        let ratingsData = dictionary["ratings"] as? NSDictionary ?? ["rating":"0","total_reviews":"0"]
        if let value  = ratingsData["rating"]
        {
            self.rating = "\(String(describing: value))"
        }
        else{
            self.rating = "0"
        }
        if let value  = ratingsData["total_reviews"]
        {
            self.total_reviews = "\(String(describing: value))"
        }
        else{
            self.total_reviews = "0"
        }

        
    }
}
