//
//  ConsumerProfileWishlistVC.swift
//  ConsumerReward
//
//  Created by apple on 08/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import UIKit
import AVKit

class ConsumerProfileWishlistVC: UIViewController {
    //MARK:- Variable Declaration
    var dict_Localized = [String:String]()
    //MARK:- Outlet Connections
    @IBOutlet weak var collection_Wishlist: UICollectionView!
    @IBOutlet weak var view_no_img: UIView!
    @IBOutlet weak var no_Photo : UILabel!
    @IBOutlet weak var no_Product_Btn : UIButton!
    var array_Products = [NSMutableDictionary]()
    var consumerBasic: consumerBasicInfo? = nil
    var wishlistArray = [Product]()
    var screenWidth = UIScreen.main.bounds.width
    // Mark: - Get info Disply set Data & Repllace Later with API Content
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NOTIFICATIONCENTER.removeObserver(self)
    }
    //MARK:- Custom Methods
    func initialSetup() {
        
        view_no_img.isHidden = true
        self.collection_Wishlist.reloadData()
        collection_Wishlist.showsVerticalScrollIndicator = false
        collection_Wishlist.isScrollEnabled = false
        collection_Wishlist.backgroundColor = UIColor.clear
        if let layout = collection_Wishlist.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
            collection_Wishlist.collectionViewLayout = layout
        }
        
    }
    func visualSetup() {
        if wishlistArray.count > 0
        {
            view_no_img.isHidden  = true
        }
        else{
            view_no_img.isHidden = false
        }
        self.collection_Wishlist.reloadData()
    }
    func passDataToBaseView(ConsumerProfile: consumerBasicInfo) {
        self.consumerBasic = ConsumerProfile
       
        if self.consumerBasic != nil
        {
//            wishlistArray = self.consumerBasic?.wishlistinfo.filter({$0.isAddedToWishlist == true}) ?? []
            wishlistArray = (self.consumerBasic?.wishlistinfo)!
        }
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
    func moveToProductDetailsPage(product: Product) {
        if product.statusValue == .deleted
        {
            showAlertWithMessage(title: "", message: "Product is removed from database.")
            return
        }
        let storyboard = UIStoryboard(name: "ProjectStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        vc.product = product
        vc.isShowCartButtons = true
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.callback = { product in
            //Do what you want in here!
            /*let loggedInUserId = Login.loadCustomerInfoFromKeychain()?.id
            let currentUserId = Int((self.parent as? ConsumerProfileVC)?.getUseridStr ?? "0")
            if loggedInUserId == currentUserId {
                let index = self.wishlistArray.index(where: { $0.variant_id == product.variant_id })!
                if !product.isAddedToWishlist
                {
                    self.wishlistArray.remove(at: index)
                }
                self.collection_Wishlist.reloadData()
                (self.parent as? ConsumerProfileVC)?.btn_Wishlist.setTitle("WISHLIST (\(self.wishlistArray.count))", for: .normal)
                if self.wishlistArray.count > 0  {
                    (self.parent as? ConsumerProfileVC)?.lbl_Following.text = "\(self.wishlistArray.count)".uppercased()
                } else {
                    (self.parent as? ConsumerProfileVC)?.lbl_Following.text = "wishlist".uppercased()
                }
                (self.parent as? ConsumerProfileVC)?.consumerBasic?.wishlistinfo.removeAll()
                (self.parent as? ConsumerProfileVC)?.consumerBasic?.wishlistinfo = self.wishlistArray
            }*/
            DispatchQueue.main.asyncAfter(deadline: .now()+0.25, execute: {
                 NOTIFICATIONCENTER.post(name: Notification.Name(rawValue: "UserProfile"), object: nil)
            })
        }
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK:- UICollectionViewDelegate & UICollectionViewDataSource
extension ConsumerProfileWishlistVC :UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishlistArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConsumerWishlistCell", for: indexPath) as! ConsumerWishlistCell
        cell.configureCell(dict: wishlistArray[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = self.wishlistArray[indexPath.item]
        let variant_id = selectedProduct.variant_id
        if variant_id != "<null>" || variant_id != "" {
            self.moveToProductDetailsPage(product: selectedProduct)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (screenWidth-64)/2
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
}
