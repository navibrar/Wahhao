//  Created by Navpreet on 11/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import Foundation

struct ReferralDetails {
    var referal_code: String
    var content: String
    var text_msg: String
    var url: String
    var referal_code_image: String
    
    init(dictionary: NSDictionary) {
        self.referal_code = dictionary["referal_code"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        self.text_msg = dictionary["text_msg"] as? String ?? ""
        self.url = dictionary["url"] as? String ?? ""
        self.referal_code_image = dictionary["referral_image_url"] as? String ?? ""
    }
}
