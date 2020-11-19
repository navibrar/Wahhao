//  Created by Navpreet on 18/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

class PaymentMethodCell: UITableViewCell {
    @IBOutlet weak var img_Card: UIImageView!
    @IBOutlet weak var img_Check: UIImageView!
    @IBOutlet weak var lbl_CardNumber: UILabel!
    @IBOutlet weak var constraint_SeperatorTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraint_SeperatorLeading: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func configureCell(item: CardDetail) {
        lbl_CardNumber.text = item.last4digits
        img_Card.image = getCardImage(brand: item.brand)
        if item.isSelected == false {
            img_Check.image = UIImage(named: "radio_uncheck")
        }else {
            img_Check.image = UIImage(named: "radio_check")
        }
    }
}
