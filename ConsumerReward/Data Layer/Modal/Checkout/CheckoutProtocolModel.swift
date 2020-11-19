//  Created by Navpreet on 10/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.

import Foundation

struct CheckoutProtocolModel {
    var classWhereProductIsAdded = ""
    var shippingAddressId: Int? = 0
    var isBillingAddressSimilarToShippingAddress: Bool = false
    var isAddressFieldOpen: Bool = false
    var isPaymentFieldOpen: Bool = false
    var isOrderSummaryOpen: Bool = false
    var isClearCart: Bool = false
    var paymentDetails: CardDetail? = nil
    var billingAddress: ShippingAddress? = nil
    var shippingAddress: ShippingAddress? = nil
    var array_ItemsToBuy: [Cart?] = []
    var review_id: String = ""
    
    init(dictionary: NSDictionary) {
        self.classWhereProductIsAdded = ""
        if dictionary["classWhereProductIsAdded"] as? String != "" {
            self.classWhereProductIsAdded = dictionary["classWhereProductIsAdded"] as? String ?? ""
        }
        self.shippingAddressId = 0
        if dictionary["shippingAddressId"] as? Int != 0 {
            self.shippingAddressId = dictionary["shippingAddressId"] as? Int ?? 0
        }
        self.isBillingAddressSimilarToShippingAddress = false
        if dictionary["isBillingAddressSimilarToShippingAddress"] as? Bool != false {
            self.isBillingAddressSimilarToShippingAddress = dictionary["isBillingAddressSimilarToShippingAddress"] as? Bool ?? false
        }
        self.isAddressFieldOpen = false
        if dictionary["isAddressFieldOpen"] as? Bool != false {
            self.isAddressFieldOpen = dictionary["isAddressFieldOpen"] as? Bool ?? false
        }
        self.isPaymentFieldOpen = false
        if dictionary["isPaymentFieldOpen"] as? Bool != false {
            self.isPaymentFieldOpen = dictionary["isPaymentFieldOpen"] as? Bool ?? false
        }
        self.isOrderSummaryOpen = false
        if dictionary["isOrderSummaryOpen"] as? Bool != false {
            self.isOrderSummaryOpen = dictionary["isOrderSummaryOpen"] as? Bool ?? false
        }
        self.isClearCart = false
        if dictionary["isClearCart"] as? Bool != false {
            self.isClearCart = dictionary["isClearCart"] as? Bool ?? false
        }
        self.paymentDetails = nil
        if dictionary["paymentDetails"] != nil {
            self.paymentDetails = dictionary["paymentDetails"] as? CardDetail
        }
        
        self.billingAddress = nil
        if dictionary["billingAddress"] != nil {
            self.billingAddress = dictionary["billingAddress"] as? ShippingAddress
        }
        self.shippingAddress = nil
        if dictionary["shippingAddress"] != nil {
            self.shippingAddress = dictionary["shippingAddress"] as? ShippingAddress
        }
        self.array_ItemsToBuy = []
        if dictionary["array_ItemsToBuy"] != nil {
            self.array_ItemsToBuy = dictionary["array_ItemsToBuy"] as! [Cart]
        }
        self.review_id = ""
        if dictionary["review_id"] as? String != "" {
            self.review_id = dictionary["review_id"] as? String ?? ""
        }
    }
    
}
