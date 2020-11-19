//
//  OrderRatingCell.swift
//  ConsumerReward
//
//  Created by apple on 15/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import UIKit
import Cosmos

class OrderRatingCell: UITableViewCell {

    @IBOutlet weak var video_Review_lbl : UILabel!
    @IBOutlet weak var cashback_lbl : UILabel!
    @IBOutlet weak var star_View : CosmosView!
    @IBOutlet weak var Video_Review_Btn : UIButton!
    @IBOutlet weak var starViewConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        star_View.settings.fillMode = .precise
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(item: String) {
        
        if item != "0.0000" {
        star_View.rating = Double(item)!
        } else {
            star_View.rating = 0
            starViewConstraint.constant = 8
        }
        cashback_lbl.text = "GET 2% CASHBACK"
        video_Review_lbl.text = "ADD VIDEO REVIEW"
    }

}
