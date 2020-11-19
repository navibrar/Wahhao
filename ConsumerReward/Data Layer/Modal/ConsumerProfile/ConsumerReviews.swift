//  Created by Navpreet on 24/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import Foundation

struct ConsumerReviews {
   
    var created_at: String
    var fk_acc_prefix: String
    var fk_accountid: String
    var id: String
    var media: String
    var media_thumbnail: String
    var product_id: String
    var rating: String
    var review: String
    var status: String
    var review_type: String
    var type: String
    
    init(dictionary: NSDictionary)  {
        
        self.created_at = dictionary["created_at"] as? String ?? ""
        
        if let value  = dictionary["fk_acc_prefix"]
        {
            self.fk_acc_prefix = "\(String(describing: value))"
        }
        else{
            self.fk_acc_prefix = ""
        }
        
        if let value  = dictionary["fk_accountid"]
        {
            self.fk_accountid = "\(String(describing: value))"
        }
        else{
            self.fk_accountid = ""
        }
        
        if let value  = dictionary["id"]
        {
            self.id = "\(String(describing: value))"
        }
        else{
            self.id = ""
        }
        
        if let value  = dictionary["product_id"]
        {
            self.product_id = "\(String(describing: value))"
        }
        else{
            self.product_id = ""
        }
        
        
        if let value  = dictionary["rating"]
        {
            self.rating = "\(String(describing: value))"
        }
        else{
            self.rating = ""
        }
        
        if let value  = dictionary["review_type"]
        {
            self.review_type = "\(String(describing: value))"
        }
        else{
            self.review_type = ""
        }
        
        if let value  = dictionary["status"]
        {
            self.status = "\(String(describing: value))"
        }
        else{
            self.status = ""
        }
        
         self.media = dictionary["media"] as? String ?? ""
         self.media_thumbnail = dictionary["media_thumbnail"] as? String ?? ""
         self.review = dictionary["review"] as? String ?? ""
         self.type = dictionary["type"] as? String ?? ""
    }
}
