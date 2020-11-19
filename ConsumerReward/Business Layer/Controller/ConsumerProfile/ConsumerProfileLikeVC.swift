//
//  ConsumerProfileLikeVC.swift
//  ConsumerReward
//
//  Created by apple on 08/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import UIKit
import AVKit

class ConsumerProfileLikeVC: UIViewController {
    //MARK:- Variable Declaratio
    var dict_Localized = [String:String]()
    //MARK:- Outlet Connections
    @IBOutlet weak var collection_Likes: UICollectionView!
    @IBOutlet weak var view_no_img: UIView!
    @IBOutlet weak var no_Photo : UILabel!
    @IBOutlet weak var no_Product_Btn : UIButton!
    var array_Products = [NSMutableDictionary]()
    var screenWidth = UIScreen.main.bounds.width
    // Mark: - Get info Disply set Data & Repllace Later with API Content
    
    var consumerBasic: consumerBasicInfo? = nil
    var LikesArray = [HomePost]()
    
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
    //MARK:- Custom Methods
    func initialSetup() {
        
        view_no_img.isHidden = true
        self.collection_Likes.reloadData()
        collection_Likes.showsVerticalScrollIndicator = false
        collection_Likes.isScrollEnabled = false
        collection_Likes.backgroundColor = UIColor.clear
        if let layout = collection_Likes.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
            collection_Likes.collectionViewLayout = layout
        }
        
    }
    
    func visualSetup() {
        if LikesArray.count > 0
        {
            view_no_img.isHidden  = true
        }
        else{
            view_no_img.isHidden = false
        }
        self.collection_Likes.reloadData()
    }
    func passDataToBaseView(ConsumerProfile: consumerBasicInfo) {
        self.consumerBasic = ConsumerProfile
        LikesArray.removeAll()
        /*if self.consumerBasic != nil {
            LikesArray = self.consumerBasic?.post_media.filter({$0.isLiked == true}) ?? []
        }*/
        LikesArray = self.consumerBasic?.post_media ?? []
        self.visualSetup()
    }
    
    
    func showAlertWithMessage(message:String, title: String) {
        AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: title, message: message, btnTitle: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelOk"), viewController: self) { (success)
            in
        }
    }
    /*@objc func bagButtonTapped(sender: UIButton)   {
     let storyboard = UIStoryboard(name: "ProjectStoryboard", bundle: nil)
     let vc = storyboard.instantiateViewController(withIdentifier: "AddToBagViewController")
     vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
     self.present(vc, animated: true, completion: nil)
     }*/
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
extension ConsumerProfileLikeVC :UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LikesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConsumerLikeCell", for: indexPath) as! ConsumerLikeCell
        cell.configureCell(dict: LikesArray[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "ProjectStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        vc.passedListArray = self.LikesArray
        vc.selectedIndex = indexPath.row
        vc.callback = { posts in
            //Do what you want in here!
            /*let loggedInUserId = Login.loadCustomerInfoFromKeychain()?.id
            let currentUserId = Int((self.parent as? ConsumerProfileVC)?.getUseridStr ?? "0")
            if loggedInUserId == currentUserId {
                let updatedArray = posts.filter({$0.isLiked == true})
                (self.parent as? ConsumerProfileVC)?.btn_Likes.setTitle("LIKES (\(updatedArray.count))", for: .normal)
                (self.parent as? ConsumerProfileVC)?.consumerBasic?.post_media.removeAll()
                (self.parent as? ConsumerProfileVC)?.consumerBasic?.post_media = updatedArray
                let btn = UIButton()
                (self.parent as? ConsumerProfileVC)?.Likes_Tapped(btn)
            }*/
        }
        self.present(vc, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (screenWidth-64)/2
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
}
