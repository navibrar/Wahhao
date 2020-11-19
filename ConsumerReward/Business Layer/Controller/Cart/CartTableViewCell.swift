//
//  CartTableViewCell.swift
//  Consumer
//
//  Created by apple on 6/27/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {


    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productSellerNameLabel: UILabel!

    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var productDeliveryDateLabel: UILabel!
    @IBOutlet weak var productDeliveryByLabel: UILabel!

    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var quantityUpdateView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setValueForCell(cart : Cart) {
        let value = cart.product
        productCountLabel.text = cart.quantity == "" ? "1" : cart.quantity
        
        itemImageView.image = UIImage(named:Constants.PRODUCT_DUMMY_IMAGE)
        
        let productImageUrl = value.productImage
        if productImageUrl != "" {
            let url = URL(string: productImageUrl)
            itemImageView.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }

        productNameLabel.text = value.name.uppercased()
        productSellerNameLabel.text = value.sellerName
        productDeliveryDateLabel.text =  value.productDeliveryDate
        if value.final_price == ""
        {
            productPriceLabel.text = value.currency + value.price
        }
        else{
            productPriceLabel.text = value.currency + value.final_price
        }

        quantityUpdateView.isHidden = false
        productDeliveryDateLabel.isHidden = false
        productDeliveryByLabel.textColor = UIColor.color(.lightBlueColor)

//        if value.productDeliveryDate == "" {
//            if value.qtyCount <= 0 {
//                productDeliveryByLabel.text = "sold out".uppercased()
//                productDeliveryByLabel.textColor = UIColor.red
//                quantityUpdateView.isHidden = true
//            }
//            else if value.qtyCount <= 10 {
//                productDeliveryByLabel.text = ("ONLY " +  value.qty  + " AVAILABLE").uppercased()
//            }else {
//                productDeliveryByLabel.text = "MORE THAN 10 AVAILABLE".uppercased()
//            }
//            productDeliveryDateLabel.isHidden = true
//        }
        
        if value.productDeliveryDate == "" {
            productDeliveryByLabel.text = value.status_description.uppercased()
            if value.status_description != ""
            {
                productDeliveryByLabel.textColor = UIColor.red
                quantityUpdateView.isHidden = true
            }
            else
            {
                if value.qtyCount <= 0 {
                    productDeliveryByLabel.textColor = UIColor.red
                    quantityUpdateView.isHidden = true
                }else if value.qtyCount == 1 {
                    productDeliveryByLabel.text = ("ONLY 1 LEFT").uppercased()
                }else if value.qtyCount <= 10 {
                    productDeliveryByLabel.text = ("ONLY " +  value.qty  + " AVAILABLE").uppercased()
                }else {
                    productDeliveryByLabel.text = "MORE THAN 10 AVAILABLE".uppercased()
                }
            }
            productDeliveryDateLabel.isHidden = true
        }
    }
    
}
