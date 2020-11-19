//  Created by Navpreet on 24/11/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit
import Kingfisher

class LeaderboardCell: UITableViewCell {
    @IBOutlet weak var img_User: UIImageView!
    @IBOutlet weak var lbl_Username: UILabel!
    @IBOutlet weak var lbl_Referral: UILabel!
    @IBOutlet weak var lbl_RewardValue: UILabel!
    @IBOutlet weak var lbl_Rank: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(item: Leaderboard) {
        self.img_User.image = UIImage(named:Constants.USER_DUMMY_IMAGE)
        if item.profile_image != "" {
            let url = URL(string: item.profile_image)
            self.img_User.kf.setImage(with: url, placeholder: UIImage(named:Constants.USER_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
            
        }
        lbl_Username.text = item.username
        lbl_Referral.text = "\(item.referrals)"
        
        let font:UIFont? = UIFont(name: Constants.SEMI_BOLD_FONT, size:21)
        let fontSuper:UIFont? = UIFont(name: Constants.SEMI_BOLD_FONT, size:10)
        let cashReward = "$ \(item.cash)"
        let attString_Right:NSMutableAttributedString = NSMutableAttributedString(string: cashReward, attributes: [.font:font!])
        attString_Right.setAttributes([.font:fontSuper!,.baselineOffset:6], range: NSRange(location:0,length:1))
        lbl_RewardValue.attributedText = attString_Right
        
        lbl_Rank.roundCorners([.topRight], radius: 4)
        lbl_Rank.text = "\(item.ranking)"
        
    }
}
