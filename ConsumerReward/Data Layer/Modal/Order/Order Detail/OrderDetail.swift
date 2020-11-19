//
//  OrderDetail.swift
//  ConsumerReward
//
//  Created by apple on 14/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import Foundation
struct OrderDetail {
    var order_id: String
    var order_prefix: String
    var order_date: String
    var order_total: String
    var is_video_review: Bool
    var order_shipping_charge: String
    var order_total_items: String
    var order_total_price: String
    var other_items: [Order]
    var payment_info: PaymentOrderInfo
    var purchase_details: PurchaseDetails
    
    // self added by Nav
    var rating_info: String
    var currency: String

    init(dictionary: NSDictionary)
    {
        if let value  = dictionary["order_id"]
        {
            self.order_id = "\(String(describing: value))"
        }
        else{
            self.order_id = ""
        }
        self.order_date = dictionary["order_date"] as? String ?? ""
        self.order_total = dictionary["order_total"] as? String ?? ""
        self.is_video_review  = dictionary["is_video_review"] as? Bool ?? false
        self.order_total_price  = dictionary["order_total_price"] as? String ?? ""
        self.currency = dictionary["currency"] as? String ?? "$"
        self.order_prefix = dictionary["order_prefix"] as? String ?? ""

        if let value  = dictionary["order_shipping_charge"]
        {
            self.order_shipping_charge = "\(String(describing: value))"
        }
        else{
            self.order_shipping_charge = ""
        }
        if let value  = dictionary["order_total_items"]
        {
            self.order_total_items = "\(String(describing: value))"
        }
        else{
            self.order_total_items = ""
        }
        
        let payment_info_dict = dictionary["payment_info"] as? NSDictionary ?? ["billing_name":""]
        self.payment_info = PaymentOrderInfo(dictionary: payment_info_dict)
        let purchase_details_dict = dictionary["purchase_details"] as? NSDictionary ?? ["product_id":""]
        self.purchase_details = PurchaseDetails(dictionary: purchase_details_dict)

//        let rating_info_dict = dictionary["rating_info"] as? NSDictionary ?? ["review_rating":"0"]
//        self.rating_info = OrderRatingInfo(dictionary: rating_info_dict)
        
        self.rating_info =  dictionary["rating"] as? String ?? ""
        
        self.other_items = []
        if let data = dictionary["other_items"] as? [NSDictionary]
        {
            self.other_items.removeAll()
            for dict in data {
                let value = Order(dictionary: dict)
                self.other_items.append(value)
            }
        }
    }
}
