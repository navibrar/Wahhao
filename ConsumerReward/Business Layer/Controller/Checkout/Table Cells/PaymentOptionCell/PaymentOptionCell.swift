//  Created by Navpreet on 20/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

class PaymentOptionCell: UITableViewCell {
    @IBOutlet weak var img_Check: UIImageView!
    @IBOutlet weak var lbl_Title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(item: PaymentOption) {
        lbl_Title.text = item.title.uppercased()
        if item.isSelected == false {
            img_Check.image = UIImage(named: "radio_uncheck")
        }else {
            img_Check.image = UIImage(named: "radio_check")
        }
    }
}
