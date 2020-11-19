//
//  Gender.swift
//  ConsumerReward
//
//  Created by apple on 10/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import Foundation

struct Gender {
    var name : String
    var id : Int
    
    init(dictionary: NSDictionary) {
        self.name = dictionary["name"] as? String ?? ""
        if  let value = dictionary["id"] as? String {
            id = Int(value)!
        }else if  let value = dictionary["id"] as? NSNumber {
            id = value.intValue
        }else {
            id = dictionary["id"] as! Int
        }
    }
}
