//  Created by Navpreet on 18/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

class PaymentMethodHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var view_Back: UIView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_CardNumber: UILabel!
    @IBOutlet weak var img_Dropdown: UIImageView!
    @IBOutlet weak var img_PaymentCard: UIImageView!
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.backgroundView?.backgroundColor = .clear
    }
    
    func configureHeader(item: CheckoutHeader) {
        lbl_Title.text = item.title.uppercased()
        if item.isExpaned == false  {
            if #available(iOS 11.0, *) {
                view_Back.layer.cornerRadius = 6
                view_Back.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            }
        }else {
            if #available(iOS 11.0, *) {
                view_Back.layer.cornerRadius = 6
                view_Back.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            }
        }
        view_Back.clipsToBounds = true
        if item.isDataAvailable == false  {
            img_Dropdown.image = UIImage(named: "right_white_arrow")
            lbl_CardNumber.text = item.description.uppercased()
            lbl_CardNumber.textColor = UIColor.color(.lightBlueColor)
            img_PaymentCard.isHidden = true
        }else {
            img_PaymentCard.isHidden = false
            lbl_CardNumber.textColor = UIColor.white
            lbl_CardNumber.text = item.description.uppercased()
            img_PaymentCard.image = item.image
            if item.isExpaned == false  {
                img_Dropdown.image = UIImage(named: "down_white_arrow")
            }else {
                img_Dropdown.image = UIImage(named: "up_white_arrow")
            }
        }
    }
}
