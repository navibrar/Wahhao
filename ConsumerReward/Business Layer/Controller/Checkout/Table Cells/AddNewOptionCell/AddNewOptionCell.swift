//  Created by Navpreet on 18/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

class AddNewOptionCell: UITableViewCell {
    @IBOutlet weak var view_Back: UIView!
    @IBOutlet weak var btn_AddNewOption: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
