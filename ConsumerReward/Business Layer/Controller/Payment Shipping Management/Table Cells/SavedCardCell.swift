//  Created by Navpreet on 15/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.

import UIKit

class SavedCardCell: UITableViewCell {

    @IBOutlet weak var img_Card: UIImageView!
    @IBOutlet weak var lbl_CardNumber: UILabel!
    @IBOutlet weak var lbl_ExpDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configureCell(item: CardDetail) {
        lbl_CardNumber.text = "XXXX - \(item.last4digits)"
        img_Card.image = getCardImage(brand: item.brand)
        var cardExpiry = "EXPIRES: "
        if item.exp_month.count < 2 {
            cardExpiry += "0\(item.exp_month)"
        }else {
           cardExpiry += item.exp_month
        }
        cardExpiry += "/\(item.exp_year)"
        lbl_ExpDate.text = cardExpiry
    }
}
