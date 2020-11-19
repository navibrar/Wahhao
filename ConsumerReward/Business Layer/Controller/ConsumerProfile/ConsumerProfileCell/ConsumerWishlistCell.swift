//
//  ConsumerWishlistCell.swift
//  ConsumerReward
//
//  Created by apple on 08/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import UIKit

class ConsumerWishlistCell: UICollectionViewCell {
    
    @IBOutlet weak var img_Post: UIImageView!
    @IBOutlet weak var lbl_Like: UILabel!
    @IBOutlet weak var constraint_ImageHeight: NSLayoutConstraint!
    
//    func configureCell(dict : NSDictionary) {
//        img_Post.image = UIImage.init(named: dict["Image"]as! String)
//        lbl_Like.text = (dict["Like"] as! String)
//    }
    
    func configureCell(dict : Product) {
        img_Post.image = UIImage(named: Constants.PRODUCT_DUMMY_IMAGE)
        if dict.productImage != ""
        {
             let imageUrl = dict.productImage
            let url = URL(string: imageUrl)
            self.img_Post.contentMode = .scaleAspectFill
//            let resolution = self.resolutionForimage(url: imageUrl)
//            if resolution.height > resolution.width {
//                self.img_Post.contentMode = .scaleAspectFit
//            } else {
//                self.img_Post.contentMode = .scaleAspectFill
//            }
            
            self.img_Post.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
       
      //  lbl_UnitsSold.text = dict.bought + " SOLD"
        lbl_Like.text = "  " + dict.total_love
        
        }
    }
    
}
