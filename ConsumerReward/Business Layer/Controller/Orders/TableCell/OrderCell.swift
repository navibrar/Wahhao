//
//  OrderCell.swift
//  ConsumerReward
//
//  Created by apple on 14/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
     @IBOutlet weak var orderProduct_Img : UIImageView!
     @IBOutlet weak var orderProduct_Name : UILabel!
     @IBOutlet weak var orderProduct_Soldinfo : UILabel!
     @IBOutlet weak var orderProduct_Status : UILabel!
     @IBOutlet weak var orderProduct_DelioveryExpected : UILabel!
     @IBOutlet weak var orderProduct_DeliveryDate : UILabel!
    @IBOutlet weak var status_Width_Constarint : NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(item: Order) {
        orderProduct_Name.text = item.Product_Name.uppercased()
        orderProduct_Img.image = UIImage(named: Constants.PRODUCT_DUMMY_IMAGE)
        let productImageUrl = item.image
        if productImageUrl != "" {
            let url = URL(string: productImageUrl)
            orderProduct_Img.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
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
        
        let lite_font_seller = UIFont(name: Constants.LIGHT_FONT, size: 11)!
        let sellerNameAttributedString =  NSMutableAttributedString(string: combinedString)
        
        sellerNameAttributedString.addAttribute(NSAttributedString.Key.font,
                                                value: lite_font_seller,
                                                range: NSMakeRange(0, soldByStaticStr.count))
        
        sellerNameAttributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                                value: UIColor.color(.lightBlueColor),
                                                range: NSMakeRange(0, soldByStaticStr.count))
        
        
        orderProduct_Soldinfo.attributedText = sellerNameAttributedString

       // orderProduct_Soldinfo.text = "SOLD BY " + item.seller_name
        
        orderProduct_Status.text = item.order_Status.uppercased()
        orderProduct_DelioveryExpected.text = "DELIVERY EXPECTED BY"
        
        if (item.expected_delivery_date.count) > 0 {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            let showDate = inputFormatter.date(from: (item.expected_delivery_date))
            inputFormatter.dateFormat = "MMM dd, yyyy"
            let resultString = inputFormatter.string(from: showDate!)
            orderProduct_DeliveryDate.text = resultString.uppercased()
        } else {
            orderProduct_DeliveryDate.text = ""
        }
        var getwidth = CGFloat()
        getwidth = item.order_Status.uppercased().TextWidth(withConstrainedHeight: 17.0, font: UIFont(name: Constants.REGULAR_FONT, size: 11)!)
        status_Width_Constarint.constant = getwidth + 17
        
//        0 cancel
//        1  pending
//        2 confirmed
//        3 shipped
//        4 prepare for
//        5 delivered
//        6 complete
//        7 retured
    
        if item.order_Status_id == "0" || item.order_Status_id == "1" || item.order_Status_id == "7" {
            orderProduct_Status.backgroundColor = UIColor.init(red: 255/255.0, green: 79/255.0, blue: 79/255.0, alpha: 1.0)
        }  else if item.order_Status_id == "2" {
             orderProduct_Status.backgroundColor = UIColor.init(red: 59/255.0, green: 164/255.0, blue: 255/255.0, alpha: 1.0)
            
        } else if item.order_Status_id == "3" {
             orderProduct_Status.backgroundColor = UIColor.init(red: 3/255.0, green: 109/255.0, blue: 201/255.0, alpha: 1.0)
        } else if item.order_Status_id == "4" {
            orderProduct_Status.backgroundColor = UIColor.init(red: 227/255.0, green: 190/255.0, blue: 63/255.0, alpha: 1.0)
            
        } else if item.order_Status_id == "5" || item.order_Status_id == "6"{
             orderProduct_Status.backgroundColor = UIColor.init(red: 28/255.0, green: 162/255.0, blue: 97/255.0, alpha: 1.0)

        } else {
           orderProduct_Status.backgroundColor = UIColor.init(red: 255/255.0, green: 79/255.0, blue: 79/255.0, alpha: 1.0)
        }
    }
}
