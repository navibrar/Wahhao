//
//  OrderPurchaseItemsCell.swift
//  ConsumerReward
//
//  Created by apple on 15/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import UIKit

class OrderPurchaseItemsCell: UITableViewCell {
    @IBOutlet weak var purchase_id : UILabel!
    @IBOutlet weak var purchase_Image : UIImageView!
    @IBOutlet weak var purchase_name : UILabel!
    @IBOutlet weak var purchase_SoldBy : UILabel!
    @IBOutlet weak var purchase_Qty : UILabel!
    @IBOutlet weak var purchase_Color : UILabel!
    @IBOutlet weak var purchase_Price : UILabel!
    @IBOutlet weak var track_lbl : UILabel!
    @IBOutlet weak var track_Btn : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(item: PurchaseDetails) {
        purchase_Image.image = UIImage(named: Constants.PRODUCT_DUMMY_IMAGE)
        let productImageUrl = item.image.Thumbnail
        if productImageUrl != "" {
            let url = URL(string: productImageUrl)
            purchase_Image.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        purchase_name.text = item.product_name.uppercased()
        
        let lite_font_seller = UIFont(name: Constants.LIGHT_FONT, size: 11)!
        let regular_font = UIFont(name: Constants.REGULAR_FONT, size: 12)!
        let lite_font_color = UIFont(name: Constants.LIGHT_FONT, size: 12)!

        //////COLOR UI ATTRIBUTE
        let colorStaticStr =  "COLOR : "
        let colorStr = item.color.uppercased()
        
        var colorCombinedString  = ""
        if colorStr == ""
        {
            colorCombinedString = colorStaticStr
        }
        else{
            colorCombinedString = colorStaticStr + colorStr
        }
        
        let colorAttributedString =  NSMutableAttributedString(string: colorCombinedString)
        
        colorAttributedString.addAttribute(NSAttributedString.Key.font,
                                                value: lite_font_color,
                                                range: NSMakeRange(0, colorStaticStr.count))
        
        colorAttributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                                value: UIColor.color(.lightBlueColor),
                                                range: NSMakeRange(0, colorStaticStr.count))
        
        purchase_Color.attributedText = colorAttributedString
        
        
        //////QTY UI ATTRIBUTE
        let qtyStaticStr =  "Qty : "
        let qtySTr = item.qty
        
        var qtyCombinedString  = ""
        if qtySTr == ""
        {
            qtyCombinedString = qtyStaticStr
        }
        else{
            qtyCombinedString = qtyStaticStr + qtySTr
        }
        
        let qtyAttributeString =  NSMutableAttributedString(string: qtyCombinedString)
        qtyAttributeString.addAttribute(NSAttributedString.Key.font,
                                        value: regular_font,
                                        range: NSMakeRange(0, qtyStaticStr.count))
        
        qtyAttributeString.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.color(.lightBlueColor),
                                        range: NSMakeRange(0, qtyStaticStr.count))
        
        purchase_Qty.attributedText = qtyAttributeString
        
        //////SELLER UI ATTRIBUTE
        let soldByStaticStr =  "SOLD BY "
        let sellerNameSTr = item.seller_name
        
        var combinedString  = ""
        if sellerNameSTr == ""
        {
            combinedString = soldByStaticStr
        }
        else{
            combinedString = soldByStaticStr + sellerNameSTr
        }
        
        let sellerNameAttributedString =  NSMutableAttributedString(string: combinedString)
        
        sellerNameAttributedString.addAttribute(NSAttributedString.Key.font,
                                     value: lite_font_seller,
                                     range: NSMakeRange(0, soldByStaticStr.count))
        
        sellerNameAttributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                     value: UIColor.color(.lightBlueColor),
                                     range: NSMakeRange(0, soldByStaticStr.count))
        
        purchase_SoldBy.attributedText = sellerNameAttributedString
        
        var totalPrice: Float = 0
        totalPrice = (item.final_price as NSString).floatValue
        let totalPriceStr = formatPriceToTwoDecimalPlace(amount: totalPrice)
        purchase_Price.text = totalPriceStr
        
        track_lbl.text = "track shipment".uppercased()
    }
}
