//
//  ConsumerProfileReviewVC.swift
//  ConsumerReward
//
//  Created by apple on 08/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import UIKit
import AVKit

class ConsumerProfileReviewVC: UIViewController {
    //MARK:- Variable Declaration
    
    var array_Products = [NSMutableDictionary]()
    // Mark: - Get info Disply set Data & Repllace Later with API Content
    var dict_Localized = [String:String]()
    var screenWidth = UIScreen.main.bounds.width
    //MARK:- Outlet Connections
    @IBOutlet weak var collection_View_Review: UICollectionView!
    @IBOutlet weak var no_Photo : UILabel!
    @IBOutlet weak var no_review : UIView!
    
    var consumerBasic: consumerBasicInfo? = nil
    var reviewArray = [HomePost]()
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    //MARK:- Custom Methods
    func initialSetup() {
        no_review.isHidden = true
        self.collection_View_Review.reloadData()
        collection_View_Review.showsVerticalScrollIndicator = false
        collection_View_Review.isScrollEnabled = false
        collection_View_Review.backgroundColor = UIColor.clear
        if let layout = collection_View_Review.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
            collection_View_Review.collectionViewLayout = layout
        }
        
    }
    
    func visualSetup() {
        if reviewArray.count > 0
        {
            no_review.isHidden  = true
        }
        else{
            no_review.isHidden = false
        }
        self.collection_View_Review.reloadData()
    }
    func passDataToBaseView(ConsumerProfile: consumerBasicInfo) {
        self.consumerBasic = ConsumerProfile
        
        if self.consumerBasic != nil
        {
            reviewArray = (self.consumerBasic?.reviewsInfo)!
        }
        self.visualSetup()
    }
    
}

//MARK:- UICollectionViewDelegate & UICollectionViewDataSource
extension ConsumerProfileReviewVC :UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConsumerReviewCell", for: indexPath) as? ConsumerReviewCell
        cell?.configureCell(dict: reviewArray[indexPath.item])
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "ProjectStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        vc.passedListArray = self.reviewArray
        vc.selectedIndex = indexPath.row
        vc.callback = { posts in
            //Do what you want in here!
            /*let loggedInUserId = Login.loadCustomerInfoFromKeychain()?.id
            let currentUserId = Int((self.parent as? ConsumerProfileVC)?.getUseridStr ?? "0")
            if loggedInUserId == currentUserId {
                self.reviewArray.removeAll()
                self.reviewArray = posts
                self.collection_View_Review.reloadData()
            }*/
        }
        self.present(vc, animated: true, completion: nil)
    }
    //size of each CollecionViewCell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (screenWidth-64)/2
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
