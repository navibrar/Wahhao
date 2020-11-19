//
//  ProfileStoreCollectionViewCell.swift
//  Consumer
//
//  Created by apple on 7/4/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import UIKit

class ProfileStoreCollectionViewCell: UICollectionViewCell {
    // MARK:=========OUTLET DECLARATION==========
//    @IBOutlet weak var img_productImage:UIImageView!
//    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var img_Post: UIImageView!
    @IBOutlet weak var lbl_Price: UILabel!
    @IBOutlet weak var lbl_UnitsSold: UILabel!
    @IBOutlet weak var constraint_ImageHeight: NSLayoutConstraint!
    
    func configureCell(dict : Product) {
        img_Post.image = UIImage(named: Constants.PRODUCT_DUMMY_IMAGE)
        if dict.productImage != ""
        {
           
            let url = URL(string: dict.productImage)
           // let resolution = self.resolutionForimage(url: dict.productImage)
//            if resolution.height > resolution.width {
//                self.img_Post.contentMode = .scaleAspectFit
//            } else {
//                self.img_Post.contentMode = .scaleAspectFill
//            }
            self.img_Post.contentMode = .scaleAspectFill
          
                self.img_Post.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
      
        }
        if dict.bought == "0" {
            lbl_UnitsSold.text = ""
        } else {
        lbl_UnitsSold.text = dict.bought + " SOLD"
        }
        
        let currency = dict.currency
        let priceString =  currency + dict.final_price.uppercased()
        var actualPriceString = dict.price.uppercased()
        
        var combinedString  = ""
        if actualPriceString == ""
        {
            combinedString = priceString
        }
        else{
            actualPriceString = currency + actualPriceString
            combinedString = actualPriceString + " " +  priceString
        }
        
        let attributeString =  NSMutableAttributedString(string: combinedString)
        let actualPriceStringFont = UIFont(name: Constants.LIGHT_FONT, size: 12)!
         let priceStringFont = UIFont(name: Constants.REGULAR_FONT, size: 12)!
        
        
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0, actualPriceString.count))
        
        attributeString.addAttribute(NSAttributedString.Key.font,
                                     value: actualPriceStringFont,
                                     range: NSMakeRange(0, actualPriceString.count))
        
        if actualPriceString != ""
        {
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor,
                                     value: #colorLiteral(red: 0.04746739566, green: 0.5619356036, blue: 0.9403368831, alpha: 1),
                                     range: NSMakeRange(actualPriceString.count + 1, priceString.count))
        attributeString.addAttribute(NSAttributedString.Key.font,
                                     value: priceStringFont,
                                     range: NSMakeRange(actualPriceString.count+1 , priceString.count))
        }
        else{
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor,
                                         value: #colorLiteral(red: 0.04746739566, green: 0.5619356036, blue: 0.9403368831, alpha: 1),
                                         range: NSMakeRange(0, priceString.count))
            attributeString.addAttribute(NSAttributedString.Key.font,
                                         value: priceStringFont,
                                         range: NSMakeRange(0 , priceString.count))
        }
        
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor,
                                     value: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                                     range: NSMakeRange(0, actualPriceString.count))
        
        lbl_Price.attributedText = attributeString
        
        
        
        
    }
}
