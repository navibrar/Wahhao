//  Created by Navpreet on 19/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.

import Foundation
import FirebaseAnalytics

struct FirAnalytics {
    static func trackEvent(withScreen screen: Screen, category: Category, label: Label, action: Actions, value: Int? = nil) {
        Analytics.logEvent(screen.rawValue, parameters: [
            AnalyticsParameterItemID: category.rawValue,
            AnalyticsParameterItemName: label.rawValue,
            AnalyticsParameterContentType: action.rawValue
            ])
    }
    
    static func trackPageView(withScreen screen: Screen) {
        Analytics.setScreenName(screen.rawValue, screenClass: screen.rawValue)
    }
    
    enum Actions: String {
        //Login
        case loginBtn = "login_CTA"
        case loginOTPBtn = "Login_OTP_CTA"
        case fbLoginBtn = "login_CTA_FB"
        case signUpBtn = "signup_CTA"
        case fbSignUpBtn = "signup_CTA_FB"
        case otpBtn = "OTP_CTA"
        case createProfileBtn = "Create_Profile_CTA"
        //Feed
        case topCategoryChange = "TopCategory Change"
        case swipeLeftRight = "Swipe Left/Right"
        case swipeUp = "Swipe up"
        case doubleTapLike = "Double Tap to Like"
        case likeFeedBtn = "Like feed CTA"
        case productDetailBtn = "Product CTA"
        case buyNowBtn = "BuyNow CTA"
        case shareEarnBtn = "Share&Earn CTA"
        case rewardsBtn = "Rewards CTA"
        case cartBtn = "Cart CTA"
        case shopMoreBtn = "Shop More CTA"
        
        //Product Details
        case relatedproduct_tapped = "related product tapped"
        case seemorereviews_tapped = "seemorereviews_tapped"
        case addwishlist_tapped = "addwishlist_tapped"
        case removewishlist_tapped = "removewishlist_tapped"
        case addtocart_tapped = "addtocart_tapped"
        case buynow_tapped = "buynow_tapped"
        
        // CART
        case qty_Uupdate = "cart_qty_update"
        case product_deleted = "product_deleted"
        case show_productdetails = "show_productDetails"
        case placeOrder_Request = "placeOrder_Request"
        
        // Checkout
        case addshipping_address = "addshipping_address"
        case addbilling_address = "addbilling_address"
        case addpayment_card = "addpayment_card"
        case orderplaced = "order placed"
        
        // Order History
        case order_history_page = "order_history_loaded"
        case product_tapped = "product_tapped"
        
        // Order Details
        case addvideoreview_tapped = "addvideo_review_tapped"
        case reorder_tapped = "reorder_CTA"
        
        // Video Review
        case addrating = "add ratings"
        case addvideo = "add video"
        case postreview = "post review"
    }
    
    enum Screen: String {
        case login = "Login"
        case signUp = "Signup"
        case createProfile = "Create Profile"
        case homeFeed = "Home Feed"
        case productDetails = "Product Details"
        case cartView = "Cart View"
        case checkOut = "CheckOut"
        case orderhistory = "Order History"
        case orderdetails = "Order Details"
        case addvideoreview = "Add Video Review"
    }
    
    enum Category: String {
        case login = "Login"
        case signUp = "Signup"
        case createProfile = "Create Profile"
        case homeFeed = "Home Feed"
        case productDetails = "Product Details"
        case cartView = "Cart View"
        case checkout = "Checkout"
        case orderhistory = "Order History"
        case orderdetails = "Order Details"
        case addvideoreview = "Add Video Review"
        
    }
    enum Label: String {
        //Login
        case login_page_loaded = "login_page_loaded"
        case login_CTA_success = "login_CTA_success"
        case login_OTP = "login_OTP"
        case login_Verify_code = "login_Verify_code"
        case login_FB_CTA_success = "login_FB_CTA_success"
        case signup_page_loaded = "signup_page_loaded"
        case signup_CTA_success = "signup_CTA_success"
        case signup_FB_CTA_success = "signup_FB_CTA_success"
        case signupVerify_code_success = "signupVerify_code_success"
        case createprofile_page_loaded = "createprofile_page_loaded"
        case Profile_completed_success = "Profile_completed_success"
        //Home feed
        case homefeed_page_loaded = "homefeed_page_loaded"
        case homefeed_category_loaded = "homefeed_category_loaded"
        case homefeed_feed_swiped = "homefeed_feed_swiped"
        case homefeed_profile_swiped = "homefeed_profile_swiped"
        case homefeed_doubletap_like = "homefeed_doubletap_like"
        case homefeed_tap_like = "homefeed_tap_like"
        case homefeed_productdetails_loaded = "homefeed_productdetails_loaded"
        case homefeed_checkout_loaded = "homefeed_checkout_loaded"
        case homefeed_shareEarn_tapped = "homefeed_share&Earn_tapped"
        case homefeed_rewards_tapped = "homefeed_rewards_tapped"
        case homefeed_cart_tapped = "homefeed_cart_tapped"
        case homefeed_shopmore_tapped = "homefeed_shopmore_tapped"
        case homefeed_buyNow_tapped = "homefeed_buyNow_tapped"
        
        // Product Details
        case produtcdetails_relatedproduct_tapped = "produtcdetails_relatedproduct_tapped"
        case produtcdetails_seemorereviews_tapped = "produtcdetails_seemorereviews_tapped"
        case produtcdetails_addwishlist_tapped = "produtcdetails_addwishlist_tapped"
        case productdetails_removewishlist_tapped = "productdetails_removewishlist_tapped"
        case productdetails_addtocart_tapped = "productdetails_addtocart_tapped"
        case productdetails_buynow_tapped = "productdetails_buynow_tapped"
        
        // Cart
        case cart_qty_update = "cart_qty_update"
        case cart_product_deleted = "cart_product_deleted"
        case cart_load_productDetails = "cart_load_productDetails"
        case cart_placeorder_request = "cart_placeOrder_request"
        
        // Checkout
        case checkout_addshipping_address = "checkout_addshipping_address"
        case checkout_addbilling_address = "checkout_addbilling_address"
        case checkout_payment_card_added = "checkout_payment_card_added"
        case checkout_placeorder = "checkout_placeorder"
        
        // Order History
        case order_history_page_load = "order_history_loaded"
        case order_history_product_tapped = "order_history_product_tapped"
        
        // Order Details
        case orederdetails_addvideoreview_tapped = "orederdetails_addvideo_review_tapped"
        case orederdetails_reorder_tapped = "orederdetails_reorder_CTA"
        
        // Video Review
        case addvideoreview_addrating = "addvideoreview_add ratings"
        case addvideoreview_addvideo = "addvideoreview_add video"
        case addvideoreview_postreview = "addvideoreview_post review"
    }
}
