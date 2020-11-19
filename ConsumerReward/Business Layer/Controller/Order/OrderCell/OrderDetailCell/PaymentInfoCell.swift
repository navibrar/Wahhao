//
//  PaymentInfoCell.swift
//  ConsumerReward
//
//  Created by apple on 15/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import UIKit
import Stripe

class PaymentInfoCell: UITableViewCell {

    @IBOutlet weak var payment_Card_Img : UIImageView!
    @IBOutlet weak var payment_Method_lbl : UILabel!
    @IBOutlet weak var billing_Address_lbl : UILabel!
    @IBOutlet weak var payment_Method : UILabel!
    @IBOutlet weak var billing_Address : UILabel!
    @IBOutlet weak var shipping_Address_lbl : UILabel!
    @IBOutlet weak var shipping_Address : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(item: PaymentOrderInfo) {
        let cardBrand = STPCardValidator.brand(forNumber: item.card_number)
        let cardImage = STPImageLibrary.brandImage(for: cardBrand)
        
        payment_Card_Img.image = cardImage
        payment_Method_lbl.text = "PAYMENT METHOD".uppercased()
        shipping_Address_lbl.text = "SHIPPING ADDRESS".uppercased()
        billing_Address_lbl.text = "billing address".uppercased()
        payment_Method.text = item.card_number
        billing_Address.text = item.biling_address.uppercased()
        shipping_Address.text = item.shipping_address.uppercased()
    }

}
