//
//  ProductDetailVC.swift
//  ConsumerReward
//
//  Created by apple on 12/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import UIKit
import Stripe
import Cosmos
import Branch

protocol ProductDetailDismissDelegate {
    func productDetailViewDismissed(checkoutPreferences: CheckoutProtocolModel?)
}


class ProductDetailVC: UIViewController {
    //MARK:- Protocols
    var productDetailDismissDelegate: ProductDetailDismissDelegate!
    
    //Protocol Variables
    var checkoutPreferences: CheckoutProtocolModel? = nil
    
    //=====================
    private var lastContentOffset: CGFloat = 0
    static let relatedProductViewHeight = CGFloat(190.0)
    static let variantsViewHeight = CGFloat(132.0)
    static let ratingViewHeight = CGFloat(110.0)
    static let videoReviewsViewHeight = CGFloat(275.0)
    static let seeAllViewHeight = CGFloat(50.0)

    let bottomPadding = CGFloat(80.0)
    let topPadding = CGFloat(40.0)

    var quantity = 1
    let store = CartServices.sharedInstance
    let storeProduct = ProductInfoService.sharedInstance
    
    //DeepLink
    let lp: BranchLinkProperties = BranchLinkProperties()
    var deepLinkUrl  = String()
    
    var product  : Product? = nil                    // Product basic detail Fetched from Prvious View
    var review_id  = ""                    // Product basic detail Fetched from Prvious View

    var productDetail: ProductDetail? = nil         // Complete product detail of Current fetched from API
    var selectedProduct  : Product? = nil           // Selected Variant
    var relatedProductDetail: ProductDetail? = nil  // Complete product detail fetched from API OF related Product
    var mainProductDetail: ProductDetail? = nil     // Complete product detail fetched from API OF MAIN Product
    var allVariants : [Product?] = []               // All variants of current product
    var relatedProducts: [Product] = []
    var reviewsList : [HomePost] = []
    
    var contentViewMinimizedHeight = CGFloat()
    var contentViewMaximizedHeight = CGFloat()
    var isShowCartButtons: Bool = false
    var movedUp: Bool = false
    var isCompleteProductDescription = Bool()
    var refreshCheckOutCallback : ((Bool) -> Void)?

    var callback : ((Product) -> Void)?

    
    @IBOutlet weak var backCompleteShadowOverlayView: UIView!
    @IBOutlet weak var scroll_Content: UIScrollView!
    @IBOutlet weak var lbl_product_name:UILabel!
    @IBOutlet weak var lbl_final_price:UILabel!
    @IBOutlet weak var lbl_product_descrption:UILabel!
    @IBOutlet weak var back_View:UIView!
    @IBOutlet weak var btn_More:UIButton!
    
    @IBOutlet weak var bottomButtonsView: UIView!
    var get_images_dict = [ProductImages]()
    @IBOutlet weak var product_collection: UICollectionView!
    @IBOutlet weak var relatedProductsCollectionView: UICollectionView!
    @IBOutlet weak var reviewsCollectionView: UICollectionView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var buyNowButton: UIButton!
    @IBOutlet weak var out_of_stock_view: UIView!
    @IBOutlet weak var productStatusLabel: UILabel!
    
    @IBOutlet weak var related_products_height_constraint: NSLayoutConstraint!
    @IBOutlet weak var ratings_height_constraint: NSLayoutConstraint!
    @IBOutlet weak var video_reviews_height_constraint: NSLayoutConstraint!
    @IBOutlet weak var see_all_reviews_button_height_constraint: NSLayoutConstraint!

    @IBOutlet weak var constraint_TextDescHeight: NSLayoutConstraint!
    @IBOutlet weak var constraint_BtnMoreDescHeight: NSLayoutConstraint!


    @IBOutlet weak var relatedProductsBackView: UIView!
    @IBOutlet weak var ratingsBackView: UIView!
    @IBOutlet weak var videoReviewsProductsBackView: UIView!

    @IBOutlet weak var btn_Wishlist: UIButton!
    @IBOutlet weak var btn_Share: UIButton!

    @IBOutlet weak var seeAllReviewsButton: UIButton!
    @IBOutlet weak var colorSelectionBackView: UIView!
    @IBOutlet weak var colorOptionsBackView: UIView!
    @IBOutlet weak var colorSelectedLabel: UILabel!
    
    //WISHLIST SHARE
    @IBOutlet weak var wishlistShareView: UIView!
    
    //RATINGS
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!

    //CONSTRAINTS
    @IBOutlet weak var constraint_ProductDetailTop: NSLayoutConstraint!
    @IBOutlet weak var constraiant_color_variant_view_height: NSLayoutConstraint!
    
//    private var indexOfCellBeforeDragging = 0
//    @IBOutlet private weak var collectionViewLayout: UICollectionViewFlowLayout!

    
    let scrollColorsView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 320, height: 200))
    var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var viewHeight = CGFloat(0)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipedown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipedown)

        let swipeup = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeup.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(swipeup)

        self.intialSetup()
         FirAnalytics.trackPageView(withScreen: FirAnalytics.Screen.productDetails)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: UIColor.clear), for: .default)
    }
    override func viewDidAppear(_ animated: Bool) {
        UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: UIColor.clear), for: .default)
        //SET UI OVERLAY VIEW FIRST TIME AND FETCH PRODUCT DETAIL API
        if self.mainProductDetail == nil
        {
            self.backCompleteShadowOverlayView.alpha = 0
            UIView.animate(withDuration: 0.1, animations: {
                self.backCompleteShadowOverlayView.alpha = 0.4
            }, completion: {
                finished in
            })
            self.fetchMainProductInfo(value:(self.product?.variant_id)!)
        }
    }

    @objc func intialSetup() {
        relatedProductsCollectionView.isPagingEnabled = true
        reviewsCollectionView.isPagingEnabled = true
        product_collection.isPagingEnabled = true
        
        scroll_Content.delegate = self
        scroll_Content.layer.zPosition = 1
        scroll_Content.delaysContentTouches = false
        scroll_Content.canCancelContentTouches = true
        scroll_Content.isPagingEnabled = false
        
//        scroll_Content.bounces = false
//        collectionViewLayout.minimumLineSpacing = 0
//        configureCollectionViewLayoutItemSize()

//        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
//            self.fetchMainProductInfo(value:(self.product?.variant_id)!)
//        }
        viewHeight = self.view.frame.size.height
        //Initial position of product detail view
        constraiant_color_variant_view_height.constant = 0
        colorSelectionBackView.isHidden = true
        related_products_height_constraint.constant = 0
        relatedProductsBackView.isHidden = true
        wishlistShareView.isHidden = true

        self.colorSelectionBackView.isHidden = false
        self.constraint_ProductDetailTop.constant =  viewHeight - self.colorSelectionBackView.frame.origin.y - bottomPadding - topPadding
        contentViewMinimizedHeight = viewHeight - self.colorSelectionBackView.frame.origin.y - bottomPadding - topPadding
        
    }
    
    //MARK:- DeepLinking
    func createContentReference() {
        let buo = BranchUniversalObject.init(canonicalIdentifier: "content/12345")
        buo.title = "the product"
        // buo.contentDescription = "My Content Description"
        // buo.imageUrl = "https://lorempixel.com/400/400"
        buo.publiclyIndex = true
        buo.locallyIndex = true
        buo.contentMetadata.customMetadata["product_id"] = self.product?.product_id
        
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
        lp.addControlParam("navigate_to", withValue: "productDetail")
        lp.addControlParam("variant_id", withValue: self.product?.variant_id)
        
        //createdeepLink
        
        buo.getShortUrl(with: lp) { (url, error) in
            self.deepLinkUrl = url ?? ""
        }
        UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: UIColor.color(.appThemeColor)), for: .default)
        let message = "This Wahhao product is really good. Check out this product"
        buo.showShareSheet(with: lp, andShareText: message, from: self) { (activityType, completed) in
            UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: UIColor.clear), for: .default)
            print(activityType ?? "")
        }
    }

    //MARK:- Gesture Method
//    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
//        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
//            switch swipeGesture.direction {
//            case UISwipeGestureRecognizer.Direction.down:
//                self.dismissView()
//            default:
//                break
//            }
//        }
//    }
    
    //MARK:- UIGestureRecognizer Method
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.up:
                self.moveProductDetailViewUp()
            case UISwipeGestureRecognizer.Direction.down:
                if movedUp
                {
                    self.moveProductDetailViewDown()
                }
                else{
                    self.dismissView()
                }
            default:
                break
            }
        }
    }
    
    func dismissView() {
        if self.checkoutPreferences == nil || self.checkoutPreferences?.array_ItemsToBuy.count == 0 {
            self.goBackTapped()
        }else {
             self.dismissProductDetail()
        }
    }
    
    func goBackTapped() {
        if relatedProductDetail != nil{
            self.productDetail = self.mainProductDetail
            self.relatedProductDetail = nil
            self.PrefilledData()
        }
        else{
            if refreshCheckOutCallback != nil{
                refreshCheckOutCallback!(true)
            }
            let selectedProduct = self.mainProductDetail?.all_variants.filter({$0.variant_id == self.product?.variant_id})
            if (selectedProduct?.count) ?? 0 > 0
            {
                callback?(selectedProduct![0])
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.backCompleteShadowOverlayView.alpha = 0
            }, completion: {
                finished in
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    @objc func PrefilledData() {
//        scroll_Content.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//        movedUp = false
        self.selectedProduct = nil
        self.allVariants.removeAll()
        var showRatingView = false
        
        if (self.productDetail?.all_variants.count) == 1
        {
            self.allVariants = (self.productDetail?.all_variants)!
            self.selectedProduct = self.productDetail?.all_variants[0]
        }
        else if (self.productDetail?.all_variants.count)! > 1
        {
            self.allVariants = (self.productDetail?.all_variants)!
            let filtered = self.productDetail?.all_variants.filter({$0.is_selected == true})
            if filtered!.count > 0 {
                let index = self.productDetail?.all_variants.index(where: { $0.is_selected == true })!
                self.selectedProduct = self.productDetail?.all_variants[index!]
            }
        }
        
        if self.selectedProduct != nil
        {
            self.configureScrollViewForColors()
            productVariantUIsetup()
        }
        
        self.relatedProducts.removeAll()
        self.relatedProducts = self.productDetail?.relatedProducts ?? []
        self.relatedProductsCollectionView.reloadData()

        self.reviewsList.removeAll()
        self.reviewsList = (self.productDetail?.reviews)!
        self.reviewsCollectionView.reloadData()
        
        if self.reviewsList.count > 0
        {
            video_reviews_height_constraint.constant = ProductDetailVC.videoReviewsViewHeight
            videoReviewsProductsBackView.isHidden = false
            see_all_reviews_button_height_constraint.constant = ProductDetailVC.seeAllViewHeight
            seeAllReviewsButton.isHidden = false
            showRatingView = true
        }
        else
        {
            video_reviews_height_constraint.constant = 0
            videoReviewsProductsBackView.isHidden = true
            see_all_reviews_button_height_constraint.constant = 0
            seeAllReviewsButton.isHidden = true
            showRatingView = false
        }
        
        if showRatingView
        {
            ratings_height_constraint.constant = ProductDetailVC.ratingViewHeight
            ratingsBackView.isHidden = false
        }
        else
        {
            ratings_height_constraint.constant = 0
            ratingsBackView.isHidden = true
        }
        
        if self.relatedProducts.count > 0
        {
            related_products_height_constraint.constant = ProductDetailVC.relatedProductViewHeight
            relatedProductsBackView.isHidden = false
        }
        else
        {
            related_products_height_constraint.constant = 0
            relatedProductsBackView.isHidden = true
        }
        
        self.ratingLabel.text = self.productDetail?.rating
        self.reviewsCountLabel.text = "based on \(self.productDetail?.total_reviews ?? "0") reviews".uppercased()
        self.ratingView.rating = Double((self.productDetail?.rating as NSString? )!.floatValue)
        self.ratingView.settings.fillMode = .precise
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.movedUp
            {
                self.scroll_Content.setContentOffset(.zero, animated: false)
                self.moveProductDetailViewUp()
            }
            else{
                self.moveProductDetailViewDown()
            }
        }
//        self.calculateProductDetailViewHeight()
//        self.scroll_Content.contentSize = CGSize(width: 0, height:self.contentViewMaximizedHeight)
    }
    
    func productVariantUIsetup() {
        lbl_product_name.text = self.selectedProduct?.name.uppercased()
        colorSelectedLabel.text = self.selectedProduct?.color_name.uppercased()
        wishlistShareView.isHidden = false

        let currency = self.selectedProduct?.currency  ?? "$"
        let priceString =  currency + (self.selectedProduct?.final_price.uppercased())!
        var actualPriceString = self.selectedProduct?.price.uppercased() ?? ""
        
        var combinedString  = ""
        if actualPriceString == ""
        {
            combinedString = priceString
        }
        else{
            actualPriceString = currency + actualPriceString
            combinedString = actualPriceString + " " +  priceString
        }
        
        let attributeString =  NSMutableAttributedString(string: combinedString)
        let regularFont = UIFont(name: Constants.SEMI_BOLD_FONT, size: 22)!
        
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0, actualPriceString.count))
        
        attributeString.addAttribute(NSAttributedString.Key.font,
                                     value: regularFont,
                                     range: NSMakeRange(0, actualPriceString.count))
        
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor,
                                     value: #colorLiteral(red: 0.04746739566, green: 0.5619356036, blue: 0.9403368831, alpha: 1),
                                     range: NSMakeRange(0, actualPriceString.count))
        
        lbl_final_price.attributedText = attributeString
        
//        lbl_product_descrption.text = self.selectedProduct?.description
        
        isCompleteProductDescription = false
        let initialProductDescHeight = setProductDescriptionTextAndGetHeight()
        self.contentViewMaximizedHeight -= self.constraint_TextDescHeight.constant
        self.contentViewMaximizedHeight += initialProductDescHeight
        
        get_images_dict = (self.selectedProduct?.all_image)!
        
        self.product_collection.reloadData()
        self.isProductAddedToWishlist(isAdded: (self.selectedProduct?.isAddedToWishlist)!, variant_id: (self.selectedProduct?.variant_id)!)
        
        self.btn_Wishlist.isUserInteractionEnabled = true
        self.btn_Share.isUserInteractionEnabled = true

        if isShowCartButtons == true {
            bottomButtonsView.isHidden = false
            if self.selectedProduct?.status_description != ""
            {
                addToCartButton.isEnabled = false
                buyNowButton.isEnabled = false
                self.out_of_stock_view.isHidden = false
                self.bottomButtonsView.isHidden = true
                if self.selectedProduct?.statusValue == .deleted
                {
                    self.btn_Wishlist.isUserInteractionEnabled = false
                    self.btn_Share.isUserInteractionEnabled = false
                }
            }
            else
            {
                addToCartButton.isEnabled = true
                buyNowButton.isEnabled = true
                self.out_of_stock_view.isHidden = true
                self.bottomButtonsView.isHidden = false
            }
            self.productStatusLabel.text = self.selectedProduct?.status_description.uppercased()
            
        }else {
            bottomButtonsView.isHidden = true
        }
        if movedUp
        {
            self.scroll_Content.setContentOffset(.zero, animated: false)
            self.moveProductDetailViewUp()
        }
    }
    func isProductAddedToWishlist(isAdded: Bool,variant_id:String) {
        if isAdded == true {
            self.btn_Wishlist.setImage(UIImage(named: "HeartFillIcon"), for: .normal)
            
            self.selectedProduct!.isAddedToWishlist = true
            let filtered = self.productDetail?.all_variants.filter({$0.variant_id == variant_id})
            if filtered!.count > 0 {
                let index = self.productDetail?.all_variants.index(where: { $0.variant_id == variant_id })!
                self.productDetail?.all_variants[index!].isAddedToWishlist = true
                self.allVariants[index!]!.isAddedToWishlist = true
                if self.relatedProductDetail != nil
                {
                    self.relatedProductDetail?.all_variants[index!].isAddedToWishlist = true
                }
                else
                {
                    self.mainProductDetail?.all_variants[index!].isAddedToWishlist = true
                }
            }
//            self.mainProductDetail?.isAddedToWishlist = true
//            self.productDetail?.isAddedToWishlist = true
        }else {
           self.btn_Wishlist.setImage(UIImage(named: "HeartWhiteIcon"), for: .normal)
            self.selectedProduct!.isAddedToWishlist = false
            let filtered = self.productDetail?.all_variants.filter({$0.variant_id == variant_id})
            if filtered!.count > 0 {
                let index = self.productDetail?.all_variants.index(where: { $0.variant_id == variant_id })!
                self.productDetail?.all_variants[index!].isAddedToWishlist = false
                self.allVariants[index!]!.isAddedToWishlist = false
                if self.relatedProductDetail != nil
                {
                    self.relatedProductDetail?.all_variants[index!].isAddedToWishlist = false
                }
                else
                {
                    self.mainProductDetail?.all_variants[index!].isAddedToWishlist = false
                }
            }

//            self.mainProductDetail?.isAddedToWishlist = false
//            self.productDetail?.isAddedToWishlist = false
        }
    }
    @IBAction func addToBagButtonTapped(_ sender: UIButton) {
        addToCartAPI(isQtyIncreased: true)
    }
    @IBAction func buyNowButtonTapped(_ sender: UIButton) {
       // self.moveToCheckoutScreen(product)
         FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.productDetails, category: FirAnalytics.Category.productDetails, label: FirAnalytics.Label.productdetails_buynow_tapped, action: FirAnalytics.Actions.buyNowBtn, value: 1)
        var itemsToBuy: [Cart?] = []
        var cartProduct: Cart? = Cart(dictionary: ["id":0])
        cartProduct?.product = self.selectedProduct!
        cartProduct?.quantity = "1"
        cartProduct?.quantityCount = 1
        cartProduct?.product.sellerName = self.selectedProduct!.brand.display_name
        itemsToBuy.append(cartProduct)
        if self.checkoutPreferences != nil {
            self.checkoutPreferences?.array_ItemsToBuy = itemsToBuy
            self.checkoutPreferences?.isClearCart = false
            self.checkoutPreferences?.review_id = self.review_id
            self.dismissProductDetail()
        }else {
            let dict: NSDictionary = ["array_ItemsToBuy": itemsToBuy, "classWhereProductIsAdded": String(describing: productDetail.self)]
            var preferences = CheckoutProtocolModel(dictionary: dict)
            preferences.isClearCart = false
            self.checkoutPreferences?.review_id = self.review_id
            self.moveToCheckoutScreen(checkoutPreferences: preferences)
        }
    }
    @IBAction func wishlistTapped(_ sender: Any) {
        if self.selectedProduct?.isAddedToWishlist == true {
            //Remove from wishlist
            self.callRemoveProductFromWishlist()
        }else {
            //Add to wishlist
            self.callAddProductToWishlist()
        }
    }
    @IBAction func shareTapped(_ sender: Any) {
        createContentReference()
    }
    
    @IBAction func seeAllReviewsTapped(_ sender: UIButton) {
        // your successful handle
        FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.productDetails, category: FirAnalytics.Category.productDetails, label: FirAnalytics.Label.produtcdetails_seemorereviews_tapped, action: FirAnalytics.Actions.seemorereviews_tapped, value: 1)
        NOTIFICATIONCENTER.post(name: Notification.Name("pauseVideo"), object: nil)
        let storyboard = UIStoryboard.init(name: "ProjectStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductAllReviewsVC") as! ProductAllReviewsVC
        vc.product_id = (self.product?.variant_id)!
        let navController = UINavigationController(rootViewController: vc)
        self.show(navController, sender: self)
    }
    
    @IBAction func moreProductDescriptionTapped(_ sender: UIButton) {
        isCompleteProductDescription = !isCompleteProductDescription
        self.contentViewMaximizedHeight -= self.constraint_TextDescHeight.constant
        let initialProductDescHeight = setProductDescriptionTextAndGetHeight()
        self.contentViewMaximizedHeight += initialProductDescHeight
        self.scroll_Content.contentSize = CGSize(width: 0, height: self.contentViewMaximizedHeight)
    }
//    func calculateProductDetailViewHeight() {
//        let textDescriptionHeight = 40
//        let tableReviewInitialHeight = 220
//        let btnMoreDescBtnHeight = 30
//        var contentHeight: CGFloat = CGFloat(1540-textDescriptionHeight-tableReviewInitialHeight-btnMoreDescBtnHeight)
//        let initialProductDescHeight = setProductDescriptionTextAndGetHeight()
//        contentHeight += initialProductDescHeight
//        self.contentViewMaximizedHeight = contentHeight
//    }
    func setProductDescriptionTextAndGetHeight() -> CGFloat {
        var height = CGFloat()
        let productDescription = selectedProduct?.description ?? ""
        let descriptionCount = productDescription.count
        if descriptionCount < 120 {
            constraint_BtnMoreDescHeight.constant = 0
            btn_More.isHidden = true
            lbl_product_descrption.text = productDescription
            let textHeight = productDescription.TextHeight(withConstrainedWidth: self.view.bounds.width-32, font: lbl_product_descrption.font!)
            constraint_TextDescHeight.constant = textHeight
            height = constraint_TextDescHeight.constant
        }else {
            constraint_BtnMoreDescHeight.constant = 25
            if isCompleteProductDescription == false {
//                let desc = productDescription.prefix(120) + "..."
                let desc = productDescription
                lbl_product_descrption.text = String(desc)
                btn_More.setTitle("MORE", for: .normal)
                btn_More.isHidden = false
                let textHeight = CGFloat(45)
                constraint_TextDescHeight.constant = textHeight
                height = constraint_TextDescHeight.constant
            }else {
                lbl_product_descrption.text = productDescription
                btn_More.setTitle("LESS", for: .normal)
                btn_More.isHidden = false
                let textHeight = productDescription.TextHeight(withConstrainedWidth: self.view.bounds.width-32, font: lbl_product_descrption.font!) + 10
                constraint_TextDescHeight.constant = textHeight
                height = constraint_TextDescHeight.constant
            }
        }
        return height
    }

    func moveProductDetailViewUp() {
        movedUp = true
        UIView.animate(withDuration: 0.5, animations: {
            self.constraint_ProductDetailTop.constant = 110
            self.view.layoutIfNeeded()
            self.calculateProductDetailViewHeight()
        }) { (success) in
//            UIView.transition(with: self.view, duration: 0.35, options: .transitionCrossDissolve, animations: {
//            }, completion: { (success) in
//            })
            self.scroll_Content.contentSize = CGSize(width: 0, height: self.contentViewMaximizedHeight)
        }
    }
    func moveProductDetailViewDown() {
        movedUp = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            UIView.transition(with: self.view, duration: 0.35, options: .transitionCrossDissolve, animations: {
//            }, completion: nil)
            UIView.animate(withDuration: 0.5, animations: {
                self.constraint_ProductDetailTop.constant = self.viewHeight - self.colorSelectionBackView.frame.origin.y - self.bottomPadding - self.topPadding
                self.view.layoutIfNeeded()
            }) { (success) in
                self.scroll_Content.setContentOffset(.zero, animated: false)
                self.scroll_Content.contentSize = CGSize(width: self.view.bounds.width, height: self.contentViewMinimizedHeight)
            }
        }
    }
    func calculateProductDetailViewHeight() {
//        let textDescriptionHeight = 40
//        let tableReviewInitialHeight = 220
//        let btnMoreDescBtnHeight = 30
//        var contentHeight: CGFloat = CGFloat(1330-textDescriptionHeight-tableReviewInitialHeight-btnMoreDescBtnHeight)
//        let initialProductDescHeight = setProductDescriptionTextAndGetHeight()
//        contentHeight += initialProductDescHeight
//        let tableReviewContentHeight = getProductReviewsTableHeight()
//        contentHeight += tableReviewContentHeight
//        let initialProductDescHeight = setProductDescriptionTextAndGetHeight()
//        scrollHeight += initialProductDescHeight
//        self.contentViewMaximizedHeight = contentHeight
        
        let scrollHeight = seeAllReviewsButton.frame.origin.y + seeAllReviewsButton.frame.size.height + 30
        self.contentViewMaximizedHeight = scrollHeight
    }
    func dismissProductDetail() {
        
         self.backCompleteShadowOverlayView.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.dismiss(animated: false) {
                self.productDetailDismissDelegate.productDetailViewDismissed(checkoutPreferences: self.checkoutPreferences)
            }
        })
       
    }
    
    func moveToPostDetailsPage(postsArray:[HomePost],selectedIndex:Int)
    {
        NOTIFICATIONCENTER.post(name: Notification.Name("pauseVideo"), object: nil)
        let storyboard = UIStoryboard.init(name: "ProjectStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        vc.passedListArray = postsArray
        vc.selectedIndex = selectedIndex
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK:- UICollectionViewDelegate & UICollectionViewDataSource
extension ProductDetailVC :UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.relatedProductsCollectionView
        {
            return relatedProducts.count
        }
        else if collectionView == self.reviewsCollectionView
        {
            if reviewsList.count >= 2
            {
                return 2
            }
            else{
                return reviewsList.count
            }
        }
        return get_images_dict.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.relatedProductsCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedProductsCollectionViewCell", for: indexPath) as? RelatedProductsCollectionViewCell
            cell?.configureCell(dict: relatedProducts[indexPath.item])
            return cell!
        }
        else if collectionView == self.reviewsCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewsCollectionViewCell", for: indexPath) as? ReviewsCollectionViewCell
            cell?.configureCell(dict: reviewsList[indexPath.item])
            return cell!
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Product_Details_Cell", for: indexPath) as? Product_Details_Cell
            cell?.configureCell(dict: get_images_dict[indexPath.item])
            return cell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.relatedProductsCollectionView
        {
            let product = relatedProducts[indexPath.item]
            self.fetchRelatedProductInfo(value:(product.variant_id))
        }
        if collectionView == self.product_collection
        {
            NOTIFICATIONCENTER.post(name: Notification.Name("pauseVideo"), object: nil)
            let storyboard = UIStoryboard(name: "ProjectStoryboard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProductPreviewViewController") as! ProductPreviewViewController
            vc.productImagesArray = self.get_images_dict
            vc.selectedIndex = indexPath.row
            self.present(vc, animated: true, completion: nil)
        }
        if collectionView == self.reviewsCollectionView
        {
            NOTIFICATIONCENTER.post(name: Notification.Name("pauseVideo"), object: nil)
            self.moveToPostDetailsPage(postsArray: self.reviewsList, selectedIndex: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == product_collection
        {
            if get_images_dict.count > 2
            {
                self.product_collection.isScrollEnabled = true
            }
            else
            {
                self.product_collection.isScrollEnabled = false
            }
            if get_images_dict.count == 1
            {
                let cellWidth : CGFloat = 167.0
                let viewPadding : CGFloat = 16.0
                
                let leftInset = (self.view.frame.size.width - cellWidth)/2 - viewPadding
                return UIEdgeInsets(top: 0, left: leftInset+16, bottom: 0, right: leftInset+16)
            }
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

//MARK:- Scroll View Delegate
extension ProductDetailVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.product_collection {
//            var currentCellOffset = self.product_collection.contentOffset
//            currentCellOffset.x += self.product_collection.frame.width / 2
//            if let indexPath = self.product_collection.indexPathForItem(at: currentCellOffset) {
//                self.product_collection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
//            }
            var visibleRect = CGRect()
            visibleRect.origin = product_collection.contentOffset
            visibleRect.size = product_collection.bounds.size
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let indexPath = self.product_collection.indexPathForItem(at: visiblePoint) {
                self.product_collection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
        }
        if scrollView == self.relatedProductsCollectionView {
            var visibleRect = CGRect()
            visibleRect.origin = relatedProductsCollectionView.contentOffset
            visibleRect.size = relatedProductsCollectionView.bounds.size
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let indexPath = self.relatedProductsCollectionView.indexPathForItem(at: visiblePoint) {
                self.relatedProductsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
//            var currentCellOffset = self.relatedProductsCollectionView.contentOffset
//            currentCellOffset.x += self.relatedProductsCollectionView.frame.width / 3
//            if let indexPath = self.relatedProductsCollectionView.indexPathForItem(at: currentCellOffset) {
//                self.relatedProductsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
//            }
        }
        if scrollView == self.reviewsCollectionView {
            var visibleRect = CGRect()
            visibleRect.origin = reviewsCollectionView.contentOffset
            visibleRect.size = reviewsCollectionView.bounds.size
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let indexPath = self.reviewsCollectionView.indexPathForItem(at: visiblePoint) {
                self.reviewsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == scroll_Content
        {
            self.lastContentOffset = scrollView.contentOffset.y
            if self.lastContentOffset < -50 {
                self.dismissView()
            }
            if self.lastContentOffset > 10 && !movedUp
            {
                self.moveProductDetailViewUp()
            }
        }
    }
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        if scrollView == relatedProductsCollectionView
//        {
//            // Stop scrollView sliding:
//            targetContentOffset.pointee = scrollView.contentOffset
//
//            // calculate where scrollView should snap to:
//            let indexOfMajorCell = self.indexOfMajorCell()
//
//            // calculate conditions:
//            let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
//            let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < self.relatedProducts.count && velocity.x > swipeVelocityThreshold
//            let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
//            let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
//            let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
//
//            if didUseSwipeToSkipCell {
//
//                let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
//                let toValue = collectionViewLayout.itemSize.width * CGFloat(snapToIndex)
//
//                // Damping equal 1 => no oscillations => decay animation:
//                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
//                    scrollView.contentOffset = CGPoint(x: toValue, y: 0)
//                    scrollView.layoutIfNeeded()
//                }, completion: nil)
//
//            } else {
//                // This is a much better way to scroll to a cell:
//                let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
//                collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//            }
//        }
//        if scrollView == scroll_Content
//        {
//            self.lastContentOffset = scrollView.contentOffset.y
//            if self.lastContentOffset < -50 {
//                self.dismissView()
//            }
//            if self.lastContentOffset > 10 && !movedUp
//            {
//                self.moveProductDetailViewUp()
//            }
//        }
//    }
//    private func indexOfMajorCell() -> Int {
//        let itemWidth = collectionViewLayout.itemSize.width
//        let proportionalOffset = (collectionViewLayout.collectionView!.contentOffset.x / itemWidth)
//        let index = Int(round(proportionalOffset)) + 2
//        let safeIndex = max(0, min(self.relatedProducts.count - 1, index))
//        return safeIndex
//    }
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if scrollView == relatedProductsCollectionView
//        {
//            indexOfCellBeforeDragging = indexOfMajorCell()
//        }
//    }
    // MARK :  SCROLL TO SELECT COLORS
    func configureScrollViewForColors() {
        if self.scrollColorsView.isDescendant(of: self.colorOptionsBackView) {
            for view in scrollColorsView.subviews{
                view.removeFromSuperview()
            }
            self.scrollColorsView.removeFromSuperview()
        }
        for view in colorOptionsBackView.subviews{
            view.removeFromSuperview()
        }
        

        if self.allVariants.count <= 1
        {
            constraiant_color_variant_view_height.constant = 0
            self.colorSelectionBackView.isHidden = true
            return
        }
        
        constraiant_color_variant_view_height.constant = ProductDetailVC.variantsViewHeight
        self.colorSelectionBackView.isHidden = false
        scrollColorsView.removeFromSuperview()
        scrollColorsView.frame.size.width = self.view.frame.size.width
        scrollColorsView.frame.size.height = self.colorOptionsBackView.frame.size.height
        scrollColorsView.frame.origin.x = self.colorOptionsBackView.frame.origin.x
        scrollColorsView.showsVerticalScrollIndicator = false
        
        let itemsCount = self.allVariants.count

        var padding = 10
        var X_Postion = 0
        let itemWidth = Int(scrollColorsView.frame.size.height)
        var scrollWidth = CGFloat(((itemsCount) * itemWidth)+padding)
        var X_Postion_Selected = X_Postion

        for index in 0..<itemsCount {
            
            let frame = self.colorOptionsBackView.bounds
            print("frame",frame)
            let myNewView = UIView()
            if index == 0
            {
                padding = 0
                X_Postion = Int(0)
                print("X_Postion",X_Postion)
            }
            else{
                padding = 10
                X_Postion =  X_Postion + itemWidth
                print("X_Postion 2 ,",X_Postion)
            }

            let color_value = self.allVariants[index]!.color_code
            let xPosition =  CGFloat(index * (itemWidth  + padding))
            let yPosition =  CGFloat(1)
            let height =  frame.size.height - yPosition*2
            let width =  height
            myNewView.frame = CGRect(x: CGFloat(X_Postion), y: yPosition, width: width, height: height)
            print("myNewView",myNewView)
            let viewWidth = width + CGFloat(padding)
            
            // Change UIView background colour
            myNewView.backgroundColor=UIColor.clear
            myNewView.tag = index
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width:width-10, height: height-10))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            myNewView.addSubview(imageView)
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
            button.backgroundColor = UIColor.clear
            button.setTitle("", for: .normal)
            button.tag = index
            button.borderWidth = 2
            button.cornerRadius = 4
            button.clipsToBounds = true
            button.cornerRadius = (button.frame.size.width)/2

            if self.allVariants[index]?.is_selected == true
            {
                button.borderColor = UIColor.color(.lightBlueColor)
                colorSelectedLabel.text =  self.allVariants[index]!.color_name.uppercased()
                X_Postion_Selected = X_Postion
            }
            else{
                button.borderColor = UIColor.clear
            }
            
            button.addTarget(self, action: #selector(selectedColorsButtonAction), for: .touchUpInside)
            myNewView.addSubview(button)
            
            imageView.center = button.center
            imageView.center = CGPoint(x: button.frame.size.width  / 2,
                                       y:button.frame.size.height  / 2);
            
            imageView.backgroundColor = UIColor.color(.blueSelectedColor)
            if color_value != ""
            {
                if (self.allVariants[index]?.color_type_image)!
                {
                    let url = URL(string: color_value)
                    imageView.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
                }
                else
                {
                    imageView.backgroundColor = UIColor.hexStr(color_value, alpha: 1.0)
                }
            }

            imageView.cornerRadius = (imageView.frame.size.width)/2
            imageView.clipsToBounds = true
            scrollColorsView.addSubview(myNewView)
            scrollColorsView.backgroundColor = UIColor.clear
            print("scrollColorsView",scrollColorsView)
            scrollWidth = xPosition + viewWidth
        }
        
        scrollWidth = scrollWidth - CGFloat(padding)
        let backSpacing = CGFloat((self.allVariants.count - 1) * 10)
        scrollWidth = scrollWidth - backSpacing
        if scrollWidth >=  self.view.frame.size.width
        {
            scrollColorsView.frame = CGRect(x: 0, y: scrollColorsView.frame.origin.y, width: self.view.frame.size.width, height: colorOptionsBackView.frame.size.height)
        }
        else
        {
            scrollColorsView.frame = CGRect(x: scrollColorsView.frame.origin.x, y: scrollColorsView.frame.origin.y, width: scrollWidth, height: colorOptionsBackView.frame.size.height)
        }
        scrollColorsView.contentSize = CGSize(width: scrollWidth, height: colorOptionsBackView.frame.size.height)


////        scrollColorsView.contentOffset = CGRect(x: scrollColorsView.frame.origin.x, y: scrollColorsView.frame.origin.y, width: scrollWidth, height: colorOptionsBackView.frame.size.height)
//
////        scrollColorsView.frame = CGRect(x: scrollColorsView.frame.origin.x, y: scrollColorsView.frame.origin.y, width: self.view.frame.size.width, height: colorOptionsBackView.frame.size.height)
//        self.scrollColorsView.contentSize = CGSize(width: scrollWidth, height: colorOptionsBackView.frame.size.height)

//        self.colorOptionsBackView.backgroundColor = UIColor.gray
//        self.scrollColorsView.backgroundColor = UIColor.green

        self.colorOptionsBackView.addSubview(scrollColorsView)
        scrollColorsView.delegate = self
        scrollColorsView.center.x = self.colorOptionsBackView.center.x
        scrollColorsView.isScrollEnabled = true
        scrollColorsView.showsHorizontalScrollIndicator = false
        scrollColorsView.showsVerticalScrollIndicator = false
        if CGFloat(X_Postion_Selected) >=  self.view.frame.size.width
        {
            scrollColorsView.setContentOffset(CGPoint(x: CGFloat(CGFloat(X_Postion_Selected) - self.view.frame.size.width + CGFloat(itemWidth) ), y: scrollColorsView.frame.origin.y), animated: true)
        }
    }
    
    @objc func selectedColorsButtonAction(sender: UIButton!){
        let tappedViewTag = sender.tag
        self.selectedProduct = nil
        self.selectedProduct = self.allVariants[tappedViewTag]
        self.selectedProduct?.is_selected = true
        
        let itemsCount = self.productDetail?.all_variants.count ?? 0

        for index in 0..<itemsCount {

            self.productDetail?.all_variants[index].is_selected = false

            if self.relatedProductDetail != nil
            {
                self.relatedProductDetail?.all_variants[index].is_selected = false
            }
            else{
                self.mainProductDetail?.all_variants[index].is_selected = false
            }
        }
        
        let filtered = self.productDetail?.all_variants.filter({$0.variant_id == self.selectedProduct?.variant_id})
        if filtered!.count > 0 {
            let index = self.productDetail?.all_variants.index(where: { $0.variant_id == self.selectedProduct?.variant_id })!
            self.productDetail?.all_variants[index!].is_selected = true
            if self.relatedProductDetail != nil
            {
                self.relatedProductDetail?.all_variants[index!].is_selected = true
            }
            else
            {
                self.mainProductDetail?.all_variants[index!].is_selected = true
            }
        }
        
        self.productVariantUIsetup()
        for tempView in scrollColorsView.subviews {
            for innerView in tempView.subviews
            {
                if let iconImage = innerView as? UIButton
                {
                    if (tempView.tag == tappedViewTag) {
                        iconImage.borderColor = UIColor.color(.lightBlueColor)
                    }
                    else{
                        iconImage.borderColor = UIColor.clear
                    }
                }
            }
        }
    }
}

// MARK: API CALLS
extension ProductDetailVC {
    func addToCartAPI(isQtyIncreased: Bool) {
        let parameters : [String:Any] = [
            "variant_id": self.selectedProduct?.variant_id ?? "",
            "is_qty_increased": isQtyIncreased,
            "review_id":review_id
            //"quantity": quantity
        ]
        store.callWebserviceAddToCart(parameters : parameters , showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            let alert = CustomAlert()
            alert.showCustomAlertWithImage(message: "Item added to cart", imageName: "add_to_cart_icon", viewController: self)
             FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.productDetails, category: FirAnalytics.Category.productDetails, label: FirAnalytics.Label.productdetails_addtocart_tapped, action: FirAnalytics.Actions.addtocart_tapped, value: 1)
            if let result = success as? [String: Any] {
                if let response = result["response"] as? NSDictionary {
                    
                    if let countValue  = response["cart_items_count"]
                    {
                        let count = countValue as! Int
                        _ = Network.currentAccount?.updateTotalItemCount(count : count)
                        NOTIFICATIONCENTER.post(name: Notification.Name("UpdateCartCount"), object: nil)
                    }
                }
            }
        }) { (failure) -> Void in
            // your failure handle
             FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.productDetails, category: FirAnalytics.Category.productDetails, label: FirAnalytics.Label.productdetails_addtocart_tapped, action: FirAnalytics.Actions.addtocart_tapped, value: 0)
            self.handleAPIError(failure: failure)
        }
    }
    
   
    @objc func fetchMainProductInfo(value:String) {
        storeProduct.fetchProductInfo(value:value,showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any] {
                print(success)
                self.mainProductDetail = self.storeProduct.productDetail
                self.productDetail = self.storeProduct.productDetail
                self.PrefilledData()
            }
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    
    @objc func fetchRelatedProductInfo(value:String) {
        storeProduct.fetchProductInfo(value:value,showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
               FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.productDetails, category: FirAnalytics.Category.productDetails, label: FirAnalytics.Label.produtcdetails_relatedproduct_tapped, action: FirAnalytics.Actions.relatedproduct_tapped, value: 1)
            if let _ = success as? [String: Any] {
                print(success)
                self.relatedProductDetail = self.storeProduct.productDetail
                self.productDetail = self.storeProduct.productDetail
                self.PrefilledData()
            }
        }) { (failure) -> Void in
            // your failure handle
            // your successful handle
            FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.productDetails, category: FirAnalytics.Category.productDetails, label: FirAnalytics.Label.produtcdetails_relatedproduct_tapped, action: FirAnalytics.Actions.relatedproduct_tapped, value: 0)
            self.handleAPIError(failure: failure)
        }
    }
    
    func callAddProductToWishlist() {
        let parameters : [String:Any] = [
            "variation_id": self.selectedProduct?.variant_id ?? "",
            "quantity": quantity
        ]
        storeProduct.callAddProductToWishListAPI(parameters : parameters , showLoader: true, completionBlockSuccess: { (success) -> Void in
               FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.productDetails, category: FirAnalytics.Category.productDetails, label: FirAnalytics.Label.produtcdetails_addwishlist_tapped, action: FirAnalytics.Actions.addwishlist_tapped, value: 1)
            
            if let response = success["response"] as? NSDictionary {
                if let wishlist = response["wishlist_items"] as? NSDictionary {
                    print(wishlist)
                    self.isProductAddedToWishlist(isAdded: true,variant_id: (self.selectedProduct?.variant_id)!)
                }
            }
        }) { (failure) -> Void in
            // your failure handle
             FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.productDetails, category: FirAnalytics.Category.productDetails, label: FirAnalytics.Label.produtcdetails_addwishlist_tapped, action: FirAnalytics.Actions.addwishlist_tapped, value: 0)
            self.handleAPIError(failure: failure)
        }
    }
    
    func callRemoveProductFromWishlist() {
        let parameters : [String:Any] = [
            "id": self.selectedProduct?.variant_id ?? ""
        ]
        storeProduct.callRemoveProductFromWishListAPI(parameters : parameters , showLoader: true, completionBlockSuccess: { (success) -> Void in
              FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.productDetails, category: FirAnalytics.Category.productDetails, label: FirAnalytics.Label.productdetails_removewishlist_tapped, action: FirAnalytics.Actions.removewishlist_tapped, value: 1)
            if let response = success["response"] as? NSDictionary {
                print(response)
                self.isProductAddedToWishlist(isAdded: false,variant_id: (self.selectedProduct?.variant_id)!)
            }
        }) { (failure) -> Void in
            // your failure handle
             FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.productDetails, category: FirAnalytics.Category.productDetails, label: FirAnalytics.Label.productdetails_removewishlist_tapped, action: FirAnalytics.Actions.removewishlist_tapped, value: 0)
            self.handleAPIError(failure: failure)
        }
    }
}
