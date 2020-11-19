//  Created by Navpreet on 13/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import Foundation
import Stripe

enum StripeConstants {
    static let publishableKey = "pk_test_iE1MCn5XQiDTIfe0uiLDbVFJ"
    //static let publishableKey = "pk_test_MBjOMLwRXr8sE3VD9ZqxQEFa"
    static let baseURLString = "http://localhost/wahhao/chargepaymentonToken.php"
    static let defaultCurrency = "usd"
}
 func getCardBrandRawValue(brand: String) -> Int {
    switch brand {
    case "Visa":
        return 0
    case "Amex":
        return 1
    case "MasterCard":
        return 2
    case "Discover":
        return 3
    case "JCB":
        return 4
    case "Diners":
        return 5
    case "UnionPay":
        return 6
    case "Unknown":
        return 7
    default:
        return 7
    }
}
func getCardImage(brand: String) -> UIImage {
    let cardBrand = getCardBrandRawValue(brand: brand)
    let brandImage = STPCardBrand(rawValue: cardBrand)
    let cardImage = STPImageLibrary.brandImage(for: brandImage!)
    return cardImage
}

