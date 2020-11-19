//  Created by Navpreet on 03/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit
import AVKit

class ProfileReviewsVC: UIViewController {
    //MARK:- Variable Declaration
    var reviewsArray = [HomePost]()
    var screenWidth = UIScreen.main.bounds.width
    var brandProfile: BrandProfile? = nil

    //MARK:- Outlet Connections
    @IBOutlet weak var collection_view: UICollectionView!
    @IBOutlet weak var noDataView : UIView!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        visualSetup()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    func passDataToBaseView(brandProfile: BrandProfile) {
        self.brandProfile = brandProfile
        reviewsArray.removeAll()
        if self.brandProfile != nil
        {
            reviewsArray = self.brandProfile?.reviews ?? []
        }
        self.visualSetup()
    }
    //MARK:- Custom Methods
    func initialSetup() {
//        brandProfile = self.store.brandprofileMasterdata?.profileHomeDeatils

        collection_view.showsVerticalScrollIndicator = false
        collection_view.isScrollEnabled = false
        collection_view.backgroundColor = UIColor.clear
        if let layout = collection_view.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
            collection_view.collectionViewLayout = layout
        }
    }
    
    func visualSetup() {
        if reviewsArray.count > 0
        {
            noDataView.isHidden = true
        }
        else{
            noDataView.isHidden = false
        }
        self.collection_view.reloadData()
    }
}
//MARK:- UICollectionViewDelegate & UICollectionViewDataSource
extension ProfileReviewsVC :UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCollectionViewCell", for: indexPath) as? ReviewCollectionViewCell
        cell?.configureCell(dict: reviewsArray[indexPath.item])
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // self.performSegue(withIdentifier: "brandProfileVideoPicDetails", sender: self)
        //        let src = self.postsArray[indexPath.row]
        //        self.postsArray.remove(at: indexPath.row)
        //        self.postsArray.insert(src, at: 0)
        let storyboard = UIStoryboard.init(name: "ProjectStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        vc.passedListArray = self.reviewsArray
        vc.selectedIndex = indexPath.row
        vc.fromSeller = true
        vc.callback = { posts in
            //Do what you want in here!
            self.reviewsArray.removeAll()
            self.reviewsArray = posts
            self.collection_view.reloadData()
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    //size of each CollecionViewCell
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let cellWidth = (screenWidth-64)/2
            
            return CGSize(width: cellWidth, height: cellWidth)
        }
}
