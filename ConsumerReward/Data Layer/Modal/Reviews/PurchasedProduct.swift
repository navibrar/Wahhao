//  Created by Navpreet on 31/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import Foundation

struct PurchasedProduct {
    var id: Int
    var image: String
    var name: String
    var brand: String
    var isSelected: Bool
    
    init(dictionary: NSDictionary) {
        self.id = 0
        if !(dictionary["id"] is NSNull) {
            if  let value = dictionary["id"] as? Int {
                self.id = value
            }else {
                self.id = Int(dictionary["id"] as! String == "" ? "0" : dictionary["id"] as! String)!
            }
        }
        self.image = ""
        if !(dictionary["image"] is NSNull) {
            self.image = dictionary["image"] as? String ?? ""
        }
        self.name = ""
        if !(dictionary["name"] is NSNull) {
            self.name = dictionary["name"] as? String ?? ""
        }
        self.brand = ""
        if !(dictionary["brand"] is NSNull) {
            self.brand = dictionary["brand"] as? String ?? ""
        }
        self.isSelected = false
    }
}
