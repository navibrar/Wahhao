//
//  Category.swift
//  BuyDirect
//
//  Created by administrator on 11/01/18.
//  Copyright © 2018 Nvish. All rights reserved.
//

import Foundation


struct ShopMore {
    
    let name : String
    let category_code : String
    var record_per_page : Int
    var total_feeds : Int
    var feeds : [HomePost]

    var displayName: String{
        get{
            return name
        }
    }
    
    init(dictionary: NSDictionary){
        self.name = dictionary["category_name"] as? String ?? "n/a"
//        self.category_code = dictionary["category_code"] as? String ?? ""

        self.total_feeds = dictionary["total_feeds"] as? Int ?? 0
        self.record_per_page = dictionary["record_per_page"] as? Int ?? 0

        if let value  = dictionary["category_code"]
        {
            self.category_code = "\(String(describing: value))"
        }
        else{
            self.category_code = ""
        }

        self.feeds = []
        if let feedsData = dictionary["feeds"] as? [NSDictionary]
        {
            for dict in feedsData {
                let value = HomePost(dictionary: dict)
                feeds.append(value)
            }
        }
    }
}
