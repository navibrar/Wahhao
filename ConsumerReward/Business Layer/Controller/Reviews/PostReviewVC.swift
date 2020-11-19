//  Created by Navpreet on 31/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import UIKit

class PostReviewVC: UIViewController {
    //MARK:- Variable Declaration
    var cellWidth: CGFloat = 0
    var cellHeight: CGFloat = 0
    var array_PurchasedProducts = [PurchasedProduct]()
    var array_Orders = [Order]()
    let store = OrderInfoService.sharedInstance
    
    //MARK:- Outlet Connections
    @IBOutlet weak var collection_PurchasedItems: UICollectionView!
    @IBOutlet weak var btn_PostReview: UIButton!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetUp()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.enableDisablePostReviewButton(isEnabled: false)
        self.fetchOrderList()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    //MARK:- Custom Methods
    func initialSetUp() {
        collection_PurchasedItems.register(UINib(nibName: "PurchasedItemCell", bundle: nil), forCellWithReuseIdentifier: "PurchasedItemCell")
        collection_PurchasedItems.showsVerticalScrollIndicator = false
        collection_PurchasedItems.backgroundColor = UIColor.clear
        if let layout = collection_PurchasedItems.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
            collection_PurchasedItems.collectionViewLayout = layout
        }
        cellWidth = ((UIScreen.main.bounds.width-32)/2)-4
        cellHeight = cellWidth+40
        collection_PurchasedItems.reloadData()
    }
    func enableDisablePostReviewButton(isEnabled: Bool) {
        if isEnabled == true {
            btn_PostReview.isEnabled = true
            btn_PostReview.alpha = 1.0
        }else {
            btn_PostReview.isEnabled = false
            btn_PostReview.alpha = 0.45
        }
    }
    //MARK:- Button Methods
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func postVideoReviewTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Reviews", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddVideoReviewVC") as! AddVideoReviewVC
        let index = self.array_Orders.index(where: { $0.isSelected == true })!
        vc.orders_info  = array_Orders[index]
        vc.get_post_info = "Post"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- CollectionView Delegate and DataSource
extension PostReviewVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array_Orders.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PurchasedItemCell", for: indexPath) as! PurchasedItemCell
        cell.configureCell(cellWidth: cellWidth, item: array_Orders[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var indexPaths = [IndexPath]()
        let filtered = array_Orders.filter({$0.isSelected == true})
        if filtered.count > 0 {
            let index = self.array_Orders.index(where: { $0.isSelected == true })!
            print(index)
            if index != indexPath.item {
                array_Orders[index].isSelected = false
                let indexPath = IndexPath(item: index, section: 0)
                indexPaths.append(indexPath)
            }
        }
        array_Orders[indexPath.item].isSelected = true
        indexPaths.append(indexPath)
        if let collectionView = collection_PurchasedItems {
            collectionView.reloadItems(at: indexPaths)
        }
        self.enableDisablePostReviewButton(isEnabled: true)
    }
}
extension PostReviewVC {
    @objc func fetchOrderList() {
        store.fetchOrderlistlatestInfo(showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            self.array_Orders.removeAll()
            if let _ = success as? [String: Any] {
                print(success)
                print("success")
                self.array_Orders = self.store.orders
                self.collection_PurchasedItems.reloadData()
            }
        }) { (failure) -> Void in
            self.array_Orders.removeAll()
            self.collection_PurchasedItems.reloadData()
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
}
