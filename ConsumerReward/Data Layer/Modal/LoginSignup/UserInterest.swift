//  Created by Navpreet on 23/10/18.
//  Copyright © 2018 wahhao. All rights reserved.

import Foundation

struct UserInterest {
    var title: String
    var id: Int
    var isSelected: Bool
    
    init(dictionary: NSDictionary) {
        if  let value = dictionary["id"] as? Int {
            self.id = value
        }else {
            self.id = Int(dictionary["id"] as! String == "" ? "0" : dictionary["id"] as! String)!
        }
        self.title = dictionary["interest"] as? String ?? ""
        self.isSelected = dictionary["isSelected"] as? Bool ?? false
    }
}
