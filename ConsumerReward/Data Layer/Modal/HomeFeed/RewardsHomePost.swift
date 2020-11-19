//
//  RewardsHomePost.swift
//  Brand
//
//  Created by apple on 29/08/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation


struct RewardsHomePost{
    var id: String
    var price: String

    init(dictionary: NSDictionary)
    {
        if let value  = dictionary["id"]
        {
            self.id = "\(String(describing: value))"
        }
        else{
            self.id = ""
        }
        self.price = dictionary["price"] as? String ?? ""
    }
}
