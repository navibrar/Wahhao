//
//  HomePostViewController.swift
//  Consumer
//
//  Created by apple on 11/24/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import AVKit
import QuartzCore
import CoreMedia
import Kingfisher
import FacebookLogin

class HomePostViewController: UIViewController {
    //Menu
    @IBOutlet weak var lbl_MenuCashout: UILabel!
    @IBOutlet weak var btn_MenuCashout: UIButton!
    
    //HOME FEED OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tutorialView: UIView!
    @IBOutlet var pickerView: AKPickerView!
    @IBOutlet weak var tutorialImageView: UIImageView!
    @IBOutlet weak var infoTopView: UIView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var userImageButton: UIButton!
    
    //USER MENU OUTLETS
    @IBOutlet weak var userMenuLeadingconstraint: NSLayoutConstraint!
    @IBOutlet weak var userMenuTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userMenuInnerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var userMenuInnerViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userMenuTableView: UITableView!
    @IBOutlet weak var userProfileMenuImageView: UIImageView!
    @IBOutlet weak var userProfileMenuName: UIButton!
    
    var postsListArray = [HomePost]()
    var userHomePostData: UserHomePost? = nil

    fileprivate var interactionController: UIPercentDrivenInteractiveTransition?
    var selectedCell : HomePostCollectionViewCell? = nil
    var selectedIndex = Int()
    var getindex = Int()
    
    var all_categories_list: [Category] = []
    var tabSelected = "1"
    var page = 0

    var all_categories_setup = false
    var get_consumer_id = String()
    let store = HomePostServices.sharedInstance
    let store_order = OrderInfoService.sharedInstance
    let defaults = UserDefaults.standard
    let cellReuseIdentifier = "UserMenuTableViewCell"
    var namesList: [String] = ["NOTIFICATIONS","ORDERS","referral tracker","PAYMENTS & SHIPPING","SETTINGS","RATE US","FAQ & HELP","Wahhao Support","Sign out"]
    var imagesList: [String] = ["Notifications","MyOrder","share_win","payment_shipping", "Settings","rate_us","faq","contactUs","signout_icon"]
    //UserMenu
    var notificationCount: Int = 0
    var cashoutBalance: Float = 0.0
    var unreviewedOrdersCount: Int = 0
    var like_image_array = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //like images
        like_image_array.append(UIImage(named: "1")!)
        like_image_array.append(UIImage(named: "2")!)
        like_image_array.append(UIImage(named: "3")!)
        like_image_array.append(UIImage(named: "4")!)
        like_image_array.append(UIImage(named: "5")!)
        like_image_array.append(UIImage(named: "6")!)
        like_image_array.append(UIImage(named: "6")!)
        
        self.pickerView.isHidden = true
        self.userImageButton.setImage(UIImage(named:  Constants.USER_DUMMY_IMAGE), for: .normal)
        fetchHomePostsList()
        let getUserName = Login.loadCustomerInfoFromKeychain()?.username
        if getUserName!.count > 0 {
            userProfileMenuName.setTitle(getUserName, for: .normal)
        }
        collectionView.bounces = false
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            collectionView.collectionViewLayout = layout
        }
        self.automaticallyAdjustsScrollViewInsets = false
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.reloadData()
        userMenuTableView.tableFooterView = UIView()
        moveToUserMenu(visible : true)

        
        //SWIPE GESTURES
        let swipeup = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeup.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(swipeup)

        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipedown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipedown)
        
        DispatchQueue.main.async {
//            self.showGifView()
        }
        self.hideGifView()
        NOTIFICATIONCENTER.addObserver(self, selector: #selector(self.updateCartCount), name: NSNotification.Name(rawValue: "UpdateCartCount"), object: nil)
        NOTIFICATIONCENTER.addObserver(self, selector: #selector(self.pauseVideo(note:)), name: Notification.Name(rawValue: "pauseVideo"), object: nil)
        
        FirAnalytics.trackPageView(withScreen: FirAnalytics.Screen.homeFeed)
        // your successful handle
      

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        get_consumer_id = ""
        self.navigationController?.isNavigationBarHidden = true
        self.updateCartCount()
        let userImageUrl = Login.loadCustomerInfoFromKeychain()?.profile_image ?? ""
        if userImageUrl != "" {
            let url = URL(string: userImageUrl)
            self.userImageButton.kf.setImage(with: url, for: .normal, placeholder: UIImage(named:Constants.USER_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
            self.userProfileMenuImageView.kf.setImage(with: url, placeholder: UIImage(named:Constants.USER_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerinforground(note:)),name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.pauseVideo(note:)),name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.pauseVideo(note:)),name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerinforground(note:)),name: UIApplication.didBecomeActiveNotification, object: nil)
        
        NOTIFICATIONCENTER.addObserver(self, selector: #selector(closeMenu), name: NSNotification.Name("UpdateUI"), object: nil)

        if userMenuLeadingconstraint.constant != 0
        {
            self.playVideo(tapToPlay: false)
        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        self.pauseVideo()
    }
    @objc func closeMenu(note: NSNotification) {
        moveToUserMenu(visible : true)
    }
    func refreshHomePostsList() {
        self.page = 0
        fetchHomePostsList()
    }

    func setupTopCategoryPickerView() {
        super.viewDidLoad()
        self.pickerView.isHidden = false
        self.pickerView.backgroundColor = UIColor.clear
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.highlightedFont = UIFont(name: Constants.SEMI_BOLD_FONT, size: 18)!
        self.pickerView.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: 18)!
        self.pickerView.textColor = .lightText
        self.pickerView.highlightedTextColor = .white
        self.pickerView.pickerViewStyle = .wheel
        self.pickerView.maskDisabled = false
        self.pickerView.reloadData()
        if !all_categories_setup
        {
            all_categories_setup = true
            for index in 0..<self.all_categories_list.count
            {
                if all_categories_list[index].displayName.uppercased() == "POPULAR"
                {
                    self.pickerView.selectItem(index)
                }
            }
        }
    }
    
    @objc func handleSingleTap() {
        print("Single Tap!")
        //print("Tap here for Pause & Play")
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count > 0 {
            getindex = indexPathItem[0].item
        }
        else{
            return
        }
        let tag = self.getindex
        let indexPath = IndexPath(row: tag, section: 0)
        let value = self.postsListArray[indexPath.row]
        if value.videoURL != ""
        {
            if let cell = collectionView.cellForItem(at: indexPath) as? HomePostCollectionViewCell
            {
                if(cell.avPlayer.timeControlStatus == AVPlayer.TimeControlStatus.playing)
                {
                    self.pauseVideo()
                }
                else if(cell.avPlayer.timeControlStatus==AVPlayer.TimeControlStatus.paused)
                {
                    self.playVideo(tapToPlay: true)
                }
            }
        }
    }
    @objc func handleDoubleTap() {
        print("Double Tap!")
        FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.homeFeed, category: FirAnalytics.Category.homeFeed, label: FirAnalytics.Label.homefeed_doubletap_like, action: FirAnalytics.Actions.doubleTapLike, value: 1)
         let indexPathItem = collectionView.indexPathsForVisibleItems
        if let cell = collectionView.cellForItem(at: indexPathItem[0]) as? HomePostCollectionViewCell
        {
            //Disable LIKE/UNLIKE buttons
             if !cell.likeButton.isUserInteractionEnabled
             {
                return
             }
             else
             {
                self.likeTapped(isLikeButtonTap: false)
            }
        }
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        let indexPath = collectionView.indexPathsForVisibleItems
        if indexPath.count > 0 {
            getindex = indexPath[0].item
        }
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                //print("move Down")
                 self.pauseVideo()
                self.refreshHomePostsList()
                
            case UISwipeGestureRecognizer.Direction.up:
                //print("move up")
                  FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.homeFeed, category: FirAnalytics.Category.homeFeed, label: FirAnalytics.Label.homefeed_profile_swiped, action: FirAnalytics.Actions.swipeUp, value: 1)
                if postsListArray.count <= 0
                {
                    return
                }
                
                let tag = self.getindex
                let indexPath = IndexPath(row: tag, section: 0)
                
                let post = self.postsListArray[indexPath.row]
                get_consumer_id = post.consumer_profile_id
                if self.postsListArray[indexPath.row].showSellerProfile == false {
                    let btn = UIButton()
                    self.moveToConusmerProfile(btn)
                } else {
                    self.moveToSellerProfile()
                }
                
            default:
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        //print("Video Finished")
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count > 0 {
            let cell = collectionView.cellForItem(at: indexPathItem[0]) as? HomePostCollectionViewCell
            cell?.avPlayer.seek(to: CMTime.zero)
        }
        //selectedCell?.avPlayer.seek(to: CMTime.zero)
//        selectedCell?.avPlayer.play()
    }
    
    @objc func playerinforground(note: NSNotification) {
        //print("Video Finished")
        self.playVideo(tapToPlay: false)
    }
    
    @objc func pauseVideo(note: NSNotification)
    {
        self.pauseVideo()
    }
    
    func showGifView() {
//        let timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.hideGifView), userInfo: nil, repeats: false)
//        let jeremyGif = UIImage.gifImageWithName("wahhao_gif_4")
//        tutorialImageView.image = jeremyGif
        tutorialView.isHidden = false
    }
    
    @objc func hideGifView() {
        tutorialImageView.image = nil
        tutorialView.isHidden = true
    }
    
    @objc func finishVideo(_ sender: UIButton)
    {
        let tag = sender.tag
        let indexPath = IndexPath(row: tag, section: 0)
        let cell = collectionView.cellForItem(at: indexPath) as? HomePostCollectionViewCell
        cell?.avPlayer.seek(to: CMTime.zero)
        cell?.avPlayer.play()
        //print("Video Finished")
    }
    
    func pauseVideo()
    {
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count > 0 {
            getindex = indexPathItem[0].item
        }
        else{
            return
        }
        let tag = self.getindex
        let indexPath = IndexPath(row: tag, section: 0)
        let value = self.postsListArray[indexPath.row]
        if value.videoURL != ""
        {
            if let cell = collectionView.cellForItem(at: indexPathItem[0]) as? HomePostCollectionViewCell {
                if(cell.avPlayer.timeControlStatus == AVPlayer.TimeControlStatus.playing)
                {
                    cell.play_icon_imageview.isHidden = false
                    cell.play_icon_imageview.image = UIImage(named: "play_icon")
                    cell.avPlayer.pause()
                    
                    self.infoTopView.alpha = 0
                    cell.itemInfoTopView.alpha = 0
                    cell.itemInfoBottomView.alpha = 0
                    cell.shadowImageView.alpha = 0
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        self.infoTopView.alpha = 1
                        cell.itemInfoTopView.alpha = 1
                        cell.itemInfoBottomView.alpha = 1
                        cell.shadowImageView.alpha = 1
                        
                    }, completion: {
                        finished in
                    })
                }
                cell.avPlayer.pause()
            }
        }
    }
    
    func playVideo(tapToPlay:Bool)
    {
        if self.postsListArray.count == 0
        {
            return
        }
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count > 0 {
            getindex = indexPathItem[0].item
        }
        else
        {
            return
        }

        let tag = self.getindex
        let indexPath = IndexPath(row: tag, section: 0)
        let value = self.postsListArray[indexPath.row]
        if value.videoURL != ""
        {
            if let cell = collectionView.cellForItem(at: indexPath) as? HomePostCollectionViewCell
            {
                if(cell.avPlayer.timeControlStatus==AVPlayer.TimeControlStatus.paused)
                {
                    cell.play_icon_imageview.image = UIImage(named: "")
                    cell.play_icon_imageview.image = nil
                    cell.play_icon_imageview.isHidden = true
                    cell.avPlayer.play()
                    self.infoTopView.alpha = 1
                    cell.itemInfoTopView.alpha = 1
                    cell.itemInfoBottomView.alpha = 1
                    cell.shadowImageView.alpha = 1

                    if tapToPlay
                    {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.infoTopView.alpha = 0
                            cell.itemInfoTopView.alpha = 0
                            cell.itemInfoBottomView.alpha = 0
                            cell.shadowImageView.alpha = 0
                        }, completion: {
                            finished in
                        })
                    }
                }
            }
        }
    }
    
    @objc func updateCartCount()
    {
        //print("Tap here for Pause & Play")
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count > 0 {
            getindex = indexPathItem[0].item
        }
        else{
            return
        }
        let tag = self.getindex
        let indexPath = IndexPath(row: tag, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? HomePostCollectionViewCell
        {
            let countValue = Login.loadCustomerInfoFromKeychain()?.total_cart_items ?? 0
            cell.cartCountLabel.text = "\(countValue)"
            if countValue > 0
            {
                cell.view_CartItemCount.isHidden = false
            }
            else
            {
                cell.view_CartItemCount.isHidden = true
            }
        }
    }
    
    @IBAction func awardButtonTapped(_ sender: UIButton) {
      self.pauseVideo()
       FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.homeFeed, category: FirAnalytics.Category.homeFeed, label: FirAnalytics.Label.homefeed_rewards_tapped, action: FirAnalytics.Actions.rewardsBtn, value: 1)
        let storyboard = UIStoryboard(name: "Leaderboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LeaderboardVC") as! LeaderBoardViewController
        vc.isFirstController = true
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func shopNowButtonTapped(_ sender: UIButton) {
//        self.pauseVideo()
         FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.homeFeed, category: FirAnalytics.Category.homeFeed, label: FirAnalytics.Label.homefeed_buyNow_tapped, action: FirAnalytics.Actions.buyNowBtn, value: 1)
        var itemsToBuy: [Cart?] = []
        let indexPath = collectionView.indexPathsForVisibleItems
        if indexPath.count > 0 {
            let value = postsListArray[indexPath[0].item]
            var cartProduct: Cart? = value.product
            cartProduct?.quantity = "1"
            cartProduct?.quantityCount = 1
            cartProduct?.product.sellerName = value.brand.display_name
            itemsToBuy.append(cartProduct)
            
            let dict: NSDictionary = ["array_ItemsToBuy": itemsToBuy, "classWhereProductIsAdded": String(describing: HomePostViewController.self)]
            var preferences = CheckoutProtocolModel(dictionary: dict)
            preferences.isClearCart = false
            if value.showSellerProfile {
                preferences.review_id = ""
            }else {
                preferences.review_id = value.id
            }
            self.moveToCheckoutScreen(checkoutPreferences: preferences)
        }
    }
    
    @IBAction func shopMoreButtonTapped(_ sender: UIButton) {
//        self.pauseVideo()
          FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.homeFeed, category: FirAnalytics.Category.homeFeed, label: FirAnalytics.Label.homefeed_shopmore_tapped, action: FirAnalytics.Actions.shopMoreBtn, value: 1)
        let storyboard = UIStoryboard(name: "ProjectStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShopMoreVC") as! ShopMoreVC
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count > 0 {
            let cell = collectionView.cellForItem(at: indexPathItem[0]) as? HomePostCollectionViewCell
            cell?.avPlayer.pause()
        }
    }
    
    @IBAction func cartButtonTapped(_ sender: UIButton) {
          FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.homeFeed, category: FirAnalytics.Category.homeFeed, label: FirAnalytics.Label.homefeed_cart_tapped, action: FirAnalytics.Actions.cartBtn, value: 1)
        self.pauseVideo()
        let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        self.navigationController?.pushViewController(vc, animated: false)
//        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func post_Review_Tapped(_ sender: UIButton) {
        if self.unreviewedOrdersCount > 0 {
            self.showOrdersToPostReview()
        } else {
            self.showPostReviewInfographic()
        }
    }
    
     func showOrdersToPostReview() {
        self.pauseVideo()
//        moveToUserMenu(visible : true)
        let storyboard = UIStoryboard(name: "Reviews", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostReviewVC") as! PostReviewVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showPostReviewInfographic() {
        self.pauseVideo()
//        moveToUserMenu(visible : true)
        let storyboard = UIStoryboard(name: "Reviews", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReviewInfographicVC") as! ReviewInfographicVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func productDetailButtonTapped(_ sender: UIButton)
    {
        FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.homeFeed, category: FirAnalytics.Category.homeFeed, label: FirAnalytics.Label.homefeed_productdetails_loaded, action: FirAnalytics.Actions.productDetailBtn, value: 1)
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count > 0 {
            getindex = indexPathItem[0].item
        }
        else
        {
            return
        }
        let tag = self.getindex
        let indexPath = IndexPath(row: tag, section: 0)
        
//        self.pauseVideo()
        let value = self.postsListArray[indexPath.row]
        
        if value.product.variant_id != "" {
            let storyboard = UIStoryboard(name: "ProjectStoryboard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            vc.product = value.product.product
            if value.showSellerProfile
            {
                vc.review_id = ""
            }
            else
            {
                vc.review_id = value.id
            }
            vc.isShowCartButtons = true
            vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func viewsButtonTapped(_ sender: UIButton) {
        self.pauseVideo()
        let storyboard = UIStoryboard(name: "Leaderboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LeaderboardVC") as! LeaderBoardViewController
        vc.isFirstController = false
        self.present(vc, animated: true, completion: nil)
    }
    @objc func likeTapped(sender: UIButton) {
         FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.homeFeed, category: FirAnalytics.Category.homeFeed, label: FirAnalytics.Label.homefeed_tap_like, action: FirAnalytics.Actions.likeFeedBtn, value: 1)
        self.likeTapped(isLikeButtonTap: true)
    }
    func likeTapped(isLikeButtonTap:Bool) {
        let indexPathItem = collectionView.indexPathsForVisibleItems
        
        if indexPathItem.count > 0 {
            getindex = indexPathItem[0].item
        }
        else
        {
            return
        }
        
        let tag = self.getindex
        let indexPath = IndexPath(row: tag, section: 0)
        
        if !isLikeButtonTap //from doubleTap
        {
            if self.postsListArray[indexPath.row].isLiked == true {
                return
            }
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? HomePostCollectionViewCell
        {
            //Disable LIKE/UNLIKE buttons
            cell.likeButton.isUserInteractionEnabled = false
            cell.likeTappedFullButton.isUserInteractionEnabled = false
        }
        
        let post = self.postsListArray[indexPath.row]
        var get_review_info = String()
        if self.postsListArray[indexPath.row].showSellerProfile == false {
            get_review_info = "1"
        } else {
            get_review_info = "0"
        }
        
        if self.postsListArray[indexPath.row].isLiked == false {
            let cell = collectionView.cellForItem(at: indexPath) as? HomePostCollectionViewCell
            if isLikeButtonTap == false{
                //Like animation
                cell?.like_icon_imageview.animationImages = like_image_array
                cell?.like_icon_imageview.animationDuration = 0.4
                cell?.like_icon_imageview.animationRepeatCount = 1
                cell?.like_icon_imageview.startAnimating()
            }
            self.likePostAPI(post_id:post.id, review_id: get_review_info)
        }else {
                self.unlikePostAPI(post_id:post.id, review_id: get_review_info)
        }
    }
    func likedPost(count : String,post_id:String) {
        if count == ""
        {
            return
        }
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count > 0 {
            getindex = indexPathItem[0].item
        }
        else
        {
            return
        }

        let tag = self.getindex
        let indexPath = IndexPath(row: tag, section: 0)
        
        let likedIndex = self.postsListArray.index(where: { $0.id == post_id })!
        self.postsListArray[likedIndex].isLiked = true
        self.postsListArray[likedIndex].likesCount = count

        if likedIndex == indexPath.row
        {
            if let cell = collectionView.cellForItem(at: indexPath) as? HomePostCollectionViewCell
            {
                cell.likeButton.setImage(UIImage(named: "Like_home"), for: .normal)
                cell.likesCountButton.setTitle(count.uppercased(), for: .normal)
                //ENABLE LIKE/UNLIKE buttons
                cell.likeButton.isUserInteractionEnabled = true
                cell.likeTappedFullButton.isUserInteractionEnabled = true
            }
        }
    }
    func unlikedPost(count : String,post_id:String) {
        if count == ""
        {
            return
        }
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count > 0 {
            getindex = indexPathItem[0].item
        }
        else
        {
            return
        }

        let tag = self.getindex
        let indexPath = IndexPath(row: tag, section: 0)
        
        let likedIndex = self.postsListArray.index(where: { $0.id == post_id })!
        self.postsListArray[likedIndex].isLiked = false
        self.postsListArray[likedIndex].likesCount = count

        if likedIndex == indexPath.row
        {
            if let cell = collectionView.cellForItem(at: indexPath) as? HomePostCollectionViewCell
            {
                cell.likeButton.setImage(UIImage(named: "Unlike_home"), for: .normal)
                cell.likesCountButton.setTitle(count.uppercased(), for: .normal)
                //ENABLE LIKE/UNLIKE buttons
                cell.likeButton.isUserInteractionEnabled = true
                cell.likeTappedFullButton.isUserInteractionEnabled = true
            }
        }
    }
    func viewedPost(count : String) {
        if count == ""
        {
            return
        }
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count > 0 {
            getindex = indexPathItem[0].item
        }
        else
        {
            return
        }
        let tag = self.getindex
        let indexPath = IndexPath(row: tag, section: 0)
        self.postsListArray[indexPath.item].isViewed = true
        self.postsListArray[indexPath.item].viewCount = count
        
//        if let cell = collectionView.cellForItem(at: indexPath) as? HomePostCollectionViewCell
//        {
//            cell.viewCountButton.setTitle(count.uppercased(), for: .normal)
//        }
    }
    
    func updateInventoryOfProduct(product:Product) {
        let filteredArray = postsListArray.filter({$0.product.product.variant_id == product.variant_id && $0.product.product.sku == product.sku})
        
        for i in 0..<filteredArray.count {
            print(i)
            let index = self.postsListArray.index(where: { $0.id == filteredArray[i].id })!
            var tempProduct = self.postsListArray[index].product.product
            tempProduct.qty = product.qty
            tempProduct.qtyCount = product.qtyCount
            tempProduct.status = product.status
            tempProduct.statusValue = product.statusValue
            tempProduct.status_description = product.status_description
            tempProduct.bought = product.bought
            tempProduct.price = product.price
            tempProduct.final_price = product.final_price
            self.postsListArray[index].product.product = tempProduct
        }
        
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count > 0 {
            getindex = indexPathItem[0].item
        }
        else
        {
            return
        }
        let tag = self.getindex
        let indexPath = IndexPath(row: tag, section: 0)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? HomePostCollectionViewCell
        {
            let value = self.postsListArray[indexPath.row]
            if value.product.product.variant_id == product.variant_id
            {
                let priceString =  value.product.product.currency + value.product.product.final_price.uppercased()
                var actualPriceString = value.product.product.price.uppercased()
                
                var combinedString  = ""
                if actualPriceString == ""
                {
                    combinedString = priceString
                }
                else{
                    actualPriceString = value.product.product.currency + actualPriceString
                    combinedString = actualPriceString + " " +  priceString
                }
                
                let attributeString =  NSMutableAttributedString(string: combinedString)
                let regularFont = UIFont(name: Constants.SEMI_BOLD_FONT, size: 21)!
                
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                             value: NSUnderlineStyle.single.rawValue,
                                             range: NSMakeRange(0, actualPriceString.count))
                
                attributeString.addAttribute(NSAttributedString.Key.font,
                                             value: regularFont,
                                             range: NSMakeRange(0, actualPriceString.count))
                
                attributeString.addAttribute(NSAttributedString.Key.foregroundColor,
                                             value:  _ColorLiteralType(red: 0.04746739566, green: 0.5619356036, blue: 0.9403368831, alpha: 1),
                                             range: NSMakeRange(0, actualPriceString.count))
                
                cell.productPriceLbl.attributedText = attributeString
                
                
                if value.product.product.status_description != ""
                {
                    cell.productDetailButton.isUserInteractionEnabled = true
                    
                    if value.product.product.statusValue == .active
                    {
                        cell.buyNowButton.setImage(UIImage(named: "out_of_stock_icon_white"), for: .normal)
                    }
                    else
                    {
                        cell.buyNowButton.setImage(UIImage(named: "not-available"), for: .normal)
                    }
                    
                    if value.product.product.statusValue == .deleted
                    {
                        cell.productDetailButton.isUserInteractionEnabled = false
                    }
                    
                    cell.buyNowButton.isUserInteractionEnabled = false
                }
                else
                {
                    cell.productDetailButton.isUserInteractionEnabled = true
                    cell.buyNowButton.isUserInteractionEnabled = true
                    if value.isShoppable
                    {
                        cell.buyNowButton.setImage(UIImage(named: "buy_now_bg"), for: .normal)
                    }
                    else
                    {
                        cell.buyNowButton.setImage(UIImage(named: "book_now_btn"), for: .normal)
                    }
                }
            }
            
        }
    }
    func handleUserMenuItems(details: NSDictionary) {
        self.notificationCount = 0
        if !(details["total_notifications_count"] is NSNull) {
            if  let value = details["total_notifications_count"] as? Int {
                self.notificationCount = value
            }else {
                self.notificationCount = Int(details["total_notifications_count"] as! String == "" ? "0" : details["total_notifications_count"] as! String)!
            }
        }
        self.unreviewedOrdersCount = 0
        if !(details["total_unreviewd_orders"] is NSNull) {
            if  let value = details["total_unreviewd_orders"] as? Int {
                self.unreviewedOrdersCount = value
            }else {
                self.unreviewedOrdersCount = Int(details["total_unreviewd_orders"] as! String == "" ? "0" : details["total_unreviewd_orders"] as! String)!
            }
        }
        self.calculateLoggedInUserCashback(amount: details["total_cashout_balance"] as Any)
        lbl_MenuCashout.text = "\(formatPriceToTwoDecimalPlace(amount: self.cashoutBalance))\nBALANCE"
        self.userMenuTableView.reloadData()
    }
    func calculateLoggedInUserCashback(amount: Any) {
        self.cashoutBalance = self.cashoutBalance != 0 ? self.cashoutBalance : 0
        if !(amount is NSNull) {
            if  let value = amount as? Int {
                self.cashoutBalance = Float(CGFloat(value))
            }else if  let value = amount as? Float {
                self.cashoutBalance = value
            }else if  let value = amount as? NSNumber {
                self.cashoutBalance = value.floatValue
            }else {
                let balance = amount as! String == "" ? "0" : amount as! String
                if let value = NumberFormatter().number(from: balance) {
                    self.cashoutBalance = Float(truncating: value)
                }
            }
        }
    }
    @IBAction func userProfileButtonTapped(_ sender: UIButton) {
        self.pauseVideo()
        moveToUserMenu(visible : false)
        self.callFetchUserMenuDetails()
    }
    func moveToUserMenu(visible : Bool) {
        userMenuInnerViewTrailingConstraint.constant =  self.view.frame.size.width - userMenuInnerViewWidthConstraint.constant

        if visible {
            userMenuLeadingconstraint.constant =  -self.view.frame.size.width
            //this constant is NEGATIVE because we are moving it 150 points OUTWARD and that means -150
            userMenuTrailingConstraint.constant = -self.view.frame.size.width
            self.playVideo(tapToPlay: false)
        } else {
            //if the hamburger menu IS visible, then move the ubeView back to its original position
            userMenuLeadingconstraint.constant = 0
            userMenuTrailingConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            //print("The animation is complete!")
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
    }
    @IBAction func brandProfileButtonTapped(_ sender: UIButton) {
        moveToSellerProfile()
    }

    @IBAction func backButton(_ sender: UIButton) {
        moveToUserMenu(visible: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonClicked(_ sender: UIButton) {
        AlertController.SHOW_ALERT_CONTROLLER_DOUBLE_BUTTON(alertTitle: "", message: "Are you sure you want to sign out?", btnTitle1: "Cancel", btnTitle2: "OK", viewController: self) { (response) in
            if response.caseInsensitiveCompare("Button2") == .orderedSame {
                self.callLogoutUserFromApp()
            }
        }
    }
    @IBAction func menuCashoutTapped(_ sender: UIButton) {
//        if self.cashoutBalance <= 0 {
//            return
//        }
//        moveToUserMenu(visible : true)
        self.pauseVideo()
        let storyboard = UIStoryboard(name: "Reviews", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "CashoutVC") as! CashoutVC
        vcObj.cashoutBalance = self.cashoutBalance
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    func moveToSellerProfile()
    {
        self.pauseVideo()
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count > 0 {
            getindex = indexPathItem[0].item
        }
        else
        {
            return
        }
        let tag = self.getindex
        let indexPath = IndexPath(row: tag, section: 0)
        
        //print(indexPath.item)
        self.pauseVideo()
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        let post = self.postsListArray[indexPath.row]
        let storyboard = UIStoryboard(name: "SellerProfile", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "BrandProfileVC") as! BrandProfileVC
        vcObj.brand = post.brand
        self.navigationController?.pushViewController(vcObj, animated: false)
    }
    func moveToMessages()
    {
//        moveToUserMenu(visible : true)
        self.pauseVideo()
        let storyboard = UIStoryboard(name: "ProjectStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        self.present(vc, animated: true, completion: nil)
    }
    func moveToNotification()
    {
//        moveToUserMenu(visible : true)
        self.pauseVideo()
        let storyboard = UIStoryboard(name: "Notifications", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        self.navigationController?.show(vc, sender: self)
        //        self.present(vc, animated: true, completion: nil)
    }
    func moveToOrders()
    {
//        moveToUserMenu(visible : true)
        self.pauseVideo()
        let storyboard = UIStoryboard(name: "Order", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OrderVC") as! OrderVC
        self.navigationController?.show(vc, sender: self)
//        self.present(vc, animated: true, completion: nil)
    }    
    func moveToReferalTracker() {
         let storyboard = UIStoryboard(name: "Leaderboard", bundle: nil)
         let vc = storyboard.instantiateViewController(withIdentifier: "ReferralTrackerViewController") as! ReferralTrackerViewController
        self.navigationController?.show(vc, sender: self)
    }
    func navigateToPaymentAndShipping() {
        //moveToUserMenu(visible : true)
        self.pauseVideo()
        let storyboard = UIStoryboard(name: "PaymentShippingManagement", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "PaymentShippingManagementVC") as! PaymentShippingManagementVC
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    func navigateToSettingsScreen() {
        //moveToUserMenu(visible : true)
        self.pauseVideo()
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    @IBAction func moveToShareEarn(_ sender: UIButton) {
//        moveToUserMenu(visible : true)
         FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.homeFeed, category: FirAnalytics.Category.homeFeed, label: FirAnalytics.Label.homefeed_shareEarn_tapped, action: FirAnalytics.Actions.shareEarnBtn, value: 1)
        self.pauseVideo()
        let storyboard = UIStoryboard(name: "Leaderboard", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "ShareEarnVC") as! ShareEarnVC
        self.present(vcObj, animated: true, completion: nil)
    }
    @IBAction func moveToConusmerProfile(_ sender: UIButton) {
        self.pauseVideo()
//        let btn = UIButton()
//        self.backButton(btn)
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        let storyboard = UIStoryboard(name: "ConsumerProfile", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "ConsumerProfileVC") as! ConsumerProfileVC
        vcObj.get_Follow_info = false
        if get_consumer_id == "" {
            vcObj.get_user_Follow_id = ""
        } else {
            vcObj.get_user_Follow_id = get_consumer_id
        }
        self.navigationController?.pushViewController(vcObj, animated: false)
    }
}

//MARK:- CollectionView Delegate and DataSource
extension HomePostViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    //MARK:-
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //print("after end",indexPath.item)
        (cell as? HomePostCollectionViewCell)?.avPlayer.pause()
        (cell as? HomePostCollectionViewCell)?.avPlayerLayer.removeFromSuperlayer()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == postsListArray.count - 1 {
            // need to change
            if self.store.total_feeds > self.postsListArray.count
            {
                self.loadMoreTapped()
            }
        }
        
        if let cell =  (cell as? HomePostCollectionViewCell)
        {
            let value = self.postsListArray[indexPath.row]
            if value.videoURL != ""
            {
                let videoURL = URL(string: value.videoURL)!
                cell.avPlayer = AVPlayer(url: videoURL)
                cell.avPlayer.actionAtItemEnd = .none
                cell.avPlayerLayer = AVPlayerLayer(player: cell.avPlayer)
                cell.avPlayerLayer.frame = cell.bounds
                cell.cellView.layer.insertSublayer(cell.avPlayerLayer, at: 0)
               
                
                if  CGFloat(value.resolutionHeight ) ==  CGFloat(value.resolutionWidth ) {
                    cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                }
               else if CGFloat(value.resolutionHeight ) > self.view.bounds.height-200 {
                    if CGFloat(value.resolutionWidth ) > CGFloat(value.resolutionHeight ) {
                        cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                    }else {
                        cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    }
                }else {
                    cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                }
                
                // When you need to update the UI, switch back out to the main thread
                DispatchQueue.main.async {
                    // Main thread
                    // Do your UI updates here
                    
                    let item = AVPlayerItem(url: videoURL)
                    cell.avPlayer.replaceCurrentItem(with: item)
                    cell.cellView.isHidden = false
                    
                    cell.avPlayer.play()
                    
                    self.preriodicTimeObsever(cell : cell)
                    NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: cell.avPlayer.currentItem)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        //print("before end",indexPath.row)
//        if selectedCell != nil
//        {
//            selectedCell?.avPlayer.pause()
//            selectedCell?.avPlayerLayer.removeFromSuperlayer()
//        }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePostCollectionViewCell", for: indexPath) as? HomePostCollectionViewCell
        {
            cell.layoutIfNeeded()
            let value = self.postsListArray[indexPath.row]
            let imageName = value.imageURL
            print("Index path called")
            cell.shareImageButton.tag = indexPath.row
            cell.shareTextButton.tag = indexPath.row
            cell.favoriteButton.tag = indexPath.row
            cell.buyNowButton.tag = indexPath.row
            cell.likeButton.tag = indexPath.row
            cell.likesCountButton.tag = indexPath.row
            cell.likeTappedFullButton.tag = indexPath.row
//            self.infoTopView.alpha = 0
//            cell.itemInfoTopView.alpha = 0
            cell.itemInfoBottomView.alpha = 0
            cell.shadowImageView.alpha = 0
            self.infoTopView.alpha = 1
            cell.itemInfoTopView.alpha = 1
            
            cell.view_RewardBadge.isHidden = true

            let countValue = Login.loadCustomerInfoFromKeychain()?.total_cart_items ?? 0
            cell.cartCountLabel.text = "\(countValue)"
            if countValue > 0
            {
                cell.view_CartItemCount.isHidden = false
            }
            else
            {
                cell.view_CartItemCount.isHidden = true
            }
            let when = DispatchTime.now() + 2.0
            DispatchQueue.main.asyncAfter(deadline: when){
                UIView.animate(withDuration: 0.5, animations: {
//                    self.infoTopView.alpha = 1
//                    cell.itemInfoTopView.alpha = 1
                    cell.itemInfoBottomView.alpha = 1
                    cell.shadowImageView.alpha = 1
                }, completion: {
                    finished in
                })
            }
            
            //PRODUCT CONTENT SETUP
            var get_Bought_Count = String()
            get_Bought_Count = (value.product.product.bought)
            if get_Bought_Count == "0"{
                cell.productBoughtLbl.text = ""
            } else {
                cell.productBoughtLbl.text = get_Bought_Count.uppercased() + " BOUGHT"
            }
            
            cell.productImage.image = UIImage(named: Constants.PRODUCT_DUMMY_IMAGE)
            let productImageUrl = value.product.product.productImage
            if productImageUrl != "" {
                let url = URL(string: productImageUrl)
                cell.productImage.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            let priceString =  value.product.product.currency + value.product.product.final_price.uppercased()
            var actualPriceString = value.product.product.price.uppercased()
            
            var combinedString  = ""
            if actualPriceString == ""
            {
                combinedString = priceString
            }
            else{
                actualPriceString = value.product.product.currency + actualPriceString
                combinedString = actualPriceString + " " +  priceString
            }
            
            let attributeString =  NSMutableAttributedString(string: combinedString)
            let regularFont = UIFont(name: Constants.SEMI_BOLD_FONT, size: 21)!
            
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                         value: NSUnderlineStyle.single.rawValue,
                                         range: NSMakeRange(0, actualPriceString.count))
            
            attributeString.addAttribute(NSAttributedString.Key.font,
                                         value: regularFont,
                                         range: NSMakeRange(0, actualPriceString.count))
            
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor,
                                         value: #colorLiteral(red: 0.04746739566, green: 0.5619356036, blue: 0.9403368831, alpha: 1),
                                         range: NSMakeRange(0, actualPriceString.count))
            
            cell.productPriceLbl.attributedText = attributeString
            
            if value.showSellerProfile
            {
                cell.viewsBackView.isHidden = true
                cell.img_brand.isHidden = false
            }
            else
            {
                cell.viewsBackView.isHidden = false
                cell.img_brand.isHidden = true
            }
            
            if value.product.product.status_description != ""
            {
                 cell.productDetailButton.isUserInteractionEnabled = true
                
                if value.product.product.statusValue == .active
                {
                    cell.buyNowButton.setImage(UIImage(named: "out_of_stock_icon_white"), for: .normal)
                }
                else
                {
                    cell.buyNowButton.setImage(UIImage(named: "not-available"), for: .normal)
                }

                if value.product.product.statusValue == .deleted
                {
                    cell.productDetailButton.isUserInteractionEnabled = false
                }

                cell.buyNowButton.isUserInteractionEnabled = false
            }
            else
            {
                cell.productDetailButton.isUserInteractionEnabled = true
                cell.buyNowButton.isUserInteractionEnabled = true
                if value.isShoppable
                {
                    cell.buyNowButton.setImage(UIImage(named: "buy_now_bg"), for: .normal)
                }
                else
                {
                    cell.buyNowButton.setImage(UIImage(named: "book_now_btn"), for: .normal)
                }
            }
            
            let priceTotalCashback = Float(value.totalCashback)
            cell.likesCountButton.setTitle(value.likesCount.uppercased(), for: .normal)
            cell.viewCountButton.setTitle(formatPriceToTwoDecimalPlace(amount: priceTotalCashback ??  0), for: .normal)
            
            
            let brandImageUrl = value.brand.brandImage
            if brandImageUrl != "" {
                let url = URL(string: brandImageUrl)
                cell.img_brand.kf.setImage(with: url, for: .normal)
            }
            else
            {
                cell.img_brand.setImage(UIImage(named: "brand-dummy-image"), for: .normal)
            }
            
            
            if value.isLiked {
                cell.likeButton.setImage(UIImage(named: "Like_home"), for: .normal)
            }
            else
            {
                cell.likeButton.setImage(UIImage(named: "Unlike_home"), for: .normal)
            }
            
            
            cell.likeButton.isUserInteractionEnabled = true
            cell.likeTappedFullButton.isUserInteractionEnabled = true
            cell.likeButton.addTarget(self, action: #selector(self.likeTapped(sender:)), for: .touchUpInside)
            cell.likeTappedFullButton.addTarget(self, action: #selector(self.likeTapped(sender:)), for: .touchUpInside)
            
            //User Cashout balance
            cell.lbl_UserCashoutBalance.text = formatPriceToTwoDecimalPlace(amount: self.cashoutBalance)
            
            //POST CONTENT SETUP MEDIA
            
            cell.itemImageView.isHidden = false
            cell.cellView.isHidden = true
            cell.play_icon_imageview.isHidden = true
            cell.itemImageView.image = nil
            

            //SHOW THUMBNAIL
            if imageName != ""
            {
                let url = URL(string: imageName)
                cell.itemImageView.kf.setImage(with: url)
            }
            cell.itemImageView.clipsToBounds = true
            
            if CGFloat(value.resolutionHeight ) == CGFloat(value.resolutionWidth ){
                   cell.itemImageView.contentMode = .scaleAspectFit
            }
            
            else if CGFloat(value.resolutionHeight ) > self.view.bounds.height-200 {
                if CGFloat(value.resolutionWidth ) > CGFloat(value.resolutionHeight ) {
                    cell.itemImageView.contentMode = .scaleAspectFit
                }else {
                    cell.itemImageView.contentMode = .scaleAspectFill
                }
            }else {
                cell.itemImageView.contentMode = .scaleAspectFit
            }
//            if value.videoURL != ""
//            {
//                let videoURL = URL(string: value.videoURL)!
//                cell.avPlayer = AVPlayer(url: videoURL)
//                cell.avPlayer.actionAtItemEnd = .none
//                cell.avPlayerLayer = AVPlayerLayer(player: cell.avPlayer)
//                cell.avPlayerLayer.frame = cell.bounds
//
//                if CGFloat(value.resolutionHeight ) > self.view.bounds.height-200 {
//                    if CGFloat(value.resolutionWidth ) > CGFloat(value.resolutionHeight ) {
//                        cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
//                        cell.itemImageView.contentMode = .scaleAspectFit
//                    }else {
//                        cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//                        cell.itemImageView.contentMode = .scaleAspectFill
//                    }
//                }else {
//                    cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
//                    cell.itemImageView.contentMode = .scaleAspectFit
//                }
//
//                DispatchQueue.global(qos: .background).async {
//                    // Background thread
//                    // Do your AVPlayer work here
//                    let asset = AVAsset.init(url: videoURL)
//                        asset.loadValuesAsynchronously(forKeys: ["duration", "playable"]) {
//                            // When you need to update the UI, switch back out to the main thread
//                            DispatchQueue.main.async {
//                                // Main thread
//                                // Do your UI updates here
//
//                                let item = AVPlayerItem.init(asset: asset)
//                                cell.avPlayer.replaceCurrentItem(with: item)
//                                cell.avPlayer.play()
//                                cell.cellView.layer.insertSublayer(cell.avPlayerLayer, at: 0)
//                                cell.cellView.isHidden = false
//
////                                if let resolution = self.resolutionForLocalVideo(url: videoURL)
////                                {
////                                    if CGFloat(resolution.height ) > self.view.bounds.height-200 {
////                                        if CGFloat(resolution.width ) > CGFloat(resolution.height ) {
////                                            cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
////                                            cell.itemImageView.contentMode = .scaleAspectFit
////                                        }else {
////                                            cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
////                                            cell.itemImageView.contentMode = .scaleAspectFill
////                                        }
////                                    }else {
////                                        cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
////                                        cell.itemImageView.contentMode = .scaleAspectFit
////                                    }
////                                }
//
//                                self.preriodicTimeObsever(cell : cell)
//                                NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: cell.avPlayer.currentItem)
//                            }
//                        }
////                    }
//                }
//            }
            
            self.selectedCell = cell
            self.getindex = indexPath.row
            
            cell.tapDetectionView.isUserInteractionEnabled = true
            // Single Tap
            let singleTap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap))
            singleTap.numberOfTapsRequired = 1
            singleTap.cancelsTouchesInView = false
            cell.tapDetectionView.addGestureRecognizer(singleTap)
            
            // Double Tap
            let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap))
            doubleTap.numberOfTapsRequired = 2
            doubleTap.cancelsTouchesInView = false
            cell.tapDetectionView.addGestureRecognizer(doubleTap)
            
            singleTap.require(toFail: doubleTap)
            singleTap.delaysTouchesBegan = true
            doubleTap.delaysTouchesBegan = true
            return cell
        }
        return HomePostCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    func preriodicTimeObsever(cell : HomePostCollectionViewCell){
        if cell.observer != nil {
            //removing time obse
            cell.observer = nil
            //            observer = nil
        }
        
        let intervel : CMTime = CMTimeMake(value: 1, timescale: 1)
        cell.observer = cell.avPlayer.addPeriodicTimeObserver(forInterval: intervel, queue: DispatchQueue.main) { [weak self] time in
            guard let strongSelf = self else {return}
            //            let sliderValue : Float64 = CMTimeGetSeconds(time)
            
            let indexPath = strongSelf.collectionView.indexPathsForVisibleItems
            if indexPath.count > 0 {
                strongSelf.getindex = indexPath[0].item
            }
            if strongSelf.postsListArray.count == 0
            {
                return
            }
            let post_id = strongSelf.postsListArray[strongSelf.getindex].id
            let isViewed = strongSelf.postsListArray[strongSelf.getindex].isViewed
            
            var get_review_info = String()
            if strongSelf.postsListArray[strongSelf.getindex].showSellerProfile == false {
                get_review_info = "1"
            } else {
                get_review_info = "0"
            }
            
            let currentTime = CMTimeGetSeconds(cell.avPlayer.currentTime())
            let secs = Int(currentTime)
            if secs == 3 && !isViewed
            {
                self?.increaseViewCount(post_id: post_id,review_id: get_review_info)
            }
            //print("secondes:",secs)
            
            //this is the slider value update if you are using UISlider.
            let playbackLikelyToKeepUp = cell.avPlayer.currentItem?.isPlaybackLikelyToKeepUp
            if playbackLikelyToKeepUp == false{
//                strongSelf.showIndicator()
                //Here start the activity indicator inorder to show buffering
            }else{
//                strongSelf.hideIndicator()
                //stop the activity indicator
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Scroll END ...........")
    FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.homeFeed, category: FirAnalytics.Category.homeFeed, label: FirAnalytics.Label.homefeed_feed_swiped, action: FirAnalytics.Actions.swipeLeftRight, value: 1)
      
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count > 0 {
            getindex = indexPathItem[0].item
            let cell = collectionView.cellForItem(at: indexPathItem[0]) as? HomePostCollectionViewCell
            cell?.avPlayer.play()
        }
        else
        {
            return
        }
        let tag = self.getindex
        let indexPath = IndexPath(row: tag, section: 0)
        
        let post = self.postsListArray[indexPath.row]
        self.fetchInventoryDetail(value: post.product.product.variant_id)
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count > 0 {
            let cell = collectionView.cellForItem(at: indexPathItem[0]) as? HomePostCollectionViewCell
            cell?.avPlayer.pause()
        }
        let offset = scrollView.contentOffset
        let inset = scrollView.contentInset
        let y: CGFloat = offset.x - inset.left
        let reload_distance: CGFloat = -75
        if y < reload_distance{
            scrollView.bounces = false
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                self.refreshHomePostsList()
            }, completion: { (Bool) -> Void in
                scrollView.bounces = true
            })
        }
    }
}
extension HomePostViewController: AKPickerViewDataSource, AKPickerViewDelegate {
    
    // MARK: - AKPickerViewDataSource
    
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return self.all_categories_list.count
    }
    
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.homeFeed, category: FirAnalytics.Category.homeFeed, label: FirAnalytics.Label.homefeed_category_loaded, action: FirAnalytics.Actions.topCategoryChange, value: 1)
       // self.likeTapped(isLikeButtonTap: true)
        return self.all_categories_list[item].displayName.uppercased()
    }
    
//    func pickerView(_ pickerView: AKPickerView, imageForItem item: Int) -> UIImage {
//        return UIImage(named: self.all_categories_list[item])!
//    }
    
    // MARK: - AKPickerViewDelegate
    
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        //print("selected Category is : \(self.picker_titles[item])")
        self.pickerView.highlightedFont = UIFont(name: Constants.SEMI_BOLD_FONT, size: 18)!
        self.pickerView.font = UIFont(name: Constants.MEDIUM_FONT, size: 13)!
        self.pickerView.textColor = .lightText
        self.pickerView.highlightedTextColor = .white
        self.pickerView.pickerViewStyle = .wheel
        self.pickerView.maskDisabled = false
        self.pickerView.reloadData()
        self.tabSelected = self.all_categories_list[item].category_code
        self.pauseVideo()
        self.page = 0
        self.fetchHomePostsList()
        
    }
}

extension HomePostViewController {
    func logout() {
        //Logout from Facebook
        let loginManager = LoginManager()
        loginManager.logOut()

        _ = KeychainWrapper.standard.removeAllKeys()
        //resetDefaults()
        
        let checkout = CheckoutServices.sharedInstance
        checkout.removeUserStoredDataFromCheckout()
        
        let appDelegateTemp = UIApplication.shared.delegate as? AppDelegate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC

        let nav1 = UINavigationController(rootViewController: vc)
        appDelegateTemp?.window?.rootViewController = nav1
        self.dismiss(animated: true, completion: nil)
    }
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}

extension HomePostViewController : UITableViewDataSource ,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UserMenuTableViewCell
        let itemName = self.namesList[indexPath.row].uppercased()
        let itemImage = self.imagesList[indexPath.row]
        cell.setValueForCell(name : itemName ,itemImage:itemImage)
        if indexPath.row == 0 {
            if notificationCount <= 0 {
                cell.constraint_NotificationLblWidth.constant = 0
                cell.constraint_NotificationCountLlblTrailing.constant = 0
                cell.lbl_NotificationCount.isHidden = true
            }else {
                let notifications = "\(self.notificationCount)"
                let width: CGFloat = notifications.TextWidth(withConstrainedHeight: 20, font: UIFont(name: Constants.MEDIUM_FONT, size: 11)!)
                cell.lbl_NotificationCount.text = notifications
                cell.constraint_NotificationLblWidth.constant = width+10
                cell.constraint_NotificationCountLlblTrailing.constant = 11
                cell.lbl_NotificationCount.isHidden = false
                cell.lbl_NotificationCount.layer.cornerRadius = 8.0
                cell.lbl_NotificationCount.clipsToBounds = true
            }
        }else {
            cell.constraint_NotificationLblWidth.constant = 0
            cell.constraint_NotificationCountLlblTrailing.constant = 0
            cell.lbl_NotificationCount.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.moveToNotification()
        } else if indexPath.row == 1 {
            self.moveToOrders()
        } else if indexPath.row == 2{
            //Referral tracker
            self.moveToReferalTracker()
        }else if indexPath.row == 3 {
            //Payments & Shipping
            self.navigateToPaymentAndShipping()
        }else if indexPath.row == 4 {
            //Settings
            self.navigateToSettingsScreen()
        }
        else if indexPath.row == 7 {
            self.moveToMessages()
        }
        else if indexPath.row == 8 {
            //Logout
            let btn = UIButton()
            self.logoutButtonClicked(btn)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49.6
    }
    
    func loadMoreTapped()
    {
        self.fetchHomePostsList()
    }
}

// MARK: API CALLS
extension HomePostViewController {
    @objc func fetchHomePostsList() {
        self.noDataView.isHidden = true
        let value = tabSelected
        var rpp = Constants.RPP_HOME_DEFAULT
        if !all_categories_setup
        {
            rpp = 0
        }
        store.fetchListing(showLoader: true,value:value, page: page,rpp : rpp, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
          
            if self.page == 0
            {
                self.postsListArray.removeAll()
            }
            if let _ = success as? [String: Any] {
                //print(success)
                //print("success")
                for post in self.store.homePostModelArrays {
                    self.postsListArray.append(post)
                }
                //self.postsListArray = self.store.homePostModelArrays
                self.userHomePostData = self.store.userHomePost
                
                if !self.all_categories_setup
                {
                    self.all_categories_list.removeAll()
                    self.all_categories_list = self.store.all_categories_list
                    self.setupTopCategoryPickerView()
                }
                
                let count = self.userHomePostData?.cart_items_count ?? 0
                _ = Network.currentAccount?.updateTotalItemCount(count : count)

                self.userImageButton.setImage(UIImage(named:  Constants.USER_DUMMY_IMAGE), for: .normal)
                self.userProfileMenuImageView.image = UIImage(named:  Constants.USER_DUMMY_IMAGE)

                
                let userImageUrl = self.userHomePostData?.userImage ?? ""
                if userImageUrl != "" {
                    KeychainWrapper.standard.set(userImageUrl as String , forKey: "profile_image")
                    let url = URL(string: userImageUrl)
                    self.userImageButton.kf.setImage(with: url, for: .normal, placeholder: UIImage(named:Constants.USER_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
                    self.userProfileMenuImageView.kf.setImage(with: url, placeholder: UIImage(named:Constants.USER_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
                }

                if self.postsListArray.count > 0
                {
                    self.noDataView.isHidden = true
                    self.collectionView.reloadData()
                    if self.page == 0
                    {
                        let indexPath = IndexPath(row: 0, section: 0)
                        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                    }
                    self.page = self.page + 1
                }
                else
                {
                    if rpp == 0
                    {
                        self.noDataView.isHidden = true
                    }
                    else
                    {
                        self.noDataView.isHidden = false
                    }
//                    if self.all_categories_setup {
//                        self.noDataView.isHidden = false
//                    } else {
//                        self.noDataView.isHidden = true
//                    }
                    self.collectionView.reloadData()
                }
                
            }
            //User rewards:
            if let response = success as? [String: Any] {
                if let response = response["response"] as? NSDictionary {
                    if let user = response["user"] as? NSDictionary {
                        self.calculateLoggedInUserCashback(amount: user["rewards"] as Any)
                    }
                }
            }
        }) { (failure) -> Void in
            
            self.postsListArray.removeAll()
            self.collectionView.reloadData()
            if self.postsListArray.count > 0
            {
                self.noDataView.isHidden = true
            }
            else
            {
                self.noDataView.isHidden = false
            }
            // your failure handle
            if let value = failure as? [String:Any] {
                AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: value["message"] as? String ?? "failure", btnTitle: "OK", viewController: self, completionHandler: { (success) in
                })
                return
            } else {
                AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: AlertController.AlertTitle.apiFailure.rawValue, btnTitle: "OK", viewController: self, completionHandler: { (success) in
                })
                return
            }
        }
    }
    
    @objc func increaseViewCount(post_id:String, review_id:String)
    {
        let parameters : [String:Any] = [
            "post_id": post_id,
            "is_review":review_id,
            ]
        store.viewCountService(parameters : parameters , showLoader: false, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any] {
                //print(success)
                //print("success")
                var count = ""
                if let result = success as? [String: Any] {
                    if let response = result["response"] as? NSDictionary {
                        if let countValue  = response["viewcount"]
                        {
                            count = "\(String(describing: countValue))"
                            self.viewedPost(count: count)
                        }
                    }
                }
            }
        }) { (failure) -> Void in
        }
    }
    
    @objc func likePostAPI(post_id:String,review_id:String) {
        let parameters : [String:Any] = [
            "post_id": post_id,
            "is_review":review_id,
            ]
        
        store.callLikeUnLikePostAPI(parameters: parameters, showLoader: false, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any] {
                //print(success)
                //print("success")
                var count = ""
                if let result = success as? [String: Any] {
                    if let response = result["response"] as? NSDictionary {
                        if let countValue  = response["count"]
                        {
                            count = "\(String(describing: countValue))"
                            self.likedPost(count : count, post_id: post_id)
                        }
                    }
                }
            }
        }) { (failure) -> Void in
        }
    }
    @objc func unlikePostAPI(post_id:String, review_id:String) {
        let parameters : [String:Any] = [
            "post_id": post_id,
            "is_review":review_id,
            ]
        
        store.callLikeUnLikePostAPI(parameters: parameters, showLoader: false, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any] {
                //print(success)
                //print("success")
                var count = ""
                if let result = success as? [String: Any] {
                    if let response = result["response"] as? NSDictionary {
                        if let countValue  = response["count"]
                        {
                            count = "\(String(describing: countValue))"
                            self.unlikedPost(count : count, post_id: post_id)
                        }
                    }
                }
            }
        }) { (failure) -> Void in
        }
    }
    
    @objc func fetchInventoryDetail(value:String) {
        store.fetchProductInventoryDetailAPI(showLoader: false,value:value, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any] {
                if let result = success as? [String: Any] {
                    if let response = result["response"] as? NSDictionary {
                        self.calculateLoggedInUserCashback(amount: response["cashback"] as Any)
                        let product = Product(dictionary: response)
                        self.updateInventoryOfProduct(product : product)
                    }
                }
            }
        }) { (failure) -> Void in
            // your failure handle
//            self.handleAPIError(failure: failure)
        }
    }
    @objc func callFetchUserMenuDetails() {
        store.fetchMenuItemsDetailsAPI(showLoader: false, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let result = success as? [String: Any] {
                print(success)
                if let response = result["response"] as? NSDictionary {
                   self.handleUserMenuItems(details: response)
                }
            }
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    
    @objc func callLogoutUserFromApp() {
        let parameters : [String:Any] = [
            "device_token": UserdefaultStore.USERDEFAULTS_GET_STRING_KEY(key: "DeviceToken")
            ]
        let service = LogoutServices()
        service.callLogoutUser(parameters: parameters, showLoader: true, completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any] {
                //print(success)
                self.logout()
            }
        }) { (failure) -> Void in
            self.logout()
        }
    }
}

