//  Created by Navpreet on 23/06/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

class UserChatCell: UITableViewCell {
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_Message: UILabel!
    @IBOutlet weak var img_User: UIImageView!
    @IBOutlet weak var img_Attachment: UIImageView!
    @IBOutlet weak var img_ChatBubble: UIImageView!
    @IBOutlet weak var constraint_ImgAttachmentHeight: NSLayoutConstraint!
    @IBOutlet weak var constraint_LblMessageHeight: NSLayoutConstraint!
    let store = GetChatDetails.sharedInstance
    @IBOutlet weak var play_btn: UIButton!
    var array_User_Detail : ChatUserInfo? = nil
     let file_icon = "doc_file"
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configureCell(item: ChatDetailinfo) {
        //["Name": "warbyparker", "Message": "Hey there, thanks so much for your order! Please send us over your prescription in this chat or the contact info for your doctor and you’ll be all set. We think these are going to look great on you", "Time": "Now", "Image": "-e-1", "Attachment": "", "IsSender": "1"]
        lbl_Time.text = item.message_created_on
        if item.message == "" {
            lbl_Message.text = ""
            constraint_LblMessageHeight.constant = 0
        }else {
            let getinfoStr = item.message
            let getNewtext =  getinfoStr.replacingOccurrences(of: "\"", with: "")
            lbl_Message.text = getNewtext
            // lbl_Message.text = item.message
        }
        if item.media  == "" {
            constraint_ImgAttachmentHeight.constant = 0
            
            img_Attachment.isHidden = true
            play_btn.isHidden = true
        }else {
            if item.media_type.caseInsensitiveCompare("video") == .orderedSame {
                let fileUrl = URL(string: item.media_thumbnail)
                constraint_ImgAttachmentHeight.constant = 60
               
                self.img_Attachment.frame.size = CGSize(width: 217, height: 60)
                self.img_Attachment.kf.setImage(with: fileUrl)
                //  img_Attachment.image = UIImage(named: item.media)
                constraint_ImgAttachmentHeight.constant = self.lbl_Message.frame.size.width
                img_Attachment.isHidden = false
                play_btn.isHidden = false
            }else if item.media_type.caseInsensitiveCompare("image") == .orderedSame {
                let fileUrl = URL(string: item.media)
                constraint_ImgAttachmentHeight.constant = 60
                
                self.img_Attachment.frame.size = CGSize(width: 217, height: 60)
                self.img_Attachment.kf.setImage(with: fileUrl)
                //  img_Attachment.image = UIImage(named: item.media)
                constraint_ImgAttachmentHeight.constant = self.lbl_Message.frame.size.width
                
                img_Attachment.isHidden = false
                play_btn.isHidden = true
            }
            else {
                constraint_ImgAttachmentHeight.constant = 60
                if item.media.contains(".png") || item.media.contains(".PNG") || item.media.contains(".jpg") || item.media.contains(".JPG") || item.media.contains(".jpeg") || item.media.contains(".JPEG")    {
                    
                    self.img_Attachment.image = UIImage(named:"image_file")
                }
                else if item.media.contains(".pdf") || item.media.contains(".PDF"){
                    self.img_Attachment.image = UIImage(named:"pdf_file")
                }
                else if item.media.contains(".doc") || item.media.contains(".docx") || item.media.contains(".rtf"){
                    self.img_Attachment.image = UIImage(named:"doc_file")
                }
                else if item.media.contains(".xls") {
                    self.img_Attachment.image = UIImage(named:"xls_file")
                }
                else {
                    self.img_Attachment.image = UIImage(named:"PlaceholderImage")
                }
                self.img_Attachment.frame.size = CGSize(width: 217, height: 60)
                // self.img_Attachment.image = UIImage(named: file_icon)
                //  img_Attachment.image = UIImage(named: item.media)
                constraint_ImgAttachmentHeight.constant = self.lbl_Message.frame.size.width
                
                img_Attachment.isHidden = false
                play_btn.isHidden = true
            }
           
        }
        
        
        // img_User.image = UIImage(named:"defautprofileImage")
        if let fileUrl1 = URL(string: item.avatar)
        {
            img_User.kf.setImage(with: fileUrl1)
        }

        let bubbleImage = UIImage(named:"02")?.resizableImage(withCapInsets: UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0), resizingMode: .stretch)
         img_ChatBubble.image = bubbleImage

        
        let dict = self.store.ChatDeatil
        if (dict?.ChatUserInfo_conversation) != nil {
            array_User_Detail = (dict?.ChatUserInfo_conversation)!
            let  getName = array_User_Detail?.username
            if (getName?.count)! > 0 {
            let nameSubstring = getName?.contains("@")
            if nameSubstring == true {
                lbl_UserName.text = getName
            }
            else {
                lbl_UserName.text = "@" + getName!
                }
        }
            else {
                 lbl_UserName.text = ""
            }
        }
    }
}
