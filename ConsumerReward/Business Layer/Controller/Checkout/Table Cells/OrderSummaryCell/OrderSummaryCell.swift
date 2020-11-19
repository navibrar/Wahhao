//  Created by Navpreet on 19/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

class OrderSummaryCell: UITableViewCell {
    @IBOutlet weak var view_Back: UIView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Description: UILabel!
    @IBOutlet weak var constraint_SeperatorLeading: NSLayoutConstraint!
    @IBOutlet weak var constraint_SeperatorTrailing: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func configureCell(item: OrderSummary, indexPath: IndexPath, orderSummaryCount: Int) {
        if indexPath.row < orderSummaryCount-1 {
            self.view_Back.bottomRoundCornners(radius: 0)
            self.lbl_Title.font = UIFont(name: Constants.REGULAR_FONT, size: 12)
            self.lbl_Description.font = UIFont(name: Constants.REGULAR_FONT, size: 12)
        }else {
            self.view_Back.bottomRoundCornners(radius: 6)
            self.lbl_Title.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: 13)
            self.lbl_Description.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: 13)
        }
        lbl_Title.text = item.title.uppercased()
        lbl_Description.text = item.description.uppercased()
        
    }
}
