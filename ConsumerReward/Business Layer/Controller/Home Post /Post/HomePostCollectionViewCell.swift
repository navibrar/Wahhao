//
//  HomePostCollectionViewCell.swift
//  Consumer
//
//  Created by apple on 4/17/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit
import QuartzCore
import CoreMedia

class HomePostCollectionViewCell: UICollectionViewCell {
    var avPlayer = AVPlayer()
    var avPlayerLayer = AVPlayerLayer()
    var observer:Any?

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var shadowImageView: UIImageView!
    @IBOutlet weak var itemInfoBottomView: UIView!
    @IBOutlet weak var itemInfoTopView: UIView!
    @IBOutlet weak var likesCountButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeTappedFullButton: UIButton!
    
    @IBOutlet weak var viewCountButton: UIButton!
    @IBOutlet weak var shareImageButton: UIButton!
    @IBOutlet weak var shareTextButton: UIButton!
    @IBOutlet weak var buyNowButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var viewsBackView: UIView!
    
    @IBOutlet weak var play_icon_imageview: UIImageView!
    @IBOutlet weak var like_icon_imageview: UIImageView!
    @IBOutlet weak var img_brand: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var productBoughtLbl: UILabel!
    @IBOutlet weak var cartCountLabel: UILabel!
    @IBOutlet weak var tapDetectionView: UIView!
    
    @IBOutlet weak var productDetailButton: UIButton!
    @IBOutlet weak var share_Earn_Button: UIButton!
    @IBOutlet weak var lbl_UserCashoutBalance: UILabel!
    @IBOutlet weak var view_CartItemCount: UIView!
    @IBOutlet weak var view_RewardBadge: UIView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }


}
