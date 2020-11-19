//
//  ConsumerLikeCell.swift
//  ConsumerReward
//
//  Created by apple on 08/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import UIKit

class ConsumerLikeCell: UICollectionViewCell {
    
    @IBOutlet weak var img_Post: UIImageView!
    @IBOutlet weak var lbl_Like: UILabel!
    @IBOutlet weak var constraint_ImageHeight: NSLayoutConstraint!
    
//    func configureCell(dict : NSDictionary) {
//        img_Post.image = UIImage.init(named: dict["Image"]as! String)
//        lbl_Like.text = (dict["Like"] as! String)
//    }
    
    func configureCell(dict : HomePost) {
        let imageName = dict.imageURL
        img_Post.image = UIImage(named: Constants.PRODUCT_DUMMY_IMAGE)
        if imageName != ""
        {
           // self.img_Post.contentMode = .scaleAspectFit
            self.img_Post.contentMode = .scaleAspectFill
                  let url = URL(string: imageName)
//                let resolution = self.resolutionForimage(url: imageName)
//                if resolution.height > resolution.width {
//                    self.img_Post.contentMode = .scaleAspectFit
//                } else {
//                    self.img_Post.contentMode = .scaleAspectFill
//                }
          
                self.img_Post.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
           
        }
        lbl_Like.text = " " + dict.likesCount
   }
    
}
