//  Created by Navpreet on 17/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import Foundation

struct OrderSummary {
    var title: String
    var description: String
    
    init(dictionary: NSDictionary) {
        self.title = dictionary["title"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
    }
}
