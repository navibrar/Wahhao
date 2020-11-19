//  Created by Navpreet on 24/10/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit
import Kingfisher

class NotificationCell: UITableViewCell {
    //MARK:- Variable Declaration
    var dict_Localized = [String:String]()
    //MARK:- Variable Declaration
    @IBOutlet weak var img_User: UIImageView!
    @IBOutlet weak var lbl_Description: UILabel!
    @IBOutlet weak var btn_Follow: UIButton!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var constraint_FollowBtnWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.contentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        dict_Localized = GET_LOCALIZED_STRING_DICTIONARY(forClass: "UserNotification")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
     //var type: Int//1-Follow/Following,2-like,comment, mention
    
    func configureCell(item: UserNotification) {
        self.img_User.image = UIImage(named: "profile-img_1")
        if item.profile_image != "" {
            //self.img_User.kf.setImage(with: URL(string: item.profile_image)!)
            let url = URL(string: item.profile_image)
            img_User.kf.setImage(with: url, placeholder: UIImage(named:Constants.USER_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }
        self.lbl_Description.attributedText = setAttributedDescription(text: item.message)
        let nowDate = Date()
       // let endDate = Date().addingTimeInterval(12345678)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formatedStartDate = dateFormatter.date(from: item.created_at)
        let currentDate = Date()
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
        let differenceOfDate = Calendar.current.dateComponents(components, from: formatedStartDate!, to: currentDate)
        
        print (differenceOfDate)
        print(nowDate)
        print(item.created_at)

        if differenceOfDate.day == 0 {
            if differenceOfDate.minute! == 0 && differenceOfDate.hour == 0 {
                self.lbl_Time.text = " JUST NOW"
            } else if differenceOfDate.minute! >= 1 && differenceOfDate.hour == 0 {
        self.lbl_Time.text = String(describing: differenceOfDate.minute!) + " MINTUES AGO"
            } else {
            self.lbl_Time.text = String(describing: differenceOfDate.hour!) + " HOURS AGO"
            }
        } else if differenceOfDate.day == 1 {
            self.lbl_Time.text = String(describing: differenceOfDate.day!) + " DAY AGO"
        } else  if differenceOfDate.day == 2 {
            self.lbl_Time.text = String(describing: differenceOfDate.day!) + " DAYS AGO"
        } else  if differenceOfDate.day! >= 7 {
            self.lbl_Time.text = " 1 WEEK AGO"
        } else  if differenceOfDate.day! >= 14 {
            self.lbl_Time.text = " 2 WEEK AGO"
        } else  if differenceOfDate.day! >= 21 {
            self.lbl_Time.text = " 3 WEEK AGO"
        } else  if differenceOfDate.day! >= 28 {
            self.lbl_Time.text = " 4 WEEK AGO"
        } else if differenceOfDate.month! >= 1 {
            self.lbl_Time.text = String(describing: differenceOfDate.month!) + " MONTHS AGO"
        } else if differenceOfDate.year! > 0 {
            self.lbl_Time.text = String(describing: differenceOfDate.year!) + " YEAR AGO"
        }
        // self.lbl_Time.text = String(differenceOfDate.day! )
        
        if item.type == "follow_consumer"  || item.type == "follow_brand" {
            self.constraint_FollowBtnWidth.constant = 100
            self.btn_Follow.isHidden = false
            if item.is_following == true {
                self.btn_Follow.setTitle(dict_Localized["labelFollowing"], for: .normal)
                self.btn_Follow.setTitleColor(#colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1), for: .normal)
                self.btn_Follow.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                self.btn_Follow.layer.borderColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1)
            }else {
                self.btn_Follow.setTitle(dict_Localized["labelFollow"], for: .normal)
                self.btn_Follow.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                self.btn_Follow.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                self.btn_Follow.backgroundColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1)
            }
        }else {
            self.constraint_FollowBtnWidth.constant = 0
            self.btn_Follow.isHidden = true
        }
    }
    
    func setAttributedDescription(text: String) -> NSAttributedString {
        let myMutableString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont(name: self.lbl_Description.font.fontName  , size: self.lbl_Description.font.pointSize)!,NSAttributedString.Key.foregroundColor : UIColor.white])
        myMutableString.addAttributes([NSAttributedString.Key.font : UIFont(name: Constants.SEMI_BOLD_FONT, size: self.lbl_Description.font.pointSize)!,NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1)], range: getRangeOfSubString(subString: (text.components(separatedBy: " "))[0], fromString: text))
        return myMutableString
    }
    
    func getRangeOfSubString(subString: String, fromString: String) -> NSRange {
        let sampleLinkRange = fromString.range(of: subString)
        let startPos = fromString.distance(from: fromString.startIndex, to: (sampleLinkRange?.lowerBound)!)
        let endPos = fromString.distance(from: fromString.startIndex, to: (sampleLinkRange?.upperBound)!)
        let linkRange = NSMakeRange(startPos, endPos - startPos)
        return linkRange
    }
    
   
}
