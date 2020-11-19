//  Created by Navpreet on 31/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import UIKit

class PurchasedItemCell: UICollectionViewCell {
    @IBOutlet weak var view_Content: UIView!
    @IBOutlet weak var img_Product: UIImageView!
    @IBOutlet weak var view_Selection: UIView!
    @IBOutlet weak var lbl_ProductName: UILabel!
    @IBOutlet weak var lbl_ProductBrand: UILabel!
    @IBOutlet weak var constraint_ViewContentHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configureCell(cellWidth: CGFloat, item: Order) {
        constraint_ViewContentHeight.constant = cellWidth
        if item.isSelected == true {
            view_Selection.roundCorners([.bottomLeft], radius: 6)
            view_Selection.isHidden = false
            view_Content.borderWidth = 5.0
            view_Content.layer.borderColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1)
        }else {
            view_Selection.isHidden = true
            view_Content.borderWidth = 0
            view_Content.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
        lbl_ProductName.text = item.Product_Name.uppercased()
        lbl_ProductBrand.text = item.seller_name.uppercased()
        img_Product.image = UIImage(named: Constants.PRODUCT_DUMMY_IMAGE)
        let productImageUrl = item.image
        if productImageUrl != "" {
            let url = URL(string: productImageUrl)
            img_Product.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
}
