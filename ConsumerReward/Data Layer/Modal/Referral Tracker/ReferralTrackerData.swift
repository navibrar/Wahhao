//  Created by Navpreet on 11/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import Foundation

struct ReferralTrackerData {
    var id: String
    var email: String
    var firstname: String
    var image: String
    var lastname: String
    var mobile_no: String
    var mobile_type: String
    var status: String

//    0 - Not Invited
//    1 - Invited
//    2 - Joined
        
    init(dictionary: NSDictionary) {

        if let value  = dictionary["id"]
        {
            self.id = "\(String(describing: value))"
        }
        else{
            self.id = ""
        }
        

        if let value  = dictionary["status"]
        {
            self.status = "\(String(describing: value))"
        }
        else{
            self.status = ""
        }
        
        self.email = dictionary["email"] as? String ?? ""
        self.firstname = dictionary["firstname"] as? String ?? ""
        self.lastname = dictionary["lastname"] as? String ?? ""
        self.image = dictionary["image"] as? String ?? ""
        if let value  = dictionary["mobile_no"]
        {
            self.mobile_no = "\(String(describing: value))"
        }
        else{
            self.mobile_no = ""
        }

        self.mobile_type = dictionary["mobile_type"] as? String ?? ""        
    }
}
