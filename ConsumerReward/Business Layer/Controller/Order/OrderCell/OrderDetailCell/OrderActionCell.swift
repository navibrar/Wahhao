//
//  OrderActionCell.swift
//  ConsumerReward
//
//  Created by apple on 15/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import UIKit

class OrderActionCell: UITableViewCell {
   @IBOutlet weak var btn_Reorder : UIButton!
    @IBOutlet weak var btn_Return : UIButton!
    @IBOutlet weak var btn_Return_height_constraint : NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        btn_Reorder.setTitle("Reorder".uppercased(), for: .normal)
        btn_Return.setTitle("start return".uppercased(), for: .normal)
        //Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
