//  Created by  Navpreet on 31/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import UIKit

class ReviewInfographicCell: UITableViewCell {

    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var img_Infographic: UIImageView!
    @IBOutlet weak var lbl_Message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(item: NSDictionary) {
        self.lbl_Title.text = item["title"] as? String
        self.img_Infographic.image = UIImage(named: item["image"] as! String)
        self.lbl_Message.text = item["message"] as? String
    }
}
