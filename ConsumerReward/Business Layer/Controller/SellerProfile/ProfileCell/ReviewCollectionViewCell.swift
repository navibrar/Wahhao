//
//  ReviewCollectionViewCell.swift
//  Brand
//
//  Created by apple on 29/11/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import UIKit

class ReviewCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var img_productImage:UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var LikeLabel: UILabel!
    
    func configureCell(dict : HomePost) {
        let imageName = dict.imageURL
        img_productImage.image = UIImage(named: Constants.PRODUCT_DUMMY_IMAGE)
        if imageName != ""
        {
            let url = URL(string: imageName)
            // let resolution = self.resolutionForimage(url: dict.imageURL)
            //            if resolution.height > resolution.width {
            //                self.img_productImage.contentMode = .scaleAspectFit
            //            } else {
            //                self.img_productImage.contentMode = .scaleAspectFill
            //            }
            self.img_productImage.contentMode = .scaleAspectFill
            
            self.img_productImage.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
            
            
            
        }
        LikeLabel.text = dict.likesCount
        priceLabel.text = formatPriceToTwoDecimalPlace(amount: Float(dict.totalCashback)!)
    }
}
