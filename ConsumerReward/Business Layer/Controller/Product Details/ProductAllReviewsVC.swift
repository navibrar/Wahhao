//
//  ProductAllReviewsVC.swift
//  Consumer
//
//  Created by apple on 7/9/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import UIKit
import AVKit
class ProductAllReviewsVC: UIViewController {
    
    //@Variable declaration
    var reviewsList : [HomePost] = []
    var product_id = ""
    let storeProduct = ProductInfoService.sharedInstance

    //@Outlet declaration
    @IBOutlet weak var reviewsCollectionView: UICollectionView!
 
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.fetchAllReviews()
    }

    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = true
        self.view.endEditing(true)
    }

    func moveToPostDetailsPage(postsArray:[HomePost],selectedIndex:Int)
    {
        let storyboard = UIStoryboard.init(name: "ProjectStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        vc.passedListArray = postsArray
        vc.selectedIndex = selectedIndex
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK:- UICollectionViewDelegate & UICollectionViewDataSource
extension ProductAllReviewsVC :UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewsCollectionViewCell", for: indexPath) as? ReviewsCollectionViewCell
        cell?.configureCell(dict: reviewsList[indexPath.item])
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.moveToPostDetailsPage(postsArray: self.reviewsList, selectedIndex: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

// MARK: API CALLS
extension ProductAllReviewsVC {
    @objc func fetchAllReviews() {
        storeProduct.fetchAllReviewsAPI(value:product_id,showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any] {
                print(success)
                self.reviewsList.removeAll()
                self.reviewsList = self.storeProduct.reviewsList
                self.reviewsCollectionView.reloadData()
            }
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
}
