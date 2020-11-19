//
//  ShopMoreCategoryListViewController.swift
//  Consumer
//
//  Created by Apple on 11/10/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import UIKit

class ShopMoreCategoryListViewController: UIViewController {
    
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var subcategoryHeaderLabel:UILabel!
    var getCategory_Name = String()
    var get_display_Name = String()
    var fromForYou = false

    var postsList : ShopMore? = nil
    let store = ShopMoreServices.sharedInstance
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("get code from view",getCategory_Name)
        self.collectionView.isHidden = false
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.reloadData()
        self.subcategoryHeaderLabel.text = get_display_Name.uppercased()
        postsList?.feeds.removeAll()
        self.collectionView.reloadData()
      
        if getCategory_Name.caseInsensitiveCompare("Following") == .orderedSame ||   getCategory_Name.caseInsensitiveCompare("on Sale") == .orderedSame ||  getCategory_Name.caseInsensitiveCompare("$10 & Below") == .orderedSame ||  getCategory_Name.caseInsensitiveCompare("Video Reviews") == .orderedSame {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.fromForYou = true
                self.fetchSubcategoryShopListForYouTab(value: self.getCategory_Name, rpp: Constants.RPP_DEFAULT, page: self.page)
            }
        }else {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.fromForYou = false
                self.fetchSubcategoryShopList(value: self.getCategory_Name,rpp:Constants.RPP_DEFAULT, page: self.page)
            }
        }
        
        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipedown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipedown)
        self.view.isUserInteractionEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        print("list View Appear")
    }
    
    //MARK:- Gesture Method
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    func loadMoreTapped()
    {
        if fromForYou
        {
            self.fetchSubcategoryShopListForYouTab(value: getCategory_Name, rpp: Constants.RPP_DEFAULT, page: page)
        }
        else
        {
            self.fetchSubcategoryShopList(value: (postsList?.category_code)!,rpp:Constants.RPP_DEFAULT, page: page)
        }
    }

    // MARK: - Navigation

    func moveToPostDetailsPage(selectedIndex:Int)
    {
        NOTIFICATIONCENTER.post(name: Notification.Name("pauseVideo"), object: nil)
        let storyboard = UIStoryboard.init(name: "ProjectStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        vc.passedListArray = (self.postsList?.feeds)!
        vc.selectedIndex = selectedIndex
        self.present(vc, animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ShopMoreCategoryListViewController :UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (postsList?.feeds.count) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopMoreCategoryListViewCell", for: indexPath) as? ShopMoreCategoryListViewCell
        let value = postsList?.feeds[indexPath.row]
        cell?.lbl_title.text = value?.viewCount
        cell?.img_productImage.image = UIImage(named:Constants.PRODUCT_DUMMY_IMAGE)
        
        let productImageUrl = value?.imageURL
        if productImageUrl != "" {
            let url = URL(string: productImageUrl!)
            cell?.img_productImage.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }

        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
             self.moveToPostDetailsPage(selectedIndex: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView,willDisplay cell: UICollectionViewCell,forItemAt indexPath: IndexPath) {
        if indexPath.row == (postsList?.feeds.count)! - 1 {
            // need to change
            if (self.postsList?.total_feeds ?? 0) > (self.postsList?.feeds.count ?? 0)
            {
                self.loadMoreTapped()
            }
        }
    }

    //size of each CollecionViewCell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellsAcross: CGFloat = 2
        
        var widthRemainingForCellContent = collectionView.bounds.width
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let borderSize: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
            widthRemainingForCellContent -= borderSize + ((cellsAcross - 1) * flowLayout.minimumInteritemSpacing)
        }
        let cellWidth = widthRemainingForCellContent / cellsAcross
        let cellHeight: CGFloat = cellWidth
        
        return CGSize(width: cellWidth - 1, height: cellHeight)
    }
}

// MARK: API CALLS
extension ShopMoreCategoryListViewController {
    @objc func fetchSubcategoryShopList(value:String,rpp:Int,page: Int) {
        store.fetchSubcategoryListing(value:value, page: page,rpp:rpp,showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any] {
                print(success)
                print("success")
                self.page = self.page + 1
                let data = self.store.subcategoriesPostsArray
                
                for dict in data {
                    if dict.feeds.count > 0
                    {
                        for feed in dict.feeds {
                            self.postsList?.feeds.append(feed)
                        }
                    }
                }
                self.collectionView.reloadData()
            }
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    
    @objc func fetchSubcategoryShopListForYouTab(value:String,rpp:Int,page:Int) {
        store.fetchSubcategoryForYouTab(value:value, page: page,rpp:rpp,showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any] {
                print(success)
                print("success")
                self.page = self.page + 1
                let data = self.store.subcategoriesPostsArray
                for dict in data {
                    if dict.feeds.count > 0
                    {
                        for feed in dict.feeds {
                            self.postsList?.feeds.append(feed)
                        }
                    }
                }
                self.collectionView.reloadData()
            }
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
}


