//  Created by Navpreet on 28/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import UIKit

class AddBillingAddressCell: UITableViewCell {

    @IBOutlet weak var view_Content: UIView!
    @IBOutlet weak var lbl_BillingAddressTitle: UILabel!
    @IBOutlet weak var img_SameAsShippingAddress: UIImageView!
    @IBOutlet weak var lbl_SameAsShippingAddress: UILabel!
    @IBOutlet weak var btn_SameAsShippingAddress: UIButton!
    @IBOutlet weak var btn_AddAddress: UIButton!
    @IBOutlet weak var view_BillingAddressSame: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
