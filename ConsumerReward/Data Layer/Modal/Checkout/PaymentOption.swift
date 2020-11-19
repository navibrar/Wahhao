//  Created by Navpreet on 20/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import Foundation

struct PaymentOption {
    let title: String
    var isSelected: Bool
    
    init(dictionary: NSDictionary) {
        self.title = dictionary["title"] as? String ?? ""
        self.isSelected = dictionary["isSelected"] as? Bool ?? false
    }
}
