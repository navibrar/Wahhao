//  Created by Navpreet on 18/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

class ShippingAddressCell: UITableViewCell {
    @IBOutlet weak var img_Check: UIImageView!
    @IBOutlet weak var lbl_AddressType: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var btn_EditAddress: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configureCell(item: ShippingAddress) {
        lbl_AddressType.text = item.address_type.uppercased()
        lbl_Name.text = item.full_name
        if item.address2 == "" {
            lbl_Address.text = "\(item.address1), \n\(item.province), \(item.city) \(item.zipcode)"
        }else {
            lbl_Address.text = "\(item.address1), \(item.address2),\n\(item.province), \(item.city) \(item.zipcode)"
        }
        if item.isSelected == false {
            img_Check.image = UIImage(named: "radio_uncheck")
        }else {
            img_Check.image = UIImage(named: "radio_check")
        }
    }
}
