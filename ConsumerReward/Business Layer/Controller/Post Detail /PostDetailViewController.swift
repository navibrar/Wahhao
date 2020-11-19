//  Created by apple on 11/24/18.
//  Copyright © 2018 wahhao. All rights reserved.

import Foundation
import UIKit
import MediaPlayer
import AVKit
import QuartzCore
import CoreMedia
import Kingfisher
import FacebookLogin

class PostDetailViewController: UIViewController {
    //MARK:- Variable Declaration
    fileprivate var interactionController: UIPercentDrivenInteractiveTransition?
    var selectedCell : HomePostCollectionViewCell? = nil
    var selectedIndex = Int()
    var getindex = Int()
    var fromSeller = false
    let store = HomePostServices.sharedInstance
    var callback : (([HomePost]) -> Void)?
    var like_image_array = [UIImage]()
    var passedListArray = [HomePost]()
    var postsListArray = [HomePost]()
    var get_consumer_id = String()
    //Handle Notification Click
    var postId: String = ""
    var isReviewPost: Bool = false
    var isFromNotification: Bool = false
    
    //MARK:- Outlet Delaration
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var infoTopView: UIView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var userImageButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        like_image_array.append(UIImage(named: "1")!)
        like_image_array.append(UIImage(named: "2")!)
        like_image_array.append(UIImage(named: "3")!)
        like_image_array.append(UIImage(named: "4")!)
        like_image_array.append(UIImage(named: "5")!)
        like_image_array.append(UIImage(named: "6")!)
        like_image_array.append(UIImage(named: "6")!)
        self.userImageButton.setImage(UIImage(named: Constants.USER_DUMMY_IMAGE), for: .normal)
        let userImageUrl = Login.loadCustomerInfoFromKeychain()?.profile_image
        if userImageUrl != "" {
            let url = URL(string: userImageUrl!)
            self.userImageButton.kf.setImage(with: url, for: .normal, placeholder: UIImage(named:Constants.USER_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
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

        
        //SWIPE GESTURES
        let swipeup = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeup.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(swipeup)
        
        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipedown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipedown)
        
        NOTIFICATIONCENTER.addObserver(self, selector: #selector(self.pauseVideo(note:)), name: Notification.Name(rawValue: "pauseVideo"), object: nil)
        
        if isFromNotification == true {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.callGetPostDetail(postId: self.postId, isReviewPost: self.isReviewPost)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerinforground(note:)),name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.pauseVideo(note:)),name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.pauseVideo(note:)),name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerinforground(note:)),name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        self.navigationController?.isNavigationBarHidden = false
        self.pauseVideo()
        if selectedCell != nil{
            selectedCell?.avPlayer.pause()
            selectedCell?.avPlayerLayer.removeFromSuperlayer()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFromNotification == false {
            if self.postsListArray.count == 0 {
                self.postsListArray = self.passedListArray
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at:IndexPath(item: selectedIndex, section: 0), at: .right, animated: false)
            }
        }
    }

    @objc func playerinforground(note: NSNotification) {
        //print("Video Finished")
        self.playVideo()
    }
    @objc func pauseVideo(note: NSNotification)
    {
        self.pauseVideo()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        let indexPath = collectionView.indexPathsForVisibleItems
        if indexPath.count > 0 {
            getindex = indexPath[0].item
        }
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                self.goBack()
            case UISwipeGestureRecognizer.Direction.up:
                print("move up")
               // self.moveToSellerProfile()
                
                if postsListArray.count <= 0
                {
                    return
                }
                
                let tag = self.getindex
                let indexPath = IndexPath(row: tag, section: 0)
                
                let post = self.postsListArray[indexPath.row]
                get_consumer_id = post.consumer_profile_id
                
                var get_user_id = Int()
                var get_user_id_API = Int()
                get_user_id_API = Int(get_consumer_id)!
                get_user_id = (Login.loadCustomerInfoFromKeychain()?.id)!
                if get_user_id != get_user_id_API{
                    if self.postsListArray[indexPath.row].showSellerProfile == false {
                        self.moveToConusmerProfile()
                    } else {
                        self.moveToSellerProfile()
                    }
                }
            default:
                break
            }
        }
    }
    
    func goBack() {
        if isFromNotification == false {
            callback?(postsListArray)
            self.pauseVideo()
            if selectedCell != nil{
                selectedCell?.avPlayer.pause()
                selectedCell?.avPlayerLayer.removeFromSuperlayer()
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        //print("Video Finished")
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count > 0 {
            let cell = collectionView.cellForItem(at: indexPathItem[0]) as? HomePostCollectionViewCell
            cell?.avPlayer.seek(to: CMTime.zero)
        }
        //selectedCell?.avPlayer.seek(to: CMTime.zero)
        //selectedCell?.avPlayer.play()
    }
    
    @objc func finishVideo(_ sender: UIButton) {
        let tag = sender.tag
        let indexPath = IndexPath(row: tag, section: 0)
        let cell = collectionView.cellForItem(at: indexPath) as? HomePostCollectionViewCell
        cell?.avPlayer.seek(to: CMTime.zero)
        cell?.avPlayer.play()
        //print("Video Finished")
    }
    
    func pauseVideo() {
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
            }
        }
    }
    
    func playVideo() {
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count > 0 {
            getindex = indexPathItem[0].item
        }else {
            return
        }

        let tag = self.getindex
        let indexPath = IndexPath(row: tag, section: 0)
        let value = self.postsListArray[indexPath.row]
        if value.videoURL != "" {
            if let cell = collectionView.cellForItem(at: indexPath) as? HomePostCollectionViewCell {
                if(cell.avPlayer.timeControlStatus==AVPlayer.TimeControlStatus.paused) {
                    cell.play_icon_imageview.image = UIImage(named: "")
                    cell.play_icon_imageview.image = nil
                    cell.play_icon_imageview.isHidden = true
                    cell.avPlayer.play()
                    
                    self.infoTopView.alpha = 1
                    cell.itemInfoTopView.alpha = 1
                    cell.itemInfoBottomView.alpha = 1
                    cell.shadowImageView.alpha = 1

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
    
    @IBAction func shopNowButtonTapped(_ sender: UIButton) {
//        self.pauseVideo()
        var itemsToBuy: [Cart?] = []
        let indexPath = collectionView.indexPathsForVisibleItems
        if indexPath.count > 0 {
            var cartProduct: Cart? = postsListArray[indexPath[0].item].product
            cartProduct?.quantity = "1"
            cartProduct?.quantityCount = 1
            itemsToBuy.append(cartProduct)
            let dict: NSDictionary = ["array_ItemsToBuy": itemsToBuy, "classWhereProductIsAdded": String(describing: PostDetailViewController.self)]
            let preferences = CheckoutProtocolModel(dictionary: dict)
            self.moveToCheckoutScreen(checkoutPreferences: preferences)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        selectedCell?.avPlayer.pause()
    }
    
    @IBAction func productDetailButtonTapped(_ sender: UIButton) {
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count > 0 {
            getindex = indexPathItem[0].item
        }else {
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
            vc.isShowCartButtons = true
            if value.showSellerProfile {
                vc.review_id = ""
            }else {
                vc.review_id = value.id
            }
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
        self.likeTapped(isLikeButtonTap:true)
    }
    
    func likeTapped(isLikeButtonTap:Bool) {
        let indexPathItem = collectionView.indexPathsForVisibleItems
        
        if indexPathItem.count > 0 {
            getindex = indexPathItem[0].item
        }else {
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
            //DISABLE LIKE/UNLIKE buttons
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
        if count == "" {
            return
        }
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count > 0 {
            getindex = indexPathItem[0].item
        }else {
            return
        }

        let tag = self.getindex
        let indexPath = IndexPath(row: tag, section: 0)
        
        let likedIndex = self.postsListArray.index(where: { $0.id == post_id })!
        self.postsListArray[likedIndex].isLiked = true
        self.postsListArray[likedIndex].likesCount = count
        if likedIndex == indexPath.row {
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
    
    @IBAction func userProfileButtonTapped(_ sender: UIButton) {
//        self.pauseVideo()
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func brandProfileButtonTapped(_ sender: UIButton) {
        if !fromSeller
        {
            moveToSellerProfile()
        }
        //        self.dismiss(animated: true, completion: nil)
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
        
        let post = self.postsListArray[indexPath.row]
        let storyboard = UIStoryboard(name: "SellerProfile", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "BrandProfileVC") as! BrandProfileVC
        vcObj.brand = post.brand
        vcObj.isPresented = true
        let navController = UINavigationController(rootViewController: vcObj)
        self.present(navController, animated: true, completion: nil)
    }
    func moveToConusmerProfile() {
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
        vcObj.isPresentedView = true
        let navController = UINavigationController(rootViewController: vcObj)
        self.present(navController, animated: true, completion: nil)
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
                    self.playVideo()
                }
            }
        }
    }
    @objc func handleDoubleTap() {
        print("Double Tap!")
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

}

//MARK:- CollectionView Delegate and DataSource
extension PostDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
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
        if selectedCell != nil{
            selectedCell?.avPlayer.pause()
            selectedCell?.avPlayerLayer.removeFromSuperlayer()
        }
        //print("before end",indexPath.row)
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePostCollectionViewCell", for: indexPath) as? HomePostCollectionViewCell
        {
            cell.layoutIfNeeded()
            let value = self.postsListArray[indexPath.row]
            let imageName = value.imageURL
            
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
            
            
            //POST CONTENT SETUP
            //            if value.type == "Video"
            //            {
            //                cell.viewsBackView.isHidden = false
            //                cell.img_brand.isHidden = true
            //            }
            //            else
            //            {
            //                cell.viewsBackView.isHidden = true
            //                cell.img_brand.isHidden = false
            //            }
            
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

            cell.productDetailButton.isUserInteractionEnabled = true
            if value.product.product.status_description != ""
            {
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
            
            
            //POST CONTENT SETUP MEDIA
            
            cell.itemImageView.isHidden = false
            cell.cellView.isHidden = true
            cell.play_icon_imageview.isHidden = true
            cell.itemImageView.image =  nil
            cell.itemImageView.backgroundColor = UIColor.black
            //SHOW THUMBNAIL
            if imageName != ""
            {
                let url = URL(string: imageName)
                cell.itemImageView.kf.setImage(with: url, placeholder: UIImage(named:Constants.BACKGROUND_THEME_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
//
//                cell.itemImageView.kf.setImage(with: url)
            }
            cell.itemImageView.clipsToBounds = true
            if  CGFloat(value.resolutionHeight ) ==  CGFloat(value.resolutionWidth ) {
                cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
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
//                    let videoURL = URL(string: value.videoURL)!
//                    let asset = AVAsset.init(url: videoURL)
//                    asset.loadValuesAsynchronously(forKeys: ["duration", "playable"]) {
//                        // When you need to update the UI, switch back out to the main thread
//                        DispatchQueue.main.async {
//                            // Main thread
//                            // Do your UI updates here
//
//                            let item = AVPlayerItem.init(asset: asset)
//                            cell.avPlayer.replaceCurrentItem(with: item)
//                            cell.avPlayer.play()
//                            cell.cellView.layer.insertSublayer(cell.avPlayerLayer, at: 0)
//                            cell.cellView.isHidden = false
//
//                            //                                if let resolution = self.resolutionForLocalVideo(url: videoURL)
//                            //                                {
//                            //                                    if CGFloat(resolution.height ) > self.view.bounds.height-200 {
//                            //                                        if CGFloat(resolution.width ) > CGFloat(resolution.height ) {
//                            //                                            cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
//                            //                                            cell.itemImageView.contentMode = .scaleAspectFit
//                            //                                        }else {
//                            //                                            cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//                            //                                            cell.itemImageView.contentMode = .scaleAspectFill
//                            //                                        }
//                            //                                    }else {
//                            //                                        cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
//                            //                                        cell.itemImageView.contentMode = .scaleAspectFit
//                            //                                    }
//                            //                                }
//
//                            self.preriodicTimeObsever(cell : cell)
//                            NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: cell.avPlayer.currentItem)
//                        }
//                    }
//                    //                    }
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
        
        let post = self.postsListArray[indexPath.row]
        self.fetchInventoryDetail(value: post.product.product.product_id)
    }
}

//MARK:- API CALLS
extension PostDetailViewController {
    
    @objc func increaseViewCount(post_id:String, review_id:String) {
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
    
    @objc func unlikePostAPI(post_id:String,review_id:String) {
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
                            self.unlikedPost(count : count,post_id: post_id)
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
                        let product = Product(dictionary: response)
                        self.updateInventoryOfProduct(product : product)
                    }
                }
            }
        }) { (failure) -> Void in
            // your failure handle
            //self.handleAPIError(failure: failure)
        }
    }
    func callGetPostDetail(postId: String, isReviewPost: Bool)  {
        self.passedListArray.removeAll()
        self.postsListArray.removeAll()
      let store = HomePostServices.sharedInstance
        store.callFetchPostDetailAPI(showLoader: true, postId: postId, isReviewPost: isReviewPost, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any] {
                if let success = success as? [String: Any] {
                    if let result = success["response"] as? NSDictionary {
                        let value = HomePost(dictionary: result)
                        self.passedListArray.append(value)
                        self.postsListArray = self.passedListArray
                        self.collectionView.reloadData()
                    }
                }
            }
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
}

