//  Created by Navpreet on 16/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.

import Foundation

struct Cities {
    var id: Int
    var name: String
    var county: String
    
    init(dictionary: NSDictionary) {
        self.id = dictionary["id"] as? Int ?? 0
        self.name = dictionary["city"] as? String ?? ""
        self.county = dictionary["county"] as? String ?? ""
    }
}
