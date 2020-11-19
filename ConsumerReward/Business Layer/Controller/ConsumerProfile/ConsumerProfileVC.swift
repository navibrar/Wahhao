//  Created by apple on 08/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import UIKit
import SVProgressHUD
import Branch

class ConsumerProfileVC: UIViewController , EditProfileDismissDelegate {
    
    //MARK:- Variable Declaration
    private var lastContentOffset: CGFloat = 0
    var navigatedFrom = String()
    var array_ProfileImage = [NSDictionary]()
    var array_Following = [NSDictionary]()
    var strShareLink = ""
    var containerInitialBounds = CGRect()
    var dict_Localized = [String:String]()
    var selectedTabIndex = Int()
    var followerButtonTap = Bool()
    var getUserid = Int()
    var getUseridStr = String()
    let store = UserProfileServices.sharedInstance
    var consumerBasic: consumerBasicInfo? = nil
    var EditconsumerBasic: consumerBasicInfo? = nil
    var isPresented: Bool = false
    //DeepLink
    let lp: BranchLinkProperties = BranchLinkProperties()
    var deepLinkUrl  = String()
    var isPresentedView = false
    //MARK:- Outlet Connections
    @IBOutlet weak var view_FollowBrand: UIView!
    @IBOutlet weak var img_FollowBrand: UIImageView!
    @IBOutlet weak var lbl_Followers: UILabel!
    @IBOutlet weak var lbl_Following: UILabel!
    @IBOutlet weak var lbl_Share: UILabel!
    @IBOutlet weak var btn_Wishlist: UIButton!
    @IBOutlet weak var btn_Reviews: UIButton!
    @IBOutlet weak var btn_Likes: UIButton!
    @IBOutlet weak var scroll_Content: UIScrollView!
    @IBOutlet weak var view_Content: UIView!
    @IBOutlet weak var constraint_Contenteight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var user_name_lbl: UILabel!
    @IBOutlet weak var user_des_lbl: UILabel!
    @IBOutlet weak var lbl_Username: UILabel!
    @IBOutlet weak var user_image: UIImageView!
    @IBOutlet weak var lbl_Rating: UILabel!
    var get_Follow_info = Bool()
    var get_user_Follow_id = String()
    var get_follow_id = String()
   
     @IBOutlet weak var edit_Btn: UIBarButtonItem!
    
    var get_consumer_id = String()
    var comingFromNotificationClass = Bool()
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view_FollowBrand.roundCorners([.topLeft], radius: 6)
        self.scroll_Content.contentSize = CGSize(width: 0, height: (self.view.bounds.width * 1.565) + 167)
        let contentHeight = self.scroll_Content.contentSize.height - (self.view.bounds.width * 1.565)
        if contentHeight > 0 {
            self.constraint_Contenteight.constant = contentHeight
        }
        
        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipedown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipedown)
        
        NOTIFICATIONCENTER.addObserver(self, selector: #selector(self.refreshData), name: Notification.Name(rawValue: "UserProfile"), object: nil)
    }
    //MARK:- Swipe Gesture
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                self.dismissView()
            default:
                break
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: UIColor.clear), for: .default)
        self.refreshData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: UIColor.clear), for: .default)
    }
    
    func editProfileDismissed(EditconsumerBasic:consumerBasicInfo) {
        self.consumerBasic = EditconsumerBasic
        self.prefillData()
    }
    
    @objc func refreshData() {
        selectedTabIndex = 0
        // Mark: - Get info Disply from Home feed & Shown here Repllace Later
        if (get_user_Follow_id.count > 0){
            getUserid = (Login.loadCustomerInfoFromKeychain()?.id)!
            getUseridStr = String(getUserid)
            getUseridStr = get_user_Follow_id
        }else {
            getUserid = (Login.loadCustomerInfoFromKeychain()?.id)!
            getUseridStr = String(getUserid)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.getProfileData()
        }
    }
    func prefillData() {
        if self.consumerBasic == nil
        {
            return
        }
          var get_user_id = Int()
          var get_user_id_API = Int()
         get_user_id_API = Int((self.consumerBasic?.port_accountid)!)!
        get_user_id = (Login.loadCustomerInfoFromKeychain()?.id)!
        if (get_user_id == get_user_id_API) {
            view_FollowBrand.isHidden = true
            self.navigationItem.title = "MY Profile".uppercased()
            self.edit_Btn.title = "Edit"
            self.edit_Btn.isEnabled = true
        } else {
            view_FollowBrand.isHidden = false
            self.navigationItem.title = "@" + (self.consumerBasic?.username.uppercased())!
            self.edit_Btn.title = ""
            self.edit_Btn.isEnabled = false
        }
        
        btn_Likes.setTitle("LIKES (\(self.consumerBasic?.post_media.count ?? 0))", for: .normal)
        btn_Wishlist.setTitle("WISHLIST (\(self.consumerBasic?.wishlistinfo.count ?? 0))", for: .normal)
        btn_Reviews.setTitle("REVIEWS (\(self.consumerBasic?.reviewsInfo.count ?? 0))", for: .normal)
    
        self.setFollowersCountUI()
        self.setFollowUnfollowImages()
        lbl_Username.text = "@" + (self.consumerBasic?.username)!
        user_name_lbl.text = self.consumerBasic?.full_name
        user_des_lbl.text = self.consumerBasic?.bio
        
        self.user_image.image = UIImage(named:  Constants.USER_DUMMY_IMAGE)
        
        let userImageUrl = self.consumerBasic?.user_media ?? ""
      //  let userImageUrl = Login.loadCustomerInfoFromKeychain()?.profile_image ?? ""
        if userImageUrl != "" {
        let url = URL(string: userImageUrl)
        self.user_image.kf.setImage(with: url, placeholder: UIImage(named:Constants.USER_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
            }
        
        let get_revared = self.consumerBasic?.review_reward.uppercased()
        if (get_revared?.count)! > 0  {
            lbl_Rating.text = "$ " + (self.consumerBasic?.review_reward.uppercased())!
        } else {
            lbl_Rating.text = "reward".uppercased()
        }
        
        let get_referrals = self.consumerBasic?.followers.uppercased()
        if (get_referrals?.count)! > 0  {
            lbl_Followers.text = self.consumerBasic?.followers.uppercased()
        } else {
            lbl_Followers.text = "No Followers".uppercased()
        }
        
        let get_wishlist = self.consumerBasic?.wishlist_items_count.uppercased()
        if (get_wishlist?.count)! > 0  {
            lbl_Following.text = self.consumerBasic?.wishlist_items_count.uppercased()
        } else {
            lbl_Following.text = "wishlist".uppercased()
        }
        lbl_Rating.text = formatPriceToTwoDecimalPlace(amount: (self.consumerBasic?.review_cashback)!)
        strShareLink = (self.consumerBasic?.share_profile)!
        get_follow_id = (self.consumerBasic?.user_id)!
        
    }
    
    
    //MARK:- Custom Methods
    
    func removeChildViewControllersFromContainer() {
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
    }
    func addChildViewControllerToContainer(identifier: String) {
        removeChildViewControllersFromContainer()
        let storyboard = UIStoryboard(name: "ConsumerProfile", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        self.addChild(controller)
        self.scroll_Content.contentSize = CGSize(width: 0, height: 0)
        self.constraint_Contenteight.constant = 0
        self.view.layoutIfNeeded()
        print("containerView bounds:\(containerView.bounds)")
        controller.view.frame = containerView.bounds
        containerView.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    func getMainViewContentHeight() -> (CGFloat, CGFloat) {
        var safeAreaHeight:CGFloat = 0
        var topPadding:CGFloat = 0
        var bottomPadding:CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = window?.safeAreaInsets.top ?? 0
            bottomPadding = window?.safeAreaInsets.bottom ?? 0
            //print(tabBarController?.tabBar.bounds.height)
            //print(self.navigationController?.navigationBar.bounds.height)
        }
        if tabBarController?.tabBar != nil {
            safeAreaHeight = topPadding + (tabBarController?.tabBar.bounds.height)! + (self.navigationController?.navigationBar.bounds.height)!
        }else if self.navigationController?.navigationBar.bounds.height != nil {
            safeAreaHeight = topPadding + (self.navigationController?.navigationBar.bounds.height)! + bottomPadding
        } else {
            safeAreaHeight = topPadding + bottomPadding
        }
        
        let profileContentHeight: CGFloat = 300
        return (profileContentHeight, safeAreaHeight)
    }
    func showAlertWithMessage(message:String, title: String) {
        AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: title, message: message, btnTitle: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelOk"), viewController: self) { (success)
            in
        }
    }
    
    func ShareOnSocialMedia() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            if let fileUrl = URL(string: "https://uat-hubcn.wahhao.com/login") {
                self.downloadFileFromUrl(fileUrl: fileUrl)
            }
        }
    }
    func setFollowersCountUI() {
        var get_Followers = String()
        get_Followers = self.consumerBasic?.followers ?? "0"
        if get_Followers == "0"{
            lbl_Followers.text = "No Followers"
        } else {
            lbl_Followers.text = (self.consumerBasic?.followers)
        }
    }
    func setFollowUnfollowImages() {
        if self.consumerBasic == nil
        {
            return
        }
        if self.consumerBasic?.is_following ?? false {
             img_FollowBrand.image = UIImage(named: "plus_icon_b_2")
        }else {
            img_FollowBrand.image = UIImage(named: "plus_icon_b")
        }
    }
    func downloadFileFromUrl(fileUrl: URL) {
        var isUrlData = false
        if let fileData = NSData.init(contentsOf: fileUrl) {
            isUrlData = true
            let activityViewController:UIActivityViewController = UIActivityViewController(activityItems:  [fileData], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [.postToVimeo, .postToWeibo, .postToFlickr, .postToTwitter, .airDrop,.assignToContact]
            self.present(activityViewController, animated: true, completion: nil)
            //Hide Loader
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                SVProgressHUD.dismiss()
            }
        }
        if isUrlData == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                SVProgressHUD.dismiss()
            }
        }
    }
    //MARK:- Button Methods
     @IBAction func backTapped(_ sender: Any) {
        if self.isPresented == true {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }else {
            self.dismissView()
        }
    }
    func dismissView() {
        if self.isPresentedView
        {
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromBottom
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            self.navigationController?.popViewController(animated: false)
        }
    }
    @IBAction func followBrandTapped(_ sender: Any) {
        if self.consumerBasic == nil
        {
            return
        }
        if self.consumerBasic?.is_following ?? false {
            self.brandUnfollow()
        }else {
            self.brandfollowAPI()
        }
    }
    @IBAction func Wishlist_Tapped(_ sender: Any) {
        btn_Wishlist.setTitleColor(#colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1), for: .normal)
        btn_Reviews.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        btn_Likes.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        var fontSize: CGFloat
        if UIDevice().SCREEN_TYPE == .iPhone4 || UIDevice().SCREEN_TYPE == .iPhone5E {
            fontSize = 12
        }else {
            fontSize = 14
        }
        btn_Wishlist.titleLabel?.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: fontSize)
        btn_Reviews.titleLabel?.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: fontSize)
        btn_Likes.titleLabel?.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: fontSize)
        addChildViewControllerToContainer(identifier: "ConsumerProfileWishlistVC")
        if let childVC = self.children[0] as? ConsumerProfileWishlistVC {
            if self.consumerBasic != nil
            {
                childVC.passDataToBaseView(ConsumerProfile: self.consumerBasic!)
            }
           // DispatchQueue.main.async {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            if let childVC = self.children[0] as? ConsumerProfileWishlistVC {
                let childContentHeight = childVC.collection_Wishlist.contentSize.height
                print(childContentHeight)
                let conainerWithOtherSpacing = self.getMainViewContentHeight()
                let mainContentHeight:CGFloat = conainerWithOtherSpacing.0
                let otherSpacing = conainerWithOtherSpacing.1
                self.scroll_Content.contentSize = CGSize(width: 0, height: mainContentHeight+childContentHeight)
                let contentHeight = self.scroll_Content.contentSize.height - (self.view.bounds.height-(otherSpacing+10))
                if contentHeight >= 0 {
                    self.constraint_Contenteight.constant = contentHeight
                }
            }
         }
        }
    }
    @IBAction func reviewsTapped(_ sender: Any) {
        btn_Wishlist.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        btn_Reviews.setTitleColor(#colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1), for: .normal)
        btn_Likes.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        var fontSize: CGFloat
        if UIDevice().SCREEN_TYPE == .iPhone4 || UIDevice().SCREEN_TYPE == .iPhone5E {
            fontSize = 12
        }else {
            fontSize = 14
        }
        btn_Wishlist.titleLabel?.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: fontSize)
        btn_Reviews.titleLabel?.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: fontSize)
        btn_Likes.titleLabel?.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: fontSize)
        addChildViewControllerToContainer(identifier: "ConsumerProfileReviewVC")
        if let childVC = self.children[0] as? ConsumerProfileReviewVC {
            if self.consumerBasic != nil
            {
                childVC.passDataToBaseView(ConsumerProfile: self.consumerBasic!)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
                if let childVC = self.children[0] as? ConsumerProfileReviewVC {
                    let childContentHeight = childVC.collection_View_Review.contentSize.height
                    print(childContentHeight)
                    let conainerWithOtherSpacing = self.getMainViewContentHeight()
                    let mainContentHeight:CGFloat = conainerWithOtherSpacing.0
                    let otherSpacing = conainerWithOtherSpacing.1
                    self.scroll_Content.contentSize = CGSize(width: 0, height: mainContentHeight+childContentHeight)
                    let contentHeight = self.scroll_Content.contentSize.height - (self.view.bounds.height-(otherSpacing+10))
                    if contentHeight >= 0 {
                        self.constraint_Contenteight.constant = contentHeight
                    }
                }
            }
        }
    }
    @IBAction func Likes_Tapped(_ sender: Any) {
        btn_Wishlist.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        btn_Reviews.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        btn_Likes.setTitleColor(#colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1), for: .normal)
        var fontSize: CGFloat
        if UIDevice().SCREEN_TYPE == .iPhone4 || UIDevice().SCREEN_TYPE == .iPhone5E {
            fontSize = 12
        }else {
            fontSize = 14
        }
        btn_Wishlist.titleLabel?.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: fontSize)
        btn_Reviews.titleLabel?.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: fontSize)
        btn_Likes.titleLabel?.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: fontSize)
        addChildViewControllerToContainer(identifier: "ConsumerProfileLikeVC")
        if let childVC = self.children[0] as? ConsumerProfileLikeVC {
            if self.consumerBasic != nil
            {
                childVC.passDataToBaseView(ConsumerProfile: self.consumerBasic!)
            }
         DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            if let childVC = self.children[0] as? ConsumerProfileLikeVC {
                let childContentHeight = childVC.collection_Likes.contentSize.height
                print(childContentHeight)
                let conainerWithOtherSpacing = self.getMainViewContentHeight()
                let mainContentHeight:CGFloat = conainerWithOtherSpacing.0
                let otherSpacing = conainerWithOtherSpacing.1
                self.scroll_Content.contentSize = CGSize(width: 0, height: mainContentHeight+childContentHeight)
                let contentHeight = self.scroll_Content.contentSize.height - (self.view.bounds.height-(otherSpacing+10))
                if contentHeight >= 0 {
                    self.constraint_Contenteight.constant = contentHeight
                }
            }
        }
        }
    }
    
    @IBAction func followersTapped(_ sender: Any) {
        if consumerBasic == nil
        {
            return
        }
        followerButtonTap  = true
        let storyboard = UIStoryboard(name: "ConsumerProfile", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "ConsumerFollowersVC") as! ConsumerFollowersVC
        vcObj.user_id = (self.consumerBasic?.user_id)!
        self.navigationController?.pushViewController(vcObj, animated: false)
        
      //  self.performSegue(withIdentifier: "ConsumerFollowersVC", sender: self)
    }
    @IBAction func Edit_Profile_Tapped(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        let storyboard = UIStoryboard(name: "ConsumerProfile", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "CounsumerEditProfileVC") as! CounsumerEditProfileVC
        vcObj.consumerBasic = self.consumerBasic
        vcObj.editProfileDismissDelegate = self
        self.navigationController?.pushViewController(vcObj, animated: false)
    }
    @IBAction func followingTapped(_ sender: Any) {
        followerButtonTap  = false
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        createContentReference()
    }
    
    //MARK:- DeepLinking
    
    func createContentReference() {
        let buo = BranchUniversalObject.init(canonicalIdentifier: "content/12345")
        buo.title = "My Profile"
        // buo.contentDescription = "My Content Description"
        // buo.imageUrl = "https://lorempixel.com/400/400"
        buo.publiclyIndex = true
        buo.locallyIndex = true
        buo.contentMetadata.customMetadata["profileID"] = getUseridStr
        
        //LinkReference
        
        //  lp.channel = "facebook"
        lp.feature = "sharing"
        // lp.campaign = "content 123 launch"
        // lp.stage = "new user"
        //  lp.tags = ["one", "two", "three"]
        
        // lp.addControlParam("$desktop_url", withValue: "http://example.com/desktop")
        // lp.addControlParam("$ios_url", withValue: "http://example.com/ios")
        //  lp.addControlParam("$ipad_url", withValue: "http://example.com/ios")
        // lp.addControlParam("$android_url", withValue: "http://example.com/android")
        // lp.addControlParam("$match_duration", withValue: "2000")
        
        // lp.addControlParam("custom_data", withValue: "yes")
        //  lp.addControlParam("look_at", withValue: "this")
        lp.addControlParam("navigate_to", withValue: "consumerProfile")
        // lp.addControlParam("random", withValue: UUID.init().uuidString)
        
        //createdeepLink
        
        buo.getShortUrl(with: lp) { (url, error) in
            self.deepLinkUrl = url ?? ""
        }
        let message = "This Wahhao user is really cool. Check out his profile"
        UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: UIColor.color(.appThemeColor)), for: .default)

        buo.showShareSheet(with: lp, andShareText: message, from: self) { (activityType, completed) in
            print(activityType ?? "")
            UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: UIColor.clear), for: .default)

            //stuff stuff
        }
    }
}

//MARK:- Scroll View Delegate
extension ConsumerProfileVC : UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.lastContentOffset = scrollView.contentOffset.y
        if self.lastContentOffset < -20 {
            self.dismissView()
        }
    }
}



extension ConsumerProfileVC {
 func getProfileData() {
  store.fetchProfileData(value: getUseridStr,showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
          //your Success block
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.consumerBasic = self.store.ConsumerProfile
                self.prefillData()
                let btn = UIButton()
                if self.btn_Reviews.titleLabel?.textColor == #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1) {
                    self.reviewsTapped(btn)
                }else if self.btn_Wishlist.titleLabel?.textColor == #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1) {
                    self.Wishlist_Tapped(btn)
                }else {
                    self.Likes_Tapped(btn)
                }
            }
            print("success")
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
}
    func brandfollowAPI() {
        store.callFollowBrandAPI(parameters: ["user_id":self.get_follow_id], showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any] {
                print(success)
                print("success")
                self.consumerBasic?.is_following = true
                if let result = success as? [String: Any] {
                    if let response = result["response"] as? NSDictionary {
                        if let user_id_value  = response["user_id"]
                        {
                             self.consumerBasic?.user_id = "\(String(describing: user_id_value))"
                        }
                        if let countValue  = response["follower_count"]
                        {
                            self.consumerBasic?.followers = "\(String(describing: countValue))"
                            self.setFollowersCountUI()
                        }
                    }
                }
                self.setFollowUnfollowImages()
            }
        }) { (failure) -> Void in
            self.handleAPIError(failure: failure)
        }
    }
    
    func brandUnfollow()
    {
        store.callUnFollowBrandAPI(parameters: ["user_id":self.get_follow_id], showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any]
            {
                print(success)
                print("success")
                self.consumerBasic?.is_following = false
                if let result = success as? [String: Any] {
                    if let response = result["response"] as? NSDictionary {
                        if let user_id_value  = response["user_id"]
                        {
            self.consumerBasic?.user_id = "\(String(describing: user_id_value))"
                        }
                        if let countValue  = response["follower_count"]
                        {
                            self.consumerBasic?.followers = "\(String(describing: countValue))"
                            self.setFollowersCountUI()
                        }
                    }
                }
                self.setFollowUnfollowImages()
            }
        }) { (failure) -> Void in
            self.handleAPIError(failure: failure)
        }
    }
}
