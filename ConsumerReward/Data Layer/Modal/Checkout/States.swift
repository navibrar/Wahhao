//  Created by Navpreet on 14/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import Foundation

struct States {
    var id: Int
    var code: String
    var name: String
    
    init(dictionary: NSDictionary) {
        self.id = dictionary["id"] as? Int ?? 0
        self.code = dictionary["state_code"] as? String ?? ""
        self.name = dictionary["state_name"] as? String ?? ""
    }
}
