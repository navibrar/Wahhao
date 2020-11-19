//
//  Category.swift
//  BuyDirect
//
//  Created by administrator on 11/01/18.
//  Copyright © 2018 Nvish. All rights reserved.
//

import Foundation


struct Category {

    let category_code : String
    let category_name : String
    let category_name_cn : String
    let row_num : String

    var displayName: String{
        get{
            return category_name
        }
    }
    
    init(dictionary: NSDictionary){
        self.category_name = dictionary["category_name"] as? String ?? ""
        self.category_name_cn = dictionary["category_name_cn"]  as? String ?? ""
        
        if let value  = dictionary["row_num"]
        {
            self.row_num = "\(String(describing: value))"
        }
        else{
            self.row_num = ""
        }
        if let value  = dictionary["category_code"]
        {
            self.category_code = "\(String(describing: value))"
        }
        else{
            self.category_code = ""
        }
    }
}
