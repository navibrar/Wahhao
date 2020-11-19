//
//  ConsumerFollowersCell.swift
//  ConsumerReward
//
//  Created by apple on 08/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import UIKit

class ConsumerFollowersCell: UITableViewCell {
    @IBOutlet weak var img_User: UIImageView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_Followers: UILabel!
    @IBOutlet weak var btn_Follow: UIButton!
    let userAccount = Network.currentAccount
//    var userAccount : Login? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(item: UserProfileFollowing) {
        //["Image": "profile-img-8", "Name": "chadrenshaw", "IsFollowed": "1"]
        img_User.image = UIImage(named: Constants.USER_DUMMY_IMAGE)
        
        let imageUrl = item.image
        if imageUrl != "" {
            let url = URL(string: imageUrl)
            img_User.kf.setImage(with: url)
            img_User.kf.setImage(with: url, placeholder: UIImage(named:Constants.USER_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }

        lbl_UserName.text = item.full_name
        lbl_Followers.text = item.username.lowercased()
        
        if "\(userAccount?.id ?? 0)" == item.port_accountid
        {
            btn_Follow.isHidden = true
        }
        else{
            btn_Follow.isHidden = false
            if item.isFollowed == false {
                btn_Follow.setTitle("FOLLOW", for: .normal)
                btn_Follow.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
                btn_Follow.layer.cornerRadius = 12.0
                btn_Follow.layer.borderWidth = 1.0
                btn_Follow.layer.borderColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1)
                btn_Follow.backgroundColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1)
            }else {
                btn_Follow.setTitle("FOLLOWING", for: .normal)
                btn_Follow.setTitleColor(#colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1), for: .normal)
                btn_Follow.layer.cornerRadius = 12.0
                btn_Follow.layer.borderWidth = 1.0
                btn_Follow.layer.borderColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1)
                btn_Follow.backgroundColor = UIColor.clear
            }
        }
    }
}
