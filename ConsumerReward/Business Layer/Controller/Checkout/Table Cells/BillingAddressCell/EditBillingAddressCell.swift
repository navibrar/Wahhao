//  Created by Navpreet on 29/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import UIKit

class EditBillingAddressCell: UITableViewCell {
    
    @IBOutlet weak var view_Content: UIView!
    @IBOutlet weak var lbl_BillingAddressTitle: UILabel!
    @IBOutlet weak var img_SameAsShippingAddress: UIImageView!
    @IBOutlet weak var lbl_SameAsShippingAddress: UILabel!
    @IBOutlet weak var btn_SameAsShippingAddress: UIButton!
    @IBOutlet weak var btn_EditAddress: UIButton!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var view_Address: UIView!
    @IBOutlet weak var view_BillingAddressSame: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(item: ShippingAddress) {
        lbl_Name.text = item.full_name
        if item.address2 == "" {
            lbl_Address.text = "\(item.address1), \n\(item.province), \(item.city) \(item.zipcode)"
        }else {
            lbl_Address.text = "\(item.address1), \(item.address2),\n\(item.province), \(item.city) \(item.zipcode)"
        }
    }
}
