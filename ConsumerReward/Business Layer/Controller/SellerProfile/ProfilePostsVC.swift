//  Created by Navpreet on 03/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit
import AVKit

class ProfilePostsVC: UIViewController {
    //MARK:- Variable Declaration
    var postsArray = [HomePost]()
    var screenWidth = UIScreen.main.bounds.width
    var brandProfile: BrandProfile? = nil

    //MARK:- Outlet Connections
    @IBOutlet weak var collection_view: UICollectionView!
    @IBOutlet weak var noDataView: UIView!
    
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
        postsArray.removeAll()
        if self.brandProfile != nil
        {
            postsArray = self.brandProfile?.post_media ?? []
        }
        self.visualSetup()
    }

    //MARK:- Custom Methods
    func initialSetup() {
        noDataView.isHidden = true
        self.collection_view.reloadData()
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
        if postsArray.count > 0
        {
            noDataView.isHidden = true
        }
        else{
            noDataView.isHidden = false
        }
        self.collection_view.reloadData()
    }

    //MARK:- Button Methods
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if segue.identifier == "brandProfileVideoPicDetails" {
         if let vc = segue.destination as? brandProfileVideoPicDetails {
         vc.checkForImageAndVideo = true
         }
         }*/
    }
}

//MARK:- UICollectionViewDelegate & UICollectionViewDataSource
extension ProfilePostsVC :UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePostsCollectionViewCell", for: indexPath) as! ProfilePostsCollectionViewCell
        cell.configureCell(dict: postsArray[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // self.performSegue(withIdentifier: "brandProfileVideoPicDetails", sender: self)
//        let src = self.postsArray[indexPath.row]
//        self.postsArray.remove(at: indexPath.row)
//        self.postsArray.insert(src, at: 0)
        let storyboard = UIStoryboard.init(name: "ProjectStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        vc.passedListArray = self.postsArray
        vc.selectedIndex = indexPath.row
        vc.fromSeller = true
        vc.callback = { posts in
            //Do what you want in here!
            self.postsArray.removeAll()
            self.postsArray = posts
            self.collection_view.reloadData()
        }

        self.present(vc, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (screenWidth-64)/2
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
}
