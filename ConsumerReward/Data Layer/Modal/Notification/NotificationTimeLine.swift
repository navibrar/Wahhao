//  Created by Navpreet on 25/10/18.
//  Copyright © 2018 wahhao. All rights reserved.

import Foundation

struct NotificationTimeLine {
    var title: String
    var notifications: [UserNotification]
    
    init(dictionary: NSDictionary) {
        self.title = dictionary["title"] as? String ?? ""
        self.notifications = NotificationTimeLine.getNotifications(array: dictionary["notify"] as! [NSDictionary])
    }
    
    static func getNotifications(array: [NSDictionary]) -> [UserNotification] {
        var items: [UserNotification] = []
        for dict in array {
            let value = UserNotification(dictionary: dict)
            items.append(value)
        }
        return items
    }
}
