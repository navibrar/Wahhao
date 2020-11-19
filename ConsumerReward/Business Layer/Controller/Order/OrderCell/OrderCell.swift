//
//  OrderCell.swift
//  ConsumerReward
//
//  Created by apple on 14/12/18.
//  Copyright © 2018 Sanjeev Thapar. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
     @IBOutlet weak var orderProduct_Img : UIImageView!
     @IBOutlet weak var orderProduct_Name : UILabel!
     @IBOutlet weak var orderProduct_Soldinfo : UILabel!
     @IBOutlet weak var orderProduct_Status : UILabel!
     @IBOutlet weak var orderProduct_DelioveryExpected : UILabel!
     @IBOutlet weak var orderProduct_DeliveryDate : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
