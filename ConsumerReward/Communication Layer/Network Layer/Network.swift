
import Foundation
import UIKit

final class Network {
    //***************DEMO**************************
//            static let rootURL = "https://demo-shopus.wahhao.com"
//            static let environment = "hk-Demo"
    //*****************************************
    
    //***************UAT**************************
//            static let rootURL = "http://hubhk-shop.wahhao.com"
//            static let environment = "UAT"
    //*****************************************
    
    //***************Dev**************************
    static let rootURL = "https://dev-shop.wahhao.com"
    static let environment = "Dev"
    //*****************************************
    //demo-shop.wahhao.com
    
    static let baseURL = rootURL + "/api"
    
    static let appHeader = ["Accept":"application/json", "Content-Type":"application/json", "device": "ios", "lang":"en"]
    
    static var currentAccount:Login? {
        if let registered_mobile = KeychainWrapper.standard.string(forKey: "registered_mobile") {
            if let acc = Login.loadFromKeychain(registered_mobile_email: registered_mobile) {
                return acc
            }
        }
        return nil
    }
    //MARK:- API Endpoints
    enum APIEndPoints:String {
        //LOGIN - SIGNUP - PROFILE
        case login = "/login"
        case signUp = "/register"
        case loginAuthentication = "/loginauth"
        case signUpAuthentication = "/registerauth"
        case getUserInterests = "/userinterest"
        case createProfile = "/createprofile"
        case addProfileImage = "/profileimage"
        case removeProfileImage = "/removeprofileimage"
        case socialRegister = "/socialregister"
        case socialLogin = "/sociallogin"
        case updateUserInterests = "/userinterest/update"
        case logout = "/logout"
        
        //HOME FEED
        case postDetail = "/feed"
        case feed = "/newfeed/home"
        case postView = "/postView"
        case postLike = "/postLike"
        case inventoryDetail = "/inventory/detail"
        case userMenu = "/user/menu"

        //SHOP MORE
        case shop_more = "/post/shop_more"
        case shop_more_forme = "/newfeed/foryou?rpp="
        case shop_more_category = "/shop/category"
        case shop_more_subcategory = "/shop/subcategory"
        case shop_more_follow = "/newfeed/foryou/get_follower_feed"
        case shop_more_sale = "/newfeed/foryou/get_sale_feed"
        case shop_more_underTen = "/newfeed/foryou/get_underten_feeds"
        case shop_more_reviews = "/newfeed/foryou/get_reviews"
        
        //CART
        case cart = "/cart"
        case cartDelete = "/cart/delete"
        case cartAdded = "/cart/add"
        
        // PRODUCT INFO
        case productInfo = "/product"
        case addProductToWishlist = "/addtowishlist"
        case removeProductFromWishlist = "/removeformwishlist"
        case productReviews = "/product/reviews"

        //USER
        case follower = "/follower"
        //case followerUnFollow = "/follower/update"
        
        //SELLER PROFILE
        case brandProfile = "/brand/profile"
        
        //Checkout
        case fetchShippingAddress = "/address"
        case addShippingAddress = "/address/add"
        case updateShippingAddress = "/address/edit"
        case deleteShippingAddress = "/address/delete/"
        case states = "/states"
        case placeOrder = "/orders/add"
        //Payment
        case savedUserCardInfo = "/saveusercard"
        case fetchUserCardsInfo = "/getusercards?context="
        case deleteUserCard = "/card/delete"
        
        // CHAT
        case chatDetail = "/chat/detail/"
        case chatrecent = "/chat/recent"
        case chatsend = "/chat/message/send"
        case chatassests = "/chat/upload/assets"
        case chataddass = "/chat/favorite/add/"
        case chatremoveass = "/chat/favorite/remove/"
        case chatNew = "/chat/new"
        
        //Leaderboard
        case topDailyFans = "/leaderboard/top_fans/day"
        case topWeeklyFans = "/leaderboard/top_fans/week"
        case topMonthlyFans = "/leaderboard/top_fans/month"
        case topAllTimeFans = "/leaderboard/top_fans/all"
        case topVideos = "/top_videos"
        case unitsSold = "/leaderboard/units_sold"
        case mostLiked = "/most_liked_feeds"
        
        //CONSUMER PROFILE
        case ConsumerProfile = "/profile"
        case ConsumerEditProfile = "/editprofile"
        case ConsumerupdatePhone = "/profile/update/phone"
         case ConsumerupdateEmail = "/profile/update/email"
        case ConsumerphoneOtp = "/profile/update"
        
        // ORDERS
        case OrderHistory = "/orders/history"
        case OrderDetail = "/orders/details"
        case consumerReviewOrder = "/orders/history/latest"
        case reorder = "/reorder"
        case OrderTrack = "/orders/track"
        case addImageReviews = "/review/upload"
        case addReviews = "/review/add"
        
        //REFERRAL USER LIST
        case trackerList = "/tracker/list"
        case contactSave = "/contact/save"
        case contactInvite = "/contact/invite"
        
        //SHARE EARN
         case referalCode = "/referal/code"
        
        // NOTIFICATION
        case notification = "/notifications"
        case notificationRead = "/notification/read"
        
        //Settings
        case notificationSettings = "/notification/status"
    }
}
