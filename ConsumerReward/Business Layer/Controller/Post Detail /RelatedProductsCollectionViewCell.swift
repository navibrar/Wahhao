//
//  RelatedProductsCollectionViewCell.swift
//  Consumer
//
//  Created by apple on 19/12/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import UIKit

class RelatedProductsCollectionViewCell: UICollectionViewCell {
    // MARK:=========OUTLET DECLARATION==========
    
    @IBOutlet weak var item_image: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_sellerName: UILabel!
    
    func configureCell(dict : Product) {
        item_image.image = UIImage(named: Constants.PRODUCT_DUMMY_IMAGE)
        if dict.productImage != ""
        {
            let url = URL(string: dict.productImage)
            item_image.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }

        lbl_name.text = dict.name.uppercased()
        lbl_sellerName.text = dict.sellerName.uppercased()
    }
}
