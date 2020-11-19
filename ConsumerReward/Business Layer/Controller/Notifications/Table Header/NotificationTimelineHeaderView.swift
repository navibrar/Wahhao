//  Created by Navpreet on 25/10/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

class NotificationTimelineHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var lbl_Title: UILabel!
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.backgroundColor = UIColor.clear
    }
    
    func configureHeader(item: String) {
        lbl_Title.text = item.uppercased()
    }
}
