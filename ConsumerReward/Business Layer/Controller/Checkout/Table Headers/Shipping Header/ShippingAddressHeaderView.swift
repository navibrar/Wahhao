//  Created by Navpreet on 18/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

class ShippingAddressHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var view_Back: UIView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var img_Dropdown: UIImageView!
    @IBOutlet weak var lbl_Seperator: UILabel!
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.backgroundView?.backgroundColor = .clear
    }
    
    func configureHeader(item: CheckoutHeader) {
        lbl_Title.text = item.title.uppercased()
        lbl_Address.text = item.description.uppercased()
        if item.isExpaned == false  {
            lbl_Seperator.isHidden = true
            if #available(iOS 11.0, *) {
                view_Back.layer.cornerRadius = 6
                view_Back.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            }
        }else {
            lbl_Seperator.isHidden = false
            if #available(iOS 11.0, *) {
                view_Back.layer.cornerRadius = 6
                view_Back.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            }
        }
        view_Back.clipsToBounds = true
        if item.isDataAvailable == false  {
            img_Dropdown.image = UIImage(named: "right_white_arrow")
            lbl_Address.textColor = UIColor.color(.lightBlueColor)
        }else {
            lbl_Address.textColor = UIColor.white
           if item.isExpaned == false  {
            img_Dropdown.image = UIImage(named: "down_white_arrow")
           }else {
                img_Dropdown.image = UIImage(named: "up_white_arrow")
            }
        }
    }
}
