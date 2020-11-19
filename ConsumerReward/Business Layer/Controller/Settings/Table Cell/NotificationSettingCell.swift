//  Created by Navpreet on 25/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.

import UIKit

class NotificationSettingCell: UITableViewCell {

    @IBOutlet weak var view_Bg: UIView!
    @IBOutlet weak var lbl_Seperator: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var switch_Setting: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configureCell(item: NotificationsSettings) {
        self.lbl_Title.text = item.title.uppercased()
        self.switch_Setting.setOn(item.is_enabled, animated: false)
    }
}
