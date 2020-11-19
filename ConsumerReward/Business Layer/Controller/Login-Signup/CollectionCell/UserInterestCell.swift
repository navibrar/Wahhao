//  Created by Navpreet on 23/10/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

class UserInterestCell: UICollectionViewCell {
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var view_Back: UIView!
    @IBOutlet weak var view_Selection: UIView!
    func configureCell(item: UserInterest) {
        lbl_Title.text = item.title
        lbl_Title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if item.isSelected == false {
            view_Selection.isHidden = true
            view_Back.layer.cornerRadius = 22.5
            view_Back.layer.borderWidth = 1.0
            view_Back.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            view_Back.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }else {
            view_Selection.isHidden = false
            view_Back.layer.cornerRadius = 22.5
            view_Back.layer.borderWidth = 0
            view_Back.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            view_Back.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.137254902, blue: 0.2549019608, alpha: 1)
        }
    }
}
