//  Created by Navpreet on 15/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.

import UIKit

class AddressHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var lbl_AddressTitle: UILabel!
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.backgroundView?.backgroundColor = .clear
    }
    
    func configureHeader(title: String) {
        lbl_AddressTitle.text = title
    }
    
}
