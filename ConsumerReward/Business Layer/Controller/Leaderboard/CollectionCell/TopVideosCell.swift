
//  Created by Navpreet on 26/11/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

class TopVideosCell: UICollectionViewCell {
    
    @IBOutlet weak var img_Post: UIImageView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Rank: UILabel!
    @IBOutlet weak var constraint_ImageHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(cellWidth: CGFloat, item: HomePost, isCashbackPost: Bool) {
        constraint_ImageHeight.constant = cellWidth
        if isCashbackPost == true {
            let price = Float(item.totalCashback)
            self.lbl_Title.text = formatPriceToTwoDecimalPlace(amount: price!)
        }else {
            self.lbl_Title.text = "\(item.likesCount) LIKED"
        }
        lbl_Rank.roundCorners([.topRight], radius: 6)
        lbl_Rank.text = "\(item.postRanking)"
        img_Post.image = UIImage(named: Constants.PRODUCT_DUMMY_IMAGE)
        let postImageUrl = item.imageURL
        if postImageUrl != "" {
            let url = URL(string: postImageUrl)
            img_Post.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
}
