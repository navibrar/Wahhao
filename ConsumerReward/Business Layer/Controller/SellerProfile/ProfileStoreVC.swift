//  Created by Navpreet on 03/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

class ProfileStoreVC: UIViewController {
    //MARK:- Variable Declaration
    var screenWidth = UIScreen.main.bounds.width
    var storeArray = [Product]()
    var brandProfile: BrandProfile? = nil

    //MARK:- Outlet Connections
    @IBOutlet weak var collection_view:UICollectionView!
    @IBOutlet weak var noDataView: UIView!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        self.visualSetup()
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
        storeArray.removeAll()
        if self.brandProfile != nil
        {
            storeArray = self.brandProfile?.store_media ?? []
        }
        self.visualSetup()
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
        self.present(vc, animated: true, completion: nil)
    }
    //MARK:- Language Change Notifications
    func initialSetup() {
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
        if storeArray.count > 0
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
extension ProfileStoreVC :UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileStoreCollectionViewCell", for: indexPath) as? ProfileStoreCollectionViewCell
        cell?.configureCell(dict: storeArray[indexPath.item])
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = self.storeArray[indexPath.item]
        self.moveToProductDetailsPage(product: selectedProduct)
    }
    //size of each CollecionViewCell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     let cellWidth = (screenWidth-72)/3
        let cellHeight = cellWidth + 48
     return CGSize(width: cellWidth, height: cellHeight)
     }
}
