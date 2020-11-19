//
//  ShopMoreVC.swift
//  Consumer
//
//  Created by Navpreet on 27/11/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl

protocol CollectionStoreDelegate {
    func selectedCollectiongroup()
    func moveToPostDetailsPage(postsArray:[HomePost],selectedIndex:Int)
}

class ShopMoreVC: UIViewController , CollectionStoreDelegate {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var shopTableView:UITableView!
    @IBOutlet weak var segment_PostType: ScrollableSegmentedControl!
    @IBOutlet weak var topSpaceConstraint: NSLayoutConstraint!
    
    var selected_product = String()
    var product_Name_Array = NSMutableArray()
    var product_Image_Array = NSMutableArray()
    var getproduct_name = String()
    var getproduct_Image = String()
    var getindex = Int()
    let topPadding = CGFloat(35.0)
    let topViewSwipeupSpace = CGFloat(110.0)

    var categories_name_array : [Category] = []
    let store = ShopMoreServices.sharedInstance
    var shopMoreArray = [ShopMore]()
    var forMeDict : [String:String]? = nil
    var selectedSubcategory : ShopMore? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        getindex = 0
        segment_PostType.backgroundColor = UIColor.clear
        
        forMeDict = ["category_code":"","category_name":"FOR YOU","category_name_cn":"FOR YOU","row_num":"0"]
        self.perform(#selector(self.fetchShopList), with: self, afterDelay: 0.1)
        
        // Do any additional setup after loading the view.
        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipedown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipedown)
        let swipeup = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeup.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(swipeup)

    }
    
    //MARK:- Language Change Notifications
    @objc func moveToBagController(notification: NSNotification) {
        self.tabBarController?.selectedIndex = 4
    }
    
    //MARK:- Gesture Method
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                //As per Mr. Kalsy
                self.dismiss(animated: true, completion: nil)
                /*if topSpaceConstraint.constant == topViewSwipeupSpace
                {
                    self.moveViewDown()
                }
                else{
                    self.dismiss(animated: true, completion: nil)
                }*/
            case UISwipeGestureRecognizer.Direction.up:
                self.moveViewUp()
            default:
                break
            }
        }
    }
    func visualSetup() {
        self.setUpPostTypeSegmentControl()
        self.moveViewDown()
    }
    func setUpPostTypeSegmentControl() {
        segment_PostType.segmentStyle = .textOnly
        segment_PostType.fixedSegmentWidth = false
        segment_PostType.underlineSelected = true
        segment_PostType.segmentContentColor = UIColor.white
        segment_PostType.selectedSegmentContentColor = UIColor.color(.blueSelectedColor)
        segment_PostType.backgroundColor = UIColor.clear

        let selectedFont = UIFont(name: Constants.SEMI_BOLD_FONT, size: 14)!
        let regularFont = UIFont(name: Constants.REGULAR_FONT, size: 14)!

        let normalTextAttribute = [NSAttributedString.Key.font: regularFont,
                                   NSAttributedString.Key.foregroundColor: UIColor.white]
        let highlightedTextAttributes = [NSAttributedString.Key.font: selectedFont,
                                         NSAttributedString.Key.foregroundColor: UIColor.color(.blueSelectedColor)]
        let selectedTextAttributes = [NSAttributedString.Key.font: selectedFont,
                                      NSAttributedString.Key.foregroundColor: UIColor.color(.blueSelectedColor)]


        segment_PostType.setTitleTextAttributes(normalTextAttribute, for: .normal)
        segment_PostType.setTitleTextAttributes(highlightedTextAttributes, for: .highlighted)
        segment_PostType.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        for index in 0..<categories_name_array.count {
            segment_PostType.insertSegment(withTitle: categories_name_array[index].displayName.uppercased() + "   ", at: index)
        }
        segment_PostType.selectedSegmentIndex = 0
        segment_PostType.addTarget(self, action: #selector(self.postTypeSegmentValueChanged(sender:)), for: .valueChanged)

    }
    
    
    @objc func postTypeSegmentValueChanged(sender:ScrollableSegmentedControl) {
        print("Related Hashtag  selected segment index:\(sender.selectedSegmentIndex)")
        if sender.selectedSegmentIndex == 0
        {
            // get For You data from API
            fetchShopList()
        }
        else
        {
            let selectedCategory = categories_name_array[sender.selectedSegmentIndex].category_code
            // get Categories data from API
            fetchCategoryShopList(value: selectedCategory, rpp: Constants.RPP_DEFAULT)
        }
    }
   
    func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.shopTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        print("Shop more View Appear")
    }
    
    func moveViewUp() {
//        movedUp = true
//        calculateProductDetailViewHeight()
        UIView.animate(withDuration: 0.5, animations: {
            self.topSpaceConstraint.constant = self.topViewSwipeupSpace
            self.view.layoutIfNeeded()
        }) { (success) in
//            UIView.transition(with: self.view, duration: 0.35, options: .transitionCrossDissolve, animations: {
//            }, completion: { (success) in
//            })
//            self.scroll_Content.contentSize = CGSize(width: 0, height: self.contentViewMaximizedHeight)
        }
    }
    func moveViewDown() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            UIView.transition(with: self.view, duration: 0.35, options: .transitionCrossDissolve, animations: {
//            }, completion: nil)
            UIView.animate(withDuration: 0.5, animations: {
                self.topSpaceConstraint.constant = self.view.frame.size.height/2 - self.topPadding
                self.view.layoutIfNeeded()
            }) { (success) in
//                self.scroll_Content.setContentOffset(.zero, animated: false)
//                self.scroll_Content.contentSize = CGSize(width: self.view.bounds.width, height: self.contentViewMinimizedHeight)
            }
        }
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
    
    func selectedCollectiongroup()
    {
//        self.performSegue(withIdentifier: "StoreListViewController", sender: self)
    }
    
    @objc func moveToBrandView(sender:UIButton) {
        let selectedCategory = shopMoreArray[sender.tag]
        self.selectedSubcategory = selectedCategory
        self.performSegue(withIdentifier: "ShopMoreCategoryListViewController", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShopMoreCategoryListViewController") {
            if let destinationVC = segue.destination as? ShopMoreCategoryListViewController {
                if self.segment_PostType.selectedSegmentIndex == 0
                {
                    destinationVC.getCategory_Name = (self.selectedSubcategory?.name)!
                }
                else{
                    destinationVC.getCategory_Name = (self.selectedSubcategory?.category_code)!
                }
                destinationVC.get_display_Name = (self.selectedSubcategory?.name)!
                destinationVC.postsList = self.selectedSubcategory
            }
        }
    }
    @IBAction func addMoreInterestsTapped(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateUserInterestsVC") as! UpdateUserInterestsVC
        let navController = UINavigationController(rootViewController: vc)
        self.show(navController, sender: self)
    }
}
extension ShopMoreVC: UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopMoreArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShopMoreParentTableViewCell
        let valueProduct = shopMoreArray[indexPath.row]
        
        let name = valueProduct.displayName
        let feeds = valueProduct.feeds

        cell.lbl_group_title.text = name.uppercased()
        cell.arrow_img.isHidden = false
        cell.lbl_group_btn.tag = indexPath.row
        cell.lbl_group_btn.addTarget(self, action: #selector(self.moveToBrandView(sender:)), for: .touchUpInside)
        cell.configureCell(posts: feeds,rownum: indexPath.row)
        cell.CollectionStoreDelegate = self
        cell.selectionStyle = .none
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
//        let inset = scrollView.contentInset
//        let y: CGFloat = offset.x - inset.left
         let y: CGFloat = offset.y
        let reload_distance: CGFloat = 100
        if y >= reload_distance && shopMoreArray.count > 1 && topSpaceConstraint.constant != topViewSwipeupSpace {
            self.moveViewUp()
        }
        let down_distance: CGFloat = -75
        if y <= down_distance && topSpaceConstraint.constant == topViewSwipeupSpace {
//            self.moveViewDown()
            //As per Mr. Kalsy
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: API CALLS
extension ShopMoreVC {
    @objc func fetchShopList() {
        store.fetchListing(showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            self.shopMoreArray.removeAll()

            if let _ = success as? [String: Any] {
                print(success)
                print("success")
                if  self.categories_name_array.count == 0
                {
                    self.categories_name_array.removeAll()
                    self.categories_name_array = self.store.all_categories_list
                    self.categories_name_array.insert(Category(dictionary: self.forMeDict! as NSDictionary), at: 0)
                    self.visualSetup()
                }
                
                self.shopMoreArray = self.store.shopMoreArray

                self.shopTableView.reloadData()
            }
        }) { (failure) -> Void in
            self.shopMoreArray.removeAll()
//            self.categories_name_array.removeAll()
            self.shopTableView.reloadData()
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    
    @objc func fetchCategoryShopList(value:String,rpp:Int) {
        store.fetchCategoryListing(value:value,rpp:rpp,showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            self.shopMoreArray.removeAll()
            if let _ = success as? [String: Any] {
                print(success)
                print("success")
                self.shopMoreArray = self.store.shopMoreArray
                self.shopTableView.reloadData()
                            }
        }) { (failure) -> Void in
            self.shopMoreArray.removeAll()
            self.shopTableView.reloadData()
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
}


