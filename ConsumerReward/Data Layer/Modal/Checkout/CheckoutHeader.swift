//  Created by Navpreet on 18/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import Foundation
import UIKit

struct CheckoutHeader {
    var title: String
    var description: String
    var image: UIImage
    var isExpaned: Bool
    var isDataAvailable: Bool
    
    init(dictionary: NSDictionary) {
        self.title = dictionary["title"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.image = dictionary["image"] as? UIImage ?? UIImage()
        self.isExpaned = dictionary["isExpaned"] as? Bool ?? false
        self.isDataAvailable = dictionary["isDataAvailable"] as? Bool ?? false
    }
}
