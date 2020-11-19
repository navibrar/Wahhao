//
//  ReviewsCollectionViewCell.swift
//  Consumer
//
//  Created by apple on 19/12/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import UIKit
import Cosmos

class ReviewsCollectionViewCell: UICollectionViewCell {
    // MARK:=========OUTLET DECLARATION==========
    
    @IBOutlet weak var item_image: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    func configureCell(dict : HomePost) {
        item_image.image = UIImage(named: Constants.PRODUCT_DUMMY_IMAGE)
        if dict.imageURL != ""
        {
            let url = URL(string: dict.imageURL)
//            item_image.kf.setImage(with: url)
            item_image.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }

        lbl_name.text = dict.consumer_username.lowercased()
        lbl_date.text = dict.created_at.uppercased()
        ratingView.rating = Double((dict.rating as NSString).floatValue)
        ratingView.settings.fillMode = .precise
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-mm-dd HH:mm:s"
        let order_date = inputFormatter.date(from: dict.created_at)
//        let currentDate = Date()
        var resultString = ""
        
//        let same_day = Calendar.current.isDate(currentDate, inSameDayAs:order_date!)
//
//        if same_day
//        {
//            inputFormatter.dateFormat = "HH:mm"
//            resultString = inputFormatter.string(from: order_date!)
//            resultString = "Today at " + resultString
//        }
//        else{
//        inputFormatter.dateFormat = "MMM dd,yyyy"
//        resultString = inputFormatter.string(from: order_date!)
//    }
        if order_date != nil
        {
            inputFormatter.dateFormat = "MMM dd,yyyy"
            resultString = inputFormatter.string(from: order_date!)
            lbl_date.text = resultString.uppercased()
        }
    }
}
