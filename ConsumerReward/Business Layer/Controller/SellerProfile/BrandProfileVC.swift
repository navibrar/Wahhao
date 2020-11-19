//  Created by apple on 6/22/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit
import SVProgressHUD
import Branch

class BrandProfileVC: UIViewController {
    
    //MARK:- Variable Declaration
    private var lastContentOffset: CGFloat = 0
    var navigatedFrom = String()
    let store = BrandProfileServices.sharedInstance

    var brand: BrandBasicInfo? = nil
    var brandProfile: BrandProfile? = nil

    var array_ProfileImage = [NSDictionary]()
    var array_Following = [NSDictionary]()

    var strShareLink = ""
    var containerInitialBounds = CGRect()
    var dict_Localized = [String:String]()
    var selectedTabIndex = Int()
    var followerButtonTap = Bool()
    var get_brand_id = String()
    var isPresented: Bool = false
    
    //DeepLink
    let lp: BranchLinkProperties = BranchLinkProperties()
    var deepLinkUrl  = String()
   
    //MARK:- Outlet Connections
    @IBOutlet weak var view_FollowBrand: UIView!
    @IBOutlet weak var img_FollowBrand: UIImageView!
    @IBOutlet weak var lbl_Share: UILabel!
    @IBOutlet weak var btn_Store: UIButton!
    @IBOutlet weak var btn_Reviews: UIButton!
    @IBOutlet weak var btn_Videos: UIButton!
    @IBOutlet weak var scroll_Content: UIScrollView!
    @IBOutlet weak var view_Content: UIView!
    @IBOutlet weak var constraint_Contenteight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    
    @IBOutlet weak var user_name_lbl: UILabel!
    @IBOutlet weak var user_des_lbl: UILabel!
    @IBOutlet weak var lbl_Username: UILabel!
    @IBOutlet weak var user_image: UIImageView!
    
    @IBOutlet weak var lbl_Rating: UILabel!
    @IBOutlet weak var lbl_Followers: UILabel!
    @IBOutlet weak var lbl_bought_products: UILabel!
    
     @IBOutlet weak var img_Rating: UIImageView!
     @IBOutlet weak var img_Followers: UIImageView!
     @IBOutlet weak var img_Shop_Count: UIImageView!
     @IBOutlet weak var img_Share: UIImageView!

    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedTabIndex = 0
         view_FollowBrand.roundCorners([.topLeft], radius: 6)
        // Mark: - Get info Disply from Home feed & Shown here Repllace Later
        scroll_Content.delegate = self
        self.scroll_Content.contentSize = CGSize(width: 0, height: (self.view.bounds.width * 1.565) + 167)
        let contentHeight = self.scroll_Content.contentSize.height - (self.view.bounds.width * 1.565)
        if contentHeight > 0 {
            self.constraint_Contenteight.constant = contentHeight
        }
        
        self.initialSetup()
        if get_brand_id.count > 0 {
            self.getProfileData(brand_id: get_brand_id)
        } else {
            self.getProfileData(brand_id: self.brand!.brand_id)
        }
        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipedown.direction = UISwipeGestureRecognizer.Direction.down
        self.view_Content.addGestureRecognizer(swipedown)
    }
    
    //MARK:- Gesture Method
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
    
    func initialSetup() {
        if brand != nil{
            self.navigationItem.title = brand?.displayName.uppercased()
            self.user_des_lbl.text = brand?.details_bio
            self.user_name_lbl.text = brand?.displayName
            self.lbl_Username.text = brand?.username
            self.user_image.image = UIImage(named:  Constants.USER_DUMMY_IMAGE)

            let userImageUrl = brand?.brandImage ?? ""
            if userImageUrl != "" {
                let url = URL(string: userImageUrl)
                self.user_image.kf.setImage(with: url, placeholder: UIImage(named:Constants.USER_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
            }
            btn_Store.setTitle("STORE (0)", for: .normal)
            btn_Videos.setTitle("POST (0)", for: .normal)
            btn_Reviews.setTitle("REVIEWS (0)", for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: UIColor.clear), for: .default)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: UIColor.clear), for: .default)
    }
   
    func prefillData() {
        btn_Store.setTitle("STORE (\(self.brandProfile?.store_media.count ?? 0))", for: .normal)
        btn_Videos.setTitle("POST (\(self.brandProfile?.post_media.count ?? 0))", for: .normal)
        btn_Reviews.setTitle("REVIEWS (\(self.brandProfile?.reviews.count ?? 0))", for: .normal)
        
        var get_Rating = String()
        get_Rating = self.brandProfile?.profile_details.rating ?? "0"
        if get_Rating == "0"{
             lbl_Rating.text = "No Rating"
            img_Rating.image = UIImage(named: "star_icon_seller")
        } else {
            lbl_Rating.text = self.brandProfile?.profile_details.rating
            img_Rating.image = UIImage(named: "star_icon_select")
        }
        self.setFollowersCountUI()
        lbl_bought_products.text = self.brandProfile?.profile_details.bought
        lbl_Share.text = "Share".uppercased()
        strShareLink = self.brandProfile?.profile_details.share_url ?? ""
        
        self.navigationItem.title = self.brandProfile?.profile_details.displayName.uppercased()
        self.user_des_lbl.text = self.brandProfile?.profile_details.details_bio
        self.user_name_lbl.text = self.brandProfile?.profile_details.displayName
        self.lbl_Username.text = self.brandProfile?.profile_details.username
        self.user_image.image = UIImage(named:  Constants.USER_DUMMY_IMAGE)

        let userImageUrl = self.brandProfile?.profile_details.brandImage ?? ""
        if userImageUrl != "" {
            let url = URL(string: userImageUrl)
            self.user_image.kf.setImage(with: url, placeholder: UIImage(named:Constants.USER_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }
        self.setFollowUnfollowImages()
    }
    func setFollowersCountUI() {
        var get_Followers = String()
        get_Followers = self.brandProfile?.profile_details.followers ?? "0"
        if get_Followers == "0"{
            lbl_Followers.text = "0"
        } else {
            lbl_Followers.text = self.brandProfile?.profile_details.followers
        }
    }
    func setFollowUnfollowImages() {
        if self.brandProfile != nil
        {
            if self.brandProfile?.profile_details != nil
            {
                if self.brandProfile?.profile_details.is_following ?? false {
                    img_FollowBrand.image = UIImage(named: "plus_icon_b_2")
                }else {
                    img_FollowBrand.image = UIImage(named: "plus_icon_b")
                }
            }
        }
        
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
        let storyboard = UIStoryboard(name: "SellerProfile", bundle: nil)
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
        }
        if tabBarController?.tabBar != nil {
            safeAreaHeight = topPadding + (tabBarController?.tabBar.bounds.height)! + (self.navigationController?.navigationBar.bounds.height)!
        } else if self.navigationController?.navigationBar.bounds.height != nil {
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
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        if self.isPresented == true {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }else {
            self.dismissView()
        }
    }
    
    func dismissView() {
        if self.isPresented {
            self.dismiss(animated: true, completion: nil)
        }else {
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
        if self.brandProfile != nil{
            if self.brandProfile?.profile_details != nil{

                if self.brandProfile?.profile_details.is_following ?? false {
                self.brandUnfollow()
            }else {
                self.brandfollowAPI()
            }
            }
        }
    }
    
    @IBAction func storeTapped(_ sender: Any) {
        btn_Store.setTitleColor(#colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1), for: .normal)
        btn_Reviews.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        btn_Videos.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        var fontSize: CGFloat
        if UIDevice().SCREEN_TYPE == .iPhone4 || UIDevice().SCREEN_TYPE == .iPhone5E {
            fontSize = 12
        }else {
            fontSize = 14
        }
        btn_Store.titleLabel?.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: fontSize)
        btn_Reviews.titleLabel?.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: fontSize)
        btn_Videos.titleLabel?.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: fontSize)
        addChildViewControllerToContainer(identifier: "ProfileStoreVC")
         if let childVC = self.children[0] as? ProfileStoreVC {
            if self.brandProfile != nil
            {
                childVC.passDataToBaseView(brandProfile: self.brandProfile!)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
                 if let childVC = self.children[0] as? ProfileStoreVC {
                let childContentHeight = childVC.collection_view.contentSize.height
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
    
    @IBAction func reviewsTapped(_ sender: Any) {
        btn_Store.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        btn_Reviews.setTitleColor(#colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1), for: .normal)
        btn_Videos.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        var fontSize: CGFloat
        if UIDevice().SCREEN_TYPE == .iPhone4 || UIDevice().SCREEN_TYPE == .iPhone5E {
            fontSize = 12
        }else {
            fontSize = 14
        }
        btn_Store.titleLabel?.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: fontSize)
        btn_Reviews.titleLabel?.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: fontSize)
        btn_Videos.titleLabel?.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: fontSize)
        addChildViewControllerToContainer(identifier: "ProfileReviewsVC")
        
        if let childVC = self.children[0] as? ProfileReviewsVC {
           if self.brandProfile != nil
            {
                childVC.passDataToBaseView(brandProfile: self.brandProfile!)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            if let childVC = self.children[0] as? ProfileReviewsVC {
                let childContentHeight = childVC.collection_view.contentSize.height
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
    
    @IBAction func videosTapped(_ sender: Any) {
        btn_Store.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        btn_Reviews.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        btn_Videos.setTitleColor(#colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1), for: .normal)
        var fontSize: CGFloat
        if UIDevice().SCREEN_TYPE == .iPhone4 || UIDevice().SCREEN_TYPE == .iPhone5E {
            fontSize = 12
        }else {
            fontSize = 14
        }
        btn_Store.titleLabel?.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: fontSize)
        btn_Reviews.titleLabel?.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: fontSize)
        btn_Videos.titleLabel?.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: fontSize)
        addChildViewControllerToContainer(identifier: "ProfilePostsVC")
        if let childVC = self.children[0] as? ProfilePostsVC {
            if self.brandProfile != nil
            {
                childVC.passDataToBaseView(brandProfile: self.brandProfile!)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            if let childVC = self.children[0] as? ProfilePostsVC {
                let childContentHeight = childVC.collection_view.contentSize.height
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
    
    @IBAction func followersTapped(_ sender: Any) {
        if self.brandProfile != nil
        {
            if self.brandProfile?.profile_details != nil
            {
                if self.brandProfile?.profile_details.follow_user_id != nil
                {
                    followerButtonTap  = true
                    self.performSegue(withIdentifier: "UserFollowingVC", sender: self)
                }
            }
        }
    }
    
    @IBAction func soldItemsTapped(_ sender: Any) {
        followerButtonTap  = false
        //self.performSegue(withIdentifier: "UserFollowingVC", sender: self)
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        createContentReference()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserFollowingVC" {
            if let nextView = segue.destination as? UserFollowingVC {
                nextView.user_id = (self.brandProfile?.profile_details.follow_user_id)!
            }
        }
    }
    
    //MARK:- DeepLinking
    func createContentReference() {
        let buo = BranchUniversalObject.init(canonicalIdentifier: "content/12345")
        buo.title = "My Profile"
        // buo.contentDescription = "My Content Description"
        // buo.imageUrl = "https://lorempixel.com/400/400"
        buo.publiclyIndex = true
        buo.locallyIndex = true
        buo.contentMetadata.customMetadata["brandID"] = self.brand?.brand_id
        
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
        lp.addControlParam("navigate_to", withValue: "sellerProfile")
        // lp.addControlParam("random", withValue: UUID.init().uuidString)
        
        //createdeepLink
        
        buo.getShortUrl(with: lp) { (url, error) in
            self.deepLinkUrl = url ?? ""
        }
        UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: UIColor.color(.appThemeColor)), for: .default)
        let message = "This Wahhao seller is really cool. Check out his profile"
        buo.showShareSheet(with: lp, andShareText: message, from: self) { (activityType, completed) in
            print(activityType ?? "")
            UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: UIColor.clear), for: .default)
        }
    }
}

//MARK:- Scroll View Delegate
extension BrandProfileVC : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /*self.lastContentOffset = scrollView.contentOffset.y
         if self.lastContentOffset >= 35 {
         if (self.title?.count)! <= 0 {
         let fadeTextAnimation = CATransition()
         fadeTextAnimation.duration = 0.5
         fadeTextAnimation.type = kCATransitionFade
         navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
         //self.title = getinfo?.BrandName
         self.title = "pidan"
         }
         }else {
         if (self.title?.count)! > 0 {
         let fadeTextAnimation = CATransition()
         fadeTextAnimation.duration = 0.5
         fadeTextAnimation.type = kCATransitionFade
         navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
         self.title = ""
         }
         }*/
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.lastContentOffset = scrollView.contentOffset.y
        if self.lastContentOffset < -20 {
            self.dismissView()
        }
    }

}

//MARK:- API METHODS
extension BrandProfileVC {
    func getProfileData(brand_id : String) {
        store.fetchBrandProfileInfo(value:brand_id,showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            //Success block
            print(success)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.brandProfile = self.store.brandProfile
                self.prefillData()
                let btn = UIButton()
                self.videosTapped(btn)
            }
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    
    func brandfollowAPI() {
        store.callFollowBrandAPI(parameters: ["user_id":self.brandProfile?.user_id ?? ""], showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any] {
                print(success)
                print("success")
                self.brandProfile?.profile_details.is_following = true
                if let result = success as? [String: Any] {
                    if let response = result["response"] as? NSDictionary {
                        if let user_id_value  = response["user_id"]
                        {
                            self.brandProfile?.user_id = "\(String(describing: user_id_value))"
                        }
                        if let countValue  = response["follower_count"]
                        {
                            self.brandProfile?.profile_details.followers = "\(String(describing: countValue))"
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
        store.callUnFollowBrandAPI(parameters: ["user_id":self.brandProfile?.user_id ?? ""], showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any]
            {
                print(success)
                print("success")
                self.brandProfile?.profile_details.is_following = false
                if let result = success as? [String: Any] {
                    if let response = result["response"] as? NSDictionary {
                        if let user_id_value  = response["user_id"]
                        {
                            self.brandProfile?.user_id = "\(String(describing: user_id_value))"
                        }
                        if let countValue  = response["follower_count"]
                        {
                            self.brandProfile?.profile_details.followers = "\(String(describing: countValue))"
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
