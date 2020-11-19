//
//  UserMenuTableViewCell.swift
//  Consumer
//
//  Created by apple on 4/25/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import UIKit

class UserMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var lbl_NotificationCount: UILabel!
    @IBOutlet weak var constraint_NotificationCountLlblTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraint_NotificationLblWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setValueForCell(name : String ,itemImage:String) {
        iconImageView.image = UIImage(named:itemImage)
        nameLabel.text = name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
