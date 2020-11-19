//  Created by Navpreet on 29/11/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import UIKit
import FacebookCore
import Stripe
import UserNotifications
import Branch
import Firebase
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userAccount : Login? = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        STPPaymentConfiguration.shared().publishableKey = StripeConstants.publishableKey
        self.changeNavigationBarColorToTransparent()
        FirebaseApp.configure()
        
        //MARK:- NSNotifications
        UNUserNotificationCenter.current().delegate = self
        if UIApplication.shared.isRegisteredForRemoteNotifications == false {
            registerForPushNotification()
        }else {
            if launchOptions != nil {
                //Provide adequate time to app startup
                let when = DispatchTime.now() + 3.0// change to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                    let notification : NSDictionary = launchOptions![UIApplication.LaunchOptionsKey.remoteNotification] as! NSDictionary
                    if notification.allKeys.count > 0 {
                        self.application(application, didReceiveRemoteNotification: notification as! [AnyHashable : Any])
                    }
                }
            }
        }
        
        //Check user login status
        let isUserPreviouslyLoggedIn = self.checkIfUserPreviouslyLoggedIn()
        if (isUserPreviouslyLoggedIn == true) {
            self.moveToDashboardScreen()
        }else {
            self.moveToLoginScreen()
        }
        //Shared Links
        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
            if let dict = params as NSDictionary? {
                if dict.allKeys.count > 0 && dict["navigate_to"] != nil {
                    self.checkSharedLink(dict: dict)
                }
            }
        }
        self.window?.makeKeyAndVisible()
        return true
    }

    //MARK:- Application State Methods
    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        /*Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }*/
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEventsLogger.activate(application)
        var topController = UIApplication.shared.keyWindow?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        if let controller = topController as? UIAlertController {
            controller.dismiss(animated: true, completion: nil)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
    
    //Mark:- Facebook Delegates
    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        // handler for Universal Links
        Branch.getInstance().continue(userActivity)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url.host ?? "")
        if url.host == "testdeeplink" {
            Branch.getInstance().application(app, open: url, options: options)
            return true
        }else {
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        }
    }
    
    //MARK:- CUSTOM METHODS
    func changeNavigationBarColorToTransparent() {
        // Sets background to a blank/empty image
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = .clear
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().isTranslucent = true
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: Constants.SEMI_BOLD_FONT, size: 15)!, NSAttributedString.Key.foregroundColor : UIColor.white,
                                                             ], for: .normal)
    }
    
    func checkIfUserPreviouslyLoggedIn() -> Bool {
        var isLoggedIn = false
        //Check app istalled with new url
        if UserdefaultStore.USERDEFAULTS_GET_STRING_KEY(key: "AppUrl") ==  "" {
            _ = KeychainWrapper.standard.removeAllKeys()
            UserdefaultStore.USERDEFAULTS_SET_STRING_KEY(object: Network.rootURL, key: "AppUrl")
            UserdefaultStore.USERDEFAULTS_SET_BOOL_KEY(object: false, key: "IsPreviouslyInstalled")
        }else {
            if UserdefaultStore.USERDEFAULTS_GET_STRING_KEY(key: "AppUrl") !=  Network.rootURL {
                _ = KeychainWrapper.standard.removeAllKeys()
                UserdefaultStore.USERDEFAULTS_SET_STRING_KEY(object: Network.rootURL, key: "AppUrl")
                UserdefaultStore.USERDEFAULTS_SET_BOOL_KEY(object: false, key: "IsPreviouslyInstalled")
            }
        }
        //Check App Install
        if UserdefaultStore.USERDEFAULTS_GET_BOOL_KEY(key: "IsPreviouslyInstalled") == false {
            _ = KeychainWrapper.standard.removeAllKeys()
            UserdefaultStore.USERDEFAULTS_SET_BOOL_KEY(object: true, key: "IsPreviouslyInstalled")
        }
        self.userAccount = Network.currentAccount
        if (self.userAccount != nil) {
            if ((self.userAccount?.access_token) != nil) {
                if self.userAccount?.has_username == false {
                    isLoggedIn =  false
                }else {
                    isLoggedIn =  true
                }
            }
        }else {
            isLoggedIn =  false
        }
        return isLoggedIn
    }
    
    func moveToDashboardScreen(){
        let storyboard = UIStoryboard(name: "ProjectStoryboard", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "HomePostViewController") as! HomePostViewController
        let navController = UINavigationController(rootViewController: vcObj)
        self.window!.rootViewController = navController
    }
    
    func moveToLoginScreen() {
        _ = KeychainWrapper.standard.removeAllKeys()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let navController = UINavigationController(rootViewController: vcObj)
        self.window!.rootViewController = navController
    }
}

//MARK:- Apple Push Notifications Setup
extension AppDelegate {
    func registerForPushNotification() {
        //Reset Notification Center
        self.resetNotificationsBadgeCountandPendingNotification()
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // Enable or disable features based on authorization.
            if granted == true{
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    center.delegate = self
                }
            }else{
                UserdefaultStore.USERDEFAULTS_SET_STRING_KEY(object: "", key: "DeviceToken")
                self.getNotificationSettings()
            }
        }
    }
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else {
                DispatchQueue.main.async {
                    AlertController.SHOW_ALERT_CONTROLLER_DOUBLE_BUTTON(alertTitle: "ERROR", message: "This app is not authorised for notifications. Please allow notification access.", btnTitle1: "Cancel", btnTitle2: "Settings", viewController: (self.window?.rootViewController)!, completionHandler: { (response) in
                        if response.caseInsensitiveCompare("Button2") == .orderedSame {
                            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                                UIApplication.shared.open(settingsURL, options: [:], completionHandler: { (success) in
                                })
                            }
                        }
                    })
                }
                return
            }
        }
    }
    func resetNotificationsBadgeCountandPendingNotification() {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
    //MARK:- Notifications Delegates
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map {String(format: "%02.2hhx", $0)}.joined()
        print("Device Token: \(token)")
        UserdefaultStore.USERDEFAULTS_SET_STRING_KEY(object: token, key: "DeviceToken")
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Push notification Registration Error: \(error)")
        UserdefaultStore.USERDEFAULTS_SET_STRING_KEY(object: "", key: "DeviceToken")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        let payload = userInfo["aps"] as! [String:Any]
        let alert = payload["alert"] as! NSDictionary
        //1
        /*AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: alert["title"] as! String, message: alert["body"] as! String, btnTitle: "Dismiss", viewController: (self.window?.rootViewController)!) { (success) in
         }*/
        //2
        let content = UNMutableNotificationContent()
        //adding title, subtitle, body and badge
        content.title = alert["title"] as! String
        content.subtitle = ""
        content.body = alert["body"] as! String
        content.badge = (payload["badge"] as! NSNumber)
        
        //getting the notification trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: "WahhaoNotifications", content: content, trigger: trigger)
        
        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
        if let payload = notification.request.content.userInfo["content"] as? [String:Any] {
            print("Notification Content: \(payload)")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        self.resetNotificationsBadgeCountandPendingNotification()
        let userInfo = response.notification.request.content.userInfo
        print("Notification: \(userInfo)")
        if let payload = userInfo["content"] as? [String:Any] {
            // Handle your data here, pass it to a view controller etc.
            self.checkNotificationContent(content: payload)
        }
    }
}

//MARK:- Shared Links
extension AppDelegate {
    func checkSharedLink(dict: NSDictionary) {
        let isUserPreviouslyLoggedIn = self.checkIfUserPreviouslyLoggedIn()
        if (isUserPreviouslyLoggedIn == false) {
            self.moveToLoginScreen()
            return
        }
        if let navigateTO = dict["navigate_to"] as? String {
            if navigateTO ==  "consumerProfile" {
                let profileID = dict["profileID"] as! String
                if let topController = UIApplication.topViewController() {
                    self.moveToConsumerProfile(consumerId: profileID, topViewController: topController)
                }
            }else if navigateTO == "sellerProfile" {
                let brandID = dict["brandID"] as! String
                if let topController = UIApplication.topViewController() {
                    self.moveToSellerProfile(brandId: brandID, topViewController: topController)
                }
            }else if navigateTO ==  "productDetail" {
                let variant_id = dict["variant_id"] as! String
                let productID = dict["product_id"] as! String
                if let topController = UIApplication.topViewController() {
                    self.moveToProductDetail(variantID: variant_id,productID : productID ,  topViewController: topController)
                }
                
            }
        }
    }
}
//MARK:- Get top view controller
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
extension UIViewController {
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar || false
    }
}

//MARK:- Push Notifications and Shared Links Events Handling
extension AppDelegate {
    func checkNotificationContent(content: [String:Any]) {
        let notification = content as NSDictionary
        print("Notification Content: \(content)")
        if (notification["type"] as! String).caseInsensitiveCompare("cart_out_of_stock") == .orderedSame {
            //Cart Redirection
            if let topController = UIApplication.topViewController() {
                self.moveToCart(topViewController: topController)
            }
        }else if (notification["type"] as! String).caseInsensitiveCompare("wishlist_out_of_stock") == .orderedSame {
            //Product detail Redirection
            if let topController = UIApplication.topViewController() {
                let variant_id = String(describing: notification["variant_id"]!)
                let productID = String(describing: notification["product_id"]!)
                self.moveToProductDetail(variantID: variant_id, productID: productID, topViewController: topController)
            }
        }else if (notification["type"] as! String).caseInsensitiveCompare("follow_consumer") == .orderedSame || (notification["type"] as! String).caseInsensitiveCompare("referral_join") == .orderedSame {
            //Consumer Profile Redirection
            if let topController = UIApplication.topViewController() {
                let profileID = String(describing: notification["consumer_id"]!)
                self.moveToConsumerProfile(consumerId: profileID, topViewController: topController)
            }
        }else if (notification["type"] as! String).caseInsensitiveCompare("follow_brand") == .orderedSame {
            //Brand Profile Redirection
            if let topController = UIApplication.topViewController() {
                let brandID = String(describing: notification["brand_id"]!)
                self.moveToSellerProfile(brandId: brandID, topViewController: topController)
            }
        }else if (notification["type"] as! String).caseInsensitiveCompare("like_video") == .orderedSame || (notification["type"] as! String).caseInsensitiveCompare("review_purchase") == .orderedSame || (notification["type"] as! String).caseInsensitiveCompare("consumer_add_review") == .orderedSame {
            //Post Detail Redirection
            if let topController = UIApplication.topViewController() {
                let postId = String(describing: notification["review_id"]!)
                self.moveToPostDetail(postId: postId, isReviewPost: true, topViewController: topController)
            }
        }else if (notification["type"] as! String).caseInsensitiveCompare("brand_add_video") == .orderedSame {
            //Post Detail Redirection
            if let topController = UIApplication.topViewController() {
                let postId = String(describing: notification["post_id"]!)
                self.moveToPostDetail(postId: postId, isReviewPost: false, topViewController: topController)
            }
        }else if (notification["type"] as! String).caseInsensitiveCompare("order_confirm") == .orderedSame || (notification["type"] as! String).caseInsensitiveCompare("order_warehouse") == .orderedSame || (notification["type"] as! String).caseInsensitiveCompare("order_shipped") == .orderedSame || (notification["type"] as! String).caseInsensitiveCompare("order_delivered") == .orderedSame {
            //Order List Redirection
            if let topController = UIApplication.topViewController() {
                self.moveToOrderListing(topViewController: topController)
            }
        }
    }
    func moveToConsumerProfile(consumerId:String, topViewController: UIViewController)  {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        let storyboard = UIStoryboard(name: "ConsumerProfile", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "ConsumerProfileVC") as! ConsumerProfileVC
        vcObj.get_follow_id = consumerId
        vcObj.isPresented = true
        let navController = UINavigationController(rootViewController: vcObj)
        topViewController.show(navController, sender: self)
    }
    func moveToSellerProfile(brandId:String, topViewController : UIViewController)  {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        let storyboard = UIStoryboard(name: "SellerProfile", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "BrandProfileVC") as! BrandProfileVC
        vcObj.get_brand_id = brandId
        vcObj.isPresented = true
        let navController = UINavigationController(rootViewController: vcObj)
        topViewController.show(navController, sender: self)
    }
    func moveToProductDetail(variantID: String, productID: String, topViewController: UIViewController)  {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        let storyboard = UIStoryboard(name: "ProjectStoryboard", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        let dict: NSDictionary = ["product_id": productID, "variant_id": variantID]
        let product = Product(dictionary: dict)
        vcObj.product = product
        vcObj.isShowCartButtons = true
        vcObj.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        topViewController.present(vcObj, animated: true, completion: nil)
    }
    func moveToCart(topViewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        vc.isPresented = true
        let navController = UINavigationController(rootViewController: vc)
        topViewController.show(navController, sender: self)
    }
    func moveToOrderListing(topViewController: UIViewController)  {
        let storyboard = UIStoryboard(name: "Order", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OrderVC") as! OrderVC
        vc.isPresented = true
        let navController = UINavigationController(rootViewController: vc)
        topViewController.show(navController, sender: self)
    }
    func moveToOrderDetail(variantID: String, orderID: String, topViewController: UIViewController)  {
        //Not in use now
        let dict: NSDictionary = ["order_id": orderID, "variant_id": variantID]
        let orderInfo = Order(dictionary: dict)
        let storyboard = UIStoryboard(name: "Order", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
        vc.orders_info = orderInfo
        let navController = UINavigationController(rootViewController: vc)
        topViewController.show(navController, sender: self)
    }
    func moveToPostDetail(postId: String, isReviewPost: Bool, topViewController: UIViewController) {
        let storyboard = UIStoryboard.init(name: "d", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        vc.postId = postId
        vc.isReviewPost = isReviewPost
        vc.isFromNotification = true
        topViewController.present(vc, animated: true, completion: nil)
    }
}

