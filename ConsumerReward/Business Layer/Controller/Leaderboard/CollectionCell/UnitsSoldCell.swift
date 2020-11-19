//  Created by Navpreet on 17/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.

import UIKit

class UnitsSoldCell: UICollectionViewCell {
    
    @IBOutlet weak var img_Post: UIImageView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Rank: UILabel!
    @IBOutlet weak var constraint_ImageHeight: NSLayoutConstraint!
    @IBOutlet weak var view_ProductStatus: UIView!
    @IBOutlet weak var lbl_ProductStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.view_ProductStatus.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.7)
    }
    
    func configureCell(cellWidth: CGFloat, item: UnitsSold) {
        constraint_ImageHeight.constant = cellWidth
        self.lbl_Title.text = "\(item.units_sold) SOLD"
        lbl_Rank.roundCorners([.topRight], radius: 6)
        lbl_Rank.text = "\(item.ranking)"
        img_Post.image = UIImage(named: Constants.PRODUCT_DUMMY_IMAGE)
        let postImageUrl = item.product_image
        if postImageUrl != "" {
            let url = URL(string: postImageUrl)
            img_Post.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }
        if item.status_description == "" {
            self.view_ProductStatus.isHidden = true
        }else {
            self.view_ProductStatus.isHidden = false
            lbl_ProductStatus.text = item.status_description.uppercased()
        }
    }
    
}
