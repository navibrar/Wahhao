//  Created by Navpreet on 25/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.

import Foundation

struct NotificationsSettings {
    var title: String
    var is_enabled: Bool
    
    init(dictionary: NSDictionary) {
        self.title = ""
        if !(dictionary["title"] is NSNull) {
            self.title = dictionary["title"] as? String ?? ""
        }
        self.is_enabled = true
        if !(dictionary["is_enabled"] is NSNull) {
            self.is_enabled = dictionary["is_enabled"] as? Bool ?? true
        }
    }
    
}
