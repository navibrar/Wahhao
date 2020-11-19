//  Created by Navpreet on 11/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

class ReferralUserCell: UITableViewCell {
    @IBOutlet weak var img_User: UIImageView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var btn_invite: UIButton!
    @IBOutlet weak var btn_reload: UIButton!
    @IBOutlet weak var tick_icon_image: UIImageView!
    
    let userAccount = Network.currentAccount

//    0 - Not Invited
//    1 - Invited
//    2 - Joined
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(item: ReferralTrackerData) {
        //["Image": "profile-img-8", "Name": "chadrenshaw", "IsFollowed": "1"]
        img_User.image = UIImage(named: Constants.USER_DUMMY_IMAGE)
        
        let imageUrl = item.image
        if imageUrl != "" {
            let url = URL(string: imageUrl)
            img_User.kf.setImage(with: url, placeholder: UIImage(named:Constants.USER_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
            
        }
        lbl_UserName.text = item.firstname.capitalizingFirstLetter() + " " + item.lastname.capitalizingFirstLetter()
        self.tick_icon_image.isHidden = true
        self.btn_reload.isHidden = true
        
        btn_invite.isHidden = false
        if item.status == "0" {
            btn_invite.setTitle("INVITE", for: .normal)
            btn_invite.setTitleColor(#colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1), for: .normal)
            btn_invite.layer.cornerRadius = 12.0
            btn_invite.layer.borderWidth = 1.0
            btn_invite.layer.borderColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1)
            btn_invite.backgroundColor = UIColor.clear
        }
        else if item.status == "1" {
            btn_invite.setTitle("INVITED", for: .normal)
            btn_invite.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            btn_invite.layer.cornerRadius = 12.0
            btn_invite.layer.borderWidth = 1.0
            btn_invite.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btn_invite.backgroundColor = UIColor.clear
            self.tick_icon_image.isHidden = false
            self.btn_reload.isHidden = false
        }else {
            btn_invite.setTitle("JOINED", for: .normal)
            btn_invite.setTitleColor(#colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1), for: .normal)
            btn_invite.layer.cornerRadius = 0.0
            btn_invite.layer.borderWidth = 0.0
            btn_invite.backgroundColor = UIColor.clear
        }
    }
}
