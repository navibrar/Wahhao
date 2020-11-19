//  Created by Navpreet on 24/10/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

class NotificationsVC: UIViewController {
    //MARK:- Variable Declaration
    var dict_Localized = [String:String]()
    var array_Notifications = [NotificationTimeLine]()
    var array_NoOffSection = [UserNotification]()
    var array_notificationTitle = [String]()
    let refreshControl = UIRefreshControl()
     let store = NotificationServices.sharedInstance
     let storeFollowUnfollow = UserProfileServices.sharedInstance
    //MARK:- Outlet Connections
    @IBOutlet weak var table_Notifications: UITableView!
    @IBOutlet weak var no_notification : UILabel!
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setLocalizedText()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let view = table_Notifications.subviews //get all the subviews
            .filter {String(describing:type(of: $0)) ==  "UISwipeActionPullView"}
        print(view)
        if view.count > 0 {
            view[0].backgroundColor = UIColor.clear
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if self.refreshControl.isRefreshing == true {
            self.refreshControl.endRefreshing()
        }
         self.view.endEditing(true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK:- Custom Methods
    func initialSetup() {
        self.no_notification.isHidden = true
        table_Notifications.tableFooterView = UIView()
        table_Notifications.backgroundView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        table_Notifications.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        table_Notifications.showsVerticalScrollIndicator = false
        table_Notifications.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        table_Notifications.register(UINib(nibName: "NotificationTimelineHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "NotificationTimelineHeaderView")
        table_Notifications.rowHeight = UITableView.automaticDimension
        table_Notifications.estimatedRowHeight = 95
        if #available(iOS 10, *) {
            table_Notifications.refreshControl = refreshControl
        } else {
            table_Notifications.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(self.fetchNotificationList), for: .valueChanged)
        refreshControl.tintColor = UIColor.clear
        self.fetchNotificationList()
       
    }
    func setLocalizedText() {
        dict_Localized = GET_LOCALIZED_STRING_DICTIONARY(forClass: "UserNotification")
        
    }
    func setupData()  {
        let dict1: NSDictionary = ["image":"buy_now_bg", "description": "amywilliams and 5 others liked your post.", "time": "2 Hrs", "id":"1", "type":2, "isFollowing": false]
        let dict2: NSDictionary = ["image":"buy_now_bg", "description": "davidblake and 3 others started following you.", "time": "1 Day", "id":"1", "type":1, "isFollowing": true]
        let dict3: NSDictionary = ["image":"buy_now_bg", "description": "davidblake and 2 others started following you.", "time": "1 Day", "id":"1", "type":1, "isFollowing": false]
        
        let mainDict1: NSDictionary = ["title": "TODAY","Shown_section":true ,"notifications": [dict1, dict2, dict3, dict1]]
        let mainDict2: NSDictionary = ["title": "YESTERDAY","Shown_section":true ,"notifications": [dict1, dict2, dict3, dict1, dict1, dict2, dict3, dict1]]
        let mainDict3: NSDictionary = ["title": "THIS MONTH","Shown_section":true ,"notifications": [dict1, dict2]]
        let mainDict4: NSDictionary = ["title": "PREVIOUS MONTH","Shown_section":true, "notifications": [dict1, dict2, dict3, dict1, dict1, dict2]]
        array_Notifications.append(NotificationTimeLine(dictionary: mainDict1))
        array_Notifications.append(NotificationTimeLine(dictionary: mainDict2))
        array_Notifications.append(NotificationTimeLine(dictionary: mainDict3))
        array_Notifications.append(NotificationTimeLine(dictionary: mainDict4))
        self.table_Notifications.reloadData()
    }
    func prefieldData()  {
        self.array_Notifications = self.store.array_Notifications
        
        for obj in self.array_Notifications
        {
            if obj.notifications.count > 0 {
                for (index, object)  in obj.notifications.enumerated(){
                    self.array_notificationTitle.append(obj.title)
                    if index == 0{
                        var item  = object
                        item.isTitleShowing = true
                        self.array_NoOffSection.append(item)
                    }else{
                        self.array_NoOffSection.append(object)
                    }
                }
            }
        }
        print(self.array_NoOffSection.count)
        if self.array_NoOffSection.count > 0 {
            self.no_notification.isHidden = true
            self.table_Notifications.reloadData()
        } else {
            self.no_notification.isHidden = false
            self.table_Notifications.isHidden = true
        }
    }
    func deleteSelectedNotification(index:Int) {
        self.readNotificationList(row_num: self.array_NoOffSection[index].row_num)
    }
    // Move to profile
    func moveToProfile(userId:String,regType:String) {
        
        let strUserId =  String(describing: userId)
        if strUserId != "0" {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromTop
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        if (regType.caseInsensitiveCompare(NotificationDataTypes.RegisterUserType.brand.rawValue) == ComparisonResult.orderedSame){
            //move to consumer
            let storyboard = UIStoryboard(name: "SellerProfile", bundle: nil)
            let vcObj = storyboard.instantiateViewController(withIdentifier: "BrandProfileVC") as! BrandProfileVC
            vcObj.get_brand_id = strUserId
            self.navigationController?.pushViewController(vcObj, animated: false)
        }else if(regType.caseInsensitiveCompare(NotificationDataTypes.RegisterUserType.consumer.rawValue) == ComparisonResult.orderedSame) {
            let storyboard = UIStoryboard(name: "ConsumerProfile", bundle: nil)
            let vcObj = storyboard.instantiateViewController(withIdentifier: "ConsumerProfileVC") as! ConsumerProfileVC
            vcObj.get_Follow_info = false
            vcObj.get_user_Follow_id = strUserId
            self.navigationController?.pushViewController(vcObj, animated: false)
        }
    }
    }
    //MARK: Move to consumer profile
    func moveToConsumerProfile(consumerId:String)  {
    
      let strConsumerId =  String(describing: consumerId)
        if strConsumerId != "0" {
      let transition = CATransition()
      transition.duration = 0.5
      transition.type = CATransitionType.push
      transition.subtype = CATransitionSubtype.fromTop
      transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
     
        let storyboard = UIStoryboard(name: "ConsumerProfile", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "ConsumerProfileVC") as! ConsumerProfileVC
        vcObj.get_Follow_info = false
        vcObj.get_user_Follow_id = strConsumerId
        self.navigationController?.pushViewController(vcObj, animated: false)
        }
        
    }
    //MARK: Move to seller
    func moveToSellerProfile(brandId:String) {
    let strbrandId =  String(describing: brandId)
    let transition = CATransition()
    transition.duration = 0.5
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromTop
    transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
    view.window!.layer.add(transition, forKey: kCATransition)
    
   
    let storyboard = UIStoryboard(name: "SellerProfile", bundle: nil)
    let vcObj = storyboard.instantiateViewController(withIdentifier: "BrandProfileVC") as! BrandProfileVC
    vcObj.get_brand_id = strbrandId
    self.navigationController?.pushViewController(vcObj, animated: false)
    }
    
    // Mark: move to order
    func moveToOrders(){
        let storyboard = UIStoryboard(name: "Order", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OrderVC") as! OrderVC
        self.navigationController?.show(vc, sender: self)
    }
    
    // MARK: Move to order details
    func moveToOrderDetails(){
        let storyboard = UIStoryboard(name: "Order", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
        vc.iSCommingFromNotification = true
       // vc.order_id
        //vc.variant_id
        self.navigationController?.show(vc, sender: self)
    }
    
    func moveToProductDetail(variantId: String, productId: String)  {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        let storyboard = UIStoryboard(name: "ProjectStoryboard", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        let dict: NSDictionary = ["product_id": productId, "variant_id": variantId]
        let product = Product(dictionary: dict)
        vcObj.product = product
        vcObj.isShowCartButtons = true
        vcObj.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        //self.navigationController?.show(vcObj, sender: self)
        self.present(vcObj, animated: true, completion: nil)
       
       
    }
    //Move to cart
    func moveToCart() {
        let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        //self.navigationController?.show(vc, sender: self)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //Move to video
    func moveToVideo(reviewId:String,isReviewPost:Bool)
    {
        let storyboard = UIStoryboard(name: "ProjectStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        //self.navigationController?.show(vc, sender: self)
        vc.postId = reviewId
        vc.isReviewPost = isReviewPost
        vc.isFromNotification = true
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    
    
   
    //MARK:- Button Methods
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- UITableViewDelegate & UITableViewDataSource
extension NotificationsVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return array_NoOffSection.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height = CGFloat()
        if array_NoOffSection[section].isTitleShowing == true {
           height = 53
        } else {
            height = 16
        }
       return height
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NotificationTimelineHeaderView") as! NotificationTimelineHeaderView
        headerView.tintColor = UIColor.clear
         headerView.configureHeader(item: array_notificationTitle[section])
        if self.array_NoOffSection[section].isTitleShowing == true {
        headerView.lbl_Title.isHidden = false
       }else{
          headerView.lbl_Title.isHidden = true
       }
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 16))
        view.backgroundColor = UIColor.clear
        return footerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1 //array_Notifications[section].notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.configureCell(item: array_NoOffSection[indexPath.section])
        cell.btn_Follow.tag = indexPath.section
       cell.btn_Follow.addTarget(self, action: #selector(self.followButtonTapped(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arrayObject  =  (array_NoOffSection[indexPath.section])
        if(arrayObject.type.caseInsensitiveCompare(NotificationDataTypes.NotificationType.follow_brand.rawValue) == ComparisonResult.orderedSame){
           moveToSellerProfile(brandId: arrayObject.brand_id)
        }else if (arrayObject.type.caseInsensitiveCompare(NotificationDataTypes.NotificationType.follow_consumer.rawValue) == ComparisonResult.orderedSame){
             moveToConsumerProfile(consumerId: arrayObject.consumer_id)
            
        }else if (arrayObject.type.caseInsensitiveCompare(NotificationDataTypes.NotificationType.order_confirm.rawValue) == ComparisonResult.orderedSame){
            self.moveToOrders()
        }else if (arrayObject.type.caseInsensitiveCompare(NotificationDataTypes.NotificationType.order_warehouse.rawValue) == ComparisonResult.orderedSame){
             self.moveToOrders()
            
        }else if (arrayObject.type.caseInsensitiveCompare(NotificationDataTypes.NotificationType.order_shipped.rawValue) == ComparisonResult.orderedSame){
             self.moveToOrders()
            
        }else if (arrayObject.type.caseInsensitiveCompare(NotificationDataTypes.NotificationType.order_delivered.rawValue) == ComparisonResult.orderedSame){
            self.moveToOrders()
        }
        else if (arrayObject.type.caseInsensitiveCompare(NotificationDataTypes.NotificationType.referral_join.rawValue) == ComparisonResult.orderedSame){
            moveToConsumerProfile(consumerId: arrayObject.consumer_id)
        }else if (arrayObject.type.caseInsensitiveCompare(NotificationDataTypes.NotificationType.like_video.rawValue) == ComparisonResult.orderedSame){
          self.moveToVideo(reviewId: arrayObject.review_id, isReviewPost: true)
        
        }else if (arrayObject.type.caseInsensitiveCompare(NotificationDataTypes.NotificationType.brand_add_video.rawValue) == ComparisonResult.orderedSame){
           self.moveToVideo(reviewId: arrayObject.post_id, isReviewPost: false)
            
        }else if (arrayObject.type.caseInsensitiveCompare(NotificationDataTypes.NotificationType.review_purchase.rawValue) == ComparisonResult.orderedSame){
            
            self.moveToVideo(reviewId: arrayObject.review_id, isReviewPost: true)
        }else if (arrayObject.type.caseInsensitiveCompare(NotificationDataTypes.NotificationType.consumer_add_review.rawValue) == ComparisonResult.orderedSame){
            
            self.moveToVideo(reviewId: arrayObject.review_id, isReviewPost: true)
        }
        else if (arrayObject.type.caseInsensitiveCompare(NotificationDataTypes.NotificationType.cart_out_of_stock.rawValue) == ComparisonResult.orderedSame){
            self.moveToCart()
            
        }else if (arrayObject.type.caseInsensitiveCompare(NotificationDataTypes.NotificationType.wishlist_out_of_stock.rawValue) == ComparisonResult.orderedSame){
            self.moveToProductDetail(variantId: arrayObject.variant_id, productId: arrayObject.product_id)
            
        }
            
        
    }
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.view.setNeedsLayout()
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let cell = table_Notifications.cellForRow(at: indexPath) as! NotificationCell
        let kCellActionWidth = CGFloat(75.0)// The width you want of delete button
        let kCellHeight = cell.frame.size.height //CGFloat(75.0) // The height you want of delete button
        let whitespace = whitespaceString(width: kCellActionWidth) // add the padding
        //View
        let deleteAction = UITableViewRowAction(style: .destructive, title: whitespace) {_,_ in
            self.deleteSelectedNotification(index: indexPath.section)
        }
 
//        let view_Main = UIView(frame: CGRect(x: tableView.frame.size.width-kCellActionWidth, y: 0, width: kCellActionWidth, height: kCellHeight))
//        view_Main.backgroundColor = .clear
//        view_Main.layer.cornerRadius = 6.0
//        view_Main.clipsToBounds = true
        // create a color from patter image and set the color as a background color of action
        let view_Main = UIView(frame: CGRect(x: tableView.frame.size.width-kCellActionWidth, y: 0, width: kCellActionWidth, height: kCellHeight))
        view_Main.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.0862745098, blue: 0.1411764706, alpha: 1)
        view_Main.layer.cornerRadius = 0.0
        view_Main.clipsToBounds = true
       
        
        let view_Delete = UIView(frame: CGRect(x: 10, y: 0, width: kCellActionWidth-10, height:kCellHeight ))
        view_Delete.backgroundColor = #colorLiteral(red: 0.07058823529, green: 0.1921568627, blue: 0.3137254902, alpha: 1) // background color of view
        view_Delete.layer.cornerRadius = 6.0
        view_Delete.clipsToBounds = true
        view_Main.addSubview(view_Delete)
        
        let img_View = UIImageView(frame: CGRect(x: (view_Main.frame.size.width - 17 + 10)/2, y: (kCellHeight - 18)/2, width: 17, height: 18))
        img_View.image = UIImage(named: "delete-icon_white")! // required image
        img_View.contentMode = .center
        view_Main.addSubview(img_View)
        
        let image_Delete = view_Main.image()
       
        deleteAction.backgroundColor = UIColor.init(patternImage: image_Delete)
        
        return [deleteAction]
    }

    fileprivate func whitespaceString(font: UIFont = UIFont.systemFont(ofSize: 15), width: CGFloat) -> String {
        let kPadding: CGFloat = 40
        let mutable = NSMutableString(string: "")
        let text_Font = UIFont(name: Constants.REGULAR_FONT, size: 12)!
        let attribute = [NSAttributedString.Key.font: text_Font]
        while mutable.size(withAttributes: attribute).width < width - (2 * kPadding) {
            mutable.append(" ")
        }
        return mutable as String
    }
    
    
    @objc func followButtonTapped(sender:UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.table_Notifications)
        if let indexPath = self.table_Notifications.indexPathForRow(at: buttonPosition) {
        print(indexPath.section)
          
                let value = array_NoOffSection[indexPath.section]
               // let strUserId = String(describing: value.follower_id)
            // print("User id is = " + (strUserId))
            if value.is_following == false {
                    self.brandfollowAPI(index: indexPath.section,user_id: value.follower_id)
                   }else {
                    self.brandUnfollow(index: indexPath.section,user_id: value.follower_id)
                }
        }
    }
}
extension NotificationsVC {
    
    @objc func fetchNotificationList() {
        store.fetchNotificationInfo(showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            self.array_Notifications.removeAll()
            self.array_NoOffSection.removeAll()
            self.array_notificationTitle.removeAll()
            if let _ = success as? [String: Any] {
                if self.refreshControl.isRefreshing == true {
                    self.refreshControl.endRefreshing()
                }
                print(success)
                print("success")
                self.prefieldData()
            }
        }) { (failure) -> Void in
            
            if self.refreshControl.isRefreshing == true {
                self.refreshControl.endRefreshing()
            }
            self.array_Notifications.removeAll()
            self.array_NoOffSection.removeAll()
            self.array_notificationTitle.removeAll()
            self.table_Notifications.reloadData()
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    
    
    @objc func readNotificationList(row_num:String) {
        store.callReadNotification(value: row_num,showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
           // // your successful handle
           // self.array_Notifications.removeAll()
            self.fetchNotificationList()
//            if let _ = success as? [String: Any] {
//                print(success)
//                print("success")
//                self.fetchNotificationList()
//            }
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    
    func brandfollowAPI(index:Int,user_id:String) {
        if user_id != "" {
        storeFollowUnfollow.callFollowBrandAPI(parameters: ["user_id":user_id], showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any] {
                print(success)
                print("success")
                // self.followUnFollowUIsetup(index: index)
                self.fetchNotificationList()
            }
        }) { (failure) -> Void in
            self.handleAPIError(failure: failure)
        }
        }
    }
    
    func brandUnfollow(index:Int,user_id:String)
    { if user_id != ""{
        storeFollowUnfollow.callUnFollowBrandAPI(parameters: ["user_id":user_id], showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any]
            {
                print(success)
                print("success")
               // self.followUnFollowUIsetup(index: index)
               // self.fetchUsersList()
               // self.table_Notifications.reloadData()
                self.fetchNotificationList()
            }
        }) { (failure) -> Void in
            self.handleAPIError(failure: failure)
        }
        }
    }
    
//    func followUnFollowUIsetup(index:Int) {
//        let indexPath = IndexPath(row: 0, section: index)
//        if array_NoOffSection[indexPath.section].is_following == false {
//                array_NoOffSection[indexPath.section].is_following = true
//            }else {
//                array_NoOffSection[indexPath.section].is_following = false
//            }
//        table_Notifications.beginUpdates()
//        table_Notifications.reloadRows(at: [indexPath], with: .automatic)
//        table_Notifications.endUpdates()
//    }

   
}
