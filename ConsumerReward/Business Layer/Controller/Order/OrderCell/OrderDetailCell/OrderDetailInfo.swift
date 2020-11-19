//
//  OrderDetailInfo.swift
//  ConsumerReward
//
//  Created by apple on 14/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import UIKit

class OrderDetailInfo: UITableViewCell {
    @IBOutlet weak var order_id : UILabel!
    @IBOutlet weak var order_Date : UILabel!
    @IBOutlet weak var order_Total : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(item: OrderDetail) {
        order_id.text = item.order_prefix + item.order_id
        
        if (item.order_date.count) > 0 {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-mm-dd HH:mm:s"
            let order_date = inputFormatter.date(from: item.order_date)
            let currentDate = Date()
            var resultString = ""
            
            let same_day = Calendar.current.isDate(currentDate, inSameDayAs:order_date!)

            if same_day
            {
                inputFormatter.dateFormat = "HH:mm"
                resultString = inputFormatter.string(from: order_date!)
                resultString = "Today at " + resultString
            }
            else{
                inputFormatter.dateFormat = "MMM dd,yyyy"
                resultString = inputFormatter.string(from: order_date!)
           }
            order_Date.text = resultString
        } else {
            order_Date.text = item.order_date
        }
        var staticItemStr = " Items"
        if item.order_total_items == "1"
        {
            staticItemStr = " Item"
        }
        var totalPrice: Float = 0
        totalPrice = (item.order_total as NSString).floatValue
        let totalPriceStr = formatPriceToTwoDecimalPlace(amount: totalPrice)
        order_Total.text = totalPriceStr + " (" + item.order_total_items + staticItemStr + ")"
    }
}
