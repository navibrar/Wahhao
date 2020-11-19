//
//  OrderSummaryTotalCell.swift
//  ConsumerReward
//
//  Created by apple on 15/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import UIKit

class OrderSummaryTotalCell: UITableViewCell {
    @IBOutlet weak var total_Item_lbl : UILabel!
    @IBOutlet weak var total_Item : UILabel!
    @IBOutlet weak var item_Sub_Total_lbl : UILabel!
    @IBOutlet weak var item_Sub_Total : UILabel!
    @IBOutlet weak var shopping_Charge_lbl : UILabel!
    @IBOutlet weak var shopping_Charge : UILabel!
    @IBOutlet weak var grand_total_lbl : UILabel!
    @IBOutlet weak var grand_total : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(item: OrderDetail) {
        total_Item_lbl.text =  "Total Items".uppercased()
        item_Sub_Total_lbl.text = "Item(s) Subtotal".uppercased()
        shopping_Charge_lbl.text = "Shipping Charges".uppercased()
        grand_total_lbl.text = "Grand Total".uppercased()
        total_Item.text = item.order_total_items
        
        var subTotalPrice: Float = 0
        subTotalPrice = (item.order_total as NSString).floatValue
        let subTotalPriceStr = formatPriceToTwoDecimalPlace(amount: subTotalPrice)
        item_Sub_Total.text = subTotalPriceStr
        
        if item.order_shipping_charge == "0"
        {
            shopping_Charge.text = "Free"
        }
        else
        {
            var totalPrice: Float = 0
            totalPrice = (item.order_shipping_charge as NSString).floatValue
            let totalPriceStr = formatPriceToTwoDecimalPlace(amount: totalPrice)
            shopping_Charge.text = totalPriceStr
        }
        var totalPrice: Float = 0
        totalPrice = (item.order_total_price as NSString).floatValue
        let totalPriceStr = formatPriceToTwoDecimalPlace(amount: totalPrice)
        grand_total.text = totalPriceStr
    }
}
