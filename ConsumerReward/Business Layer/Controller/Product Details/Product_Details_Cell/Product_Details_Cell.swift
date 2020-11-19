//
//  Product_Details_Cell.swift
//  ConsumerReward
//
//  Created by apple on 17/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import UIKit

class Product_Details_Cell: UICollectionViewCell {
    @IBOutlet weak var img_Product: UIImageView!
    @IBOutlet weak var playIcon: UIImageView!

    func configureCell(dict : ProductImages) {
        img_Product.image = UIImage(named: Constants.PRODUCT_DUMMY_IMAGE)
        if dict.orignal != ""
        {
            let url = URL(string: dict.orignal)
            img_Product.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }
        playIcon.isHidden = true
        if dict.media_type.lowercased() == "video"
        {
            playIcon.isHidden = false
        }
    }
}
