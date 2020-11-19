//
//  OrderTrack.swift
//  ConsumerReward
//
//  Created by apple on 03/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.
//

import Foundation

struct OrderTrack {
    var Status: String
    var Last_updated_date_time: String
    var Comment: String
    
    init(dictionary: NSDictionary)
    {
        self.Status = dictionary["status"] as? String ?? ""
        self.Last_updated_date_time = dictionary["created_date"] as? String ?? ""
        self.Comment = dictionary["comment"] as? String ?? ""
    }
}
