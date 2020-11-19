//
//  PaymentOrderInfo.swift
//  ConsumerReward
//
//  Created by apple on 15/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import Foundation
struct PaymentOrderInfo {
    var card_number: String
    var biling_address: String
    var shipping_address: String
    var card_type: String
    
    init(dictionary: NSDictionary)
    {
        let billing_address1 =  dictionary["billing_address1"] as? String ?? ""
        let billing_address2 = dictionary["billing_address2"] as? String ?? ""
        let billing_city = dictionary["billing_city"] as? String ?? ""
        let billing_country = dictionary["billing_country"] as? String ?? ""
//        let billing_name = dictionary["billing_name"] as? String ?? ""
//        let billing_phone = dictionary["billing_phone"] as? String ?? ""
        let billing_province = dictionary["billing_province"] as? String ?? ""
        let billing_zip = dictionary["billing_zip"] as? String ?? ""
        
        let shipping_address1 = dictionary["shipping_address1"] as? String ?? ""
        let shipping_address2 = dictionary["shipping_address2"] as? String ?? ""
        let shipping_city = dictionary["shipping_city"] as? String ?? ""
        let shipping_country = dictionary["shipping_country"] as? String ?? ""
//        let shipping_name = dictionary["shipping_name"] as? String ?? ""
//        let shipping_phone = dictionary["shipping_phone"] as? String ?? ""
        let shipping_province = dictionary["shipping_province"] as? String ?? ""
        let shipping_zip = dictionary["shipping_zip"] as? String ?? ""
        
        if billing_address2 != "" {
              self.biling_address = "\(billing_address1), \(billing_address2),\n\(billing_city), \(billing_province), \(billing_country) \(billing_zip)"
        }else {
            self.biling_address = "\(billing_address1),\n\(billing_city), \(billing_province), \(billing_country) \(billing_zip)"
        }
        
       if shipping_address2 != "" {
         self.shipping_address = "\(shipping_address1), \(shipping_address2),\n\(shipping_city), \(shipping_province), \(shipping_country) \(shipping_zip)"
       }
       else {
              self.shipping_address = "\(shipping_address1),\n\(shipping_city), \(shipping_province), \(shipping_country) \(shipping_zip)"
        }
        
       
        self.card_type = dictionary["card_type"] as? String ?? ""
        if let value  = dictionary["card_number"]
        {
            self.card_number = "\(String(describing: value))"
        }
        else{
            self.card_number = ""
        }

    }
}
