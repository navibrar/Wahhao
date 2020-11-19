//
//  ShopMoreParentTableViewCell.swift
//  Consumer
//
//  Created by Navpreet on 04/10/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import UIKit

class ShopMoreParentTableViewCell: UITableViewCell {
@IBOutlet weak var collectionViewShopMore: UICollectionView!
     var postsArray = [HomePost]()
    @IBOutlet weak var lbl_group_title:UILabel!
    @IBOutlet weak var lbl_group_btn:UIButton!
    @IBOutlet weak var arrow_img: UIImageView!
    var selectedStoryIndex = 0
    
    var CollectionStoreDelegate: CollectionStoreDelegate?
    
//    private var indexOfCellBeforeDragging = 0
//    @IBOutlet private weak var collectionViewLayout: UICollectionViewFlowLayout!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Initialization code
        collectionViewShopMore.delegate = self
        collectionViewShopMore.dataSource = self
        collectionViewShopMore.isPagingEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(posts:[HomePost],rownum:Int) {
        collectionViewShopMore.tag = rownum
        postsArray = posts
        collectionViewShopMore.reloadData()
    }
}

extension ShopMoreParentTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopMoreInnerCollectionViewCell", for: indexPath) as? ShopMoreInnerCollectionViewCell
        
        let value = postsArray[indexPath.row]
        cell?.lbl_title.text = value.viewCount
        cell?.img_productImage.image = UIImage(named:Constants.PRODUCT_DUMMY_IMAGE)
        let productImageUrl = value.imageURL
        if productImageUrl != "" {
            let url = URL(string: productImageUrl)
            cell?.img_productImage.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.CollectionStoreDelegate?.moveToPostDetailsPage(postsArray:postsArray,selectedIndex:indexPath.row)
        collectionView.reloadData()
    }
}
extension ShopMoreParentTableViewCell : UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        var currentCellOffset = self.collectionViewShopMore.contentOffset
//        currentCellOffset.x += self.collectionViewShopMore.frame.width / 3
//        if let indexPath = self.collectionViewShopMore.indexPathForItem(at: currentCellOffset) {
//            self.collectionViewShopMore.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
//        }
        var visibleRect = CGRect()
        visibleRect.origin = collectionViewShopMore.contentOffset
        visibleRect.size = collectionViewShopMore.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let indexPath = self.collectionViewShopMore.indexPathForItem(at: visiblePoint) {
            self.collectionViewShopMore.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        if scrollView == collectionViewShopMore
//        {
//            // Stop scrollView sliding:
//            targetContentOffset.pointee = scrollView.contentOffset
//
//            // calculate where scrollView should snap to:
//            let indexOfMajorCell = self.indexOfMajorCell()
//
//            // calculate conditions:
//            let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
//            let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < self.postsArray.count && velocity.x > swipeVelocityThreshold
//            let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
//            let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
//            let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
//
//            if didUseSwipeToSkipCell {
//
//                let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
//                let toValue = collectionViewLayout.itemSize.width * CGFloat(snapToIndex)
//
//                // Damping equal 1 => no oscillations => decay animation:
//                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
//                    scrollView.contentOffset = CGPoint(x: toValue, y: 0)
//                    scrollView.layoutIfNeeded()
//                }, completion: nil)
//
//            } else {
//                // This is a much better way to scroll to a cell:
//                let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
//                collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//            }
//        }
//    }
//    private func indexOfMajorCell() -> Int {
//        let itemWidth = collectionViewLayout.itemSize.width
//        let proportionalOffset = (collectionViewLayout.collectionView!.contentOffset.x / itemWidth)
//        let index = Int(round(proportionalOffset)) + 2
//        let safeIndex = max(0, min(self.postsArray.count - 1, index))
//        return safeIndex
//    }
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if scrollView == collectionViewShopMore
//        {
//            indexOfCellBeforeDragging = indexOfMajorCell()
//        }
//    }
}
