//  Created by Navpreet on 14/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.

import UIKit

class CheckoutItemCell: UITableViewCell {
    
    @IBOutlet weak var img_Item: UIImageView!
    @IBOutlet weak var lbl_ProductName: UILabel!
    @IBOutlet weak var lbl_SellerName: UILabel!
    
    @IBOutlet weak var lbl_ProductPrice: UILabel!
    @IBOutlet weak var lbl_ProductQty: UILabel!
    @IBOutlet weak var lbl_ProductDelivery: UILabel!
    @IBOutlet weak var lbl_ProductDeliveryBy: UILabel!
    
    @IBOutlet weak var btn_IncreaseQty: UIButton!
    @IBOutlet weak var btn_DecreaseQty: UIButton!
    @IBOutlet weak var view_QtyUpdate: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setValueForCell(cart : Cart, _ isShippingAddressAdded: Bool = true) {
        let value = cart.product
        lbl_ProductQty.text = cart.quantity == "" ? "1" : cart.quantity
        
        img_Item.image = UIImage(named:Constants.PRODUCT_DUMMY_IMAGE)
        img_Item.contentMode = .scaleAspectFill
        img_Item.clipsToBounds = true
        let productImageUrl = value.productImage
        if productImageUrl != "" {
            let url = URL(string: productImageUrl)
            img_Item.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        lbl_ProductName.text = value.name.uppercased()
        lbl_SellerName.text = value.sellerName
        lbl_ProductDelivery.text =  value.productDeliveryDate
        if value.final_price == "" {
            lbl_ProductPrice.text = value.currency + value.price
        }else {
            lbl_ProductPrice.text = value.currency + value.final_price
        }
        
        view_QtyUpdate.isHidden = false
        lbl_ProductDelivery.isHidden = false
        lbl_ProductDeliveryBy.textColor = UIColor.color(.lightBlueColor)
            if value.qtyCount <= 0 {
                view_QtyUpdate.isHidden = true
            }else {
                view_QtyUpdate.isHidden = false
            }
            if isShippingAddressAdded == false {
                lbl_ProductDelivery.isHidden = true
                lbl_ProductDeliveryBy.isHidden = true
            }else {
                lbl_ProductDelivery.isHidden = false
                lbl_ProductDeliveryBy.isHidden = false
                lbl_ProductDeliveryBy.text = "DELIVERY BY"
                lbl_ProductDelivery.text = value.productDeliveryDate
            }
    }
}
