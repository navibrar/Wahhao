//  Created by Navpreet on 15/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.

import UIKit

class AddressCell: UITableViewCell {

    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    
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
