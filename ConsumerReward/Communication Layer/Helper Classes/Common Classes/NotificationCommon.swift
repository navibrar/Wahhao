//
//  NotificationCommon.swift
//  ConsumerReward
//
//  Created by apple on 25/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.
//

import Foundation

struct NotificationDataTypes {
    /*  brand_add_video
     like_video
     cart_out_of_stock
     order_confirm
     order_warehouse
     order_shipped
     order_delivered
     order_warehouse
     follow_consumer / follow_brand
     referral_join
     wishlist_out_of_stock
     review_purchase
     follow_brand*/
    enum NotificationType: String {
        case like_video = "like_video"
        case cart_out_of_stock = "cart_out_of_stock"
        case order_confirm = "order_confirm"
        case order_warehouse = "order_warehouse"
        case order_shipped  = "order_shipped"
        case order_delivered  = "order_delivered"
        case referral_join  = "referral_join"
        case follow_consumer  = "follow_consumer"
        case follow_brand  = "follow_brand"
        case wishlist_out_of_stock  = "wishlist_out_of_stock"
        case brand_add_video = "brand_add_video"
        case review_purchase = "review_purchase"
        case consumer_add_review = "consumer_add_review"
    }
    
    enum RegisterUserType: String {
        case brand = "1"
        case consumer = "2"
        
    }
}

