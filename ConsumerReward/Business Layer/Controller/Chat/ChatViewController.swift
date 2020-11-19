//  Created by Navpreet on 23/06/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit
import AVKit
import SVProgressHUD

class ChatViewController: UIViewController {
    //MARK:- Variable Declaration
    var messageBoxPlaceholderText = String()
    
    var array_Chat_Messages = [ChatDetailinfo]()
    var array_Messages = [ChatDetailinfo]()
    var chatHistory : Chat? = nil
    var array_User_Detail : ChatUserInfo? = nil
    //MARK:- Outlet Connections
    @IBOutlet weak var scroll_Content: UIScrollView!
    @IBOutlet weak var table_Chat: UITableView!
    @IBOutlet weak var text_Message: UITextView!
    @IBOutlet weak var btn_SendMessage: UIButton!
    @IBOutlet weak var view_MessageBox: UIView!
    @IBOutlet weak var constraint_MessageBoxHeight: NSLayoutConstraint!
     @IBOutlet weak var constraint_Message_bottom: NSLayoutConstraint!
    @IBOutlet weak var constraint_Scroll_bottom: NSLayoutConstraint!
     @IBOutlet weak var constraint_Table_bottom: NSLayoutConstraint!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerLabelView: UILabel!
    var getprefilledID = Int()
    let account = Network.currentAccount
    let store = GetChatDetails.sharedInstance
    var chatInfo : Chat? = nil
    var supportChatInfo : SupportConversation? = nil
    var recentChat : RecentChat? = nil
    var selectedFileUrl = ""
    var selectedFileUrl_Doc = String()
    var chatinfo1 = [ChatUserLatestConversation]()
    var Selected_Search_array = [ChatUserLatestBrand]()
    var getstrchatid = String()
    var withWhom_Id = Int()
    var getinfoapi = String()
    var to_id = String()
     let playerViewController = AVPlayerViewController()
    @IBOutlet weak var image_back_View:UIView!
     @IBOutlet weak var image_full_View:UIImageView!
    var dict_Localized = [String:String]()
    var  str_OK = ""
    var  str_Cancel = ""
    var  str_Un_Approved = ""
    var  str_No_Message = ""
    var support_chat_logo = ""
    var support_chat_Name = ""
    var player = AVPlayer()
    let refreshControl = UIRefreshControl()
    var array_supportChat = [SupportConversation]()
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        initialSetup()
        //self.title = "帖子".uppercased()
        if #available(iOS 10, *) {
            table_Chat.refreshControl = refreshControl
        } else {
            table_Chat.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(self.getChatDetailInfoData), for: .valueChanged)
        refreshControl.tintColor = UIColor.clear
        
    }
    @objc func userMediaUpload(notification: NSNotification) {
        if let object = notification.object {
            
            
            print(object)
            self.getstrchatid = object as! String
            
            self.getChatDetailInfoData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
         self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        NOTIFICATIONCENTER.addObserver(self, selector: #selector(self.userMediaUpload), name: Notification.Name(rawValue: "Media_Upload"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        self.getRecentChat()
        
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.endEditing(true)
    }
    func setLocalizedText() {
        dict_Localized = GET_LOCALIZED_STRING_DICTIONARY(forClass: "Chat")
        str_OK = GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelOk")
        str_Cancel = GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelCancel")
        str_Un_Approved = dict_Localized["label_profile_unapproved"]!
        str_No_Message = dict_Localized["label_No_Message_Entered"]!
        messageBoxPlaceholderText = dict_Localized["label_start_Typing"]!
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if self.refreshControl.isRefreshing == true {
            self.refreshControl.endRefreshing()
        }

        NOTIFICATIONCENTER.removeObserver(self)
        self.navigationController?.isNavigationBarHidden = false
        self.view.endEditing(true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        text_Message.setContentOffset(CGPoint.zero, animated: false)
    }
    //MARK:- Keyboard Hiding
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    func prefilledData()  {
        
        let dict = self.store.ChatDeatil
        //         if let Headertext = dict?.support_chat
        //         {
        //             headerLabelView.text = Headertext
        //        }
        //        if let HeaderImage = dict?.support_chat_logo{
        //           headerImageView.image = UIImage(named:"defautprofileImage")
        //            if let fileUrl = NSURL(string: HeaderImage)
        //            {
        //                headerImageView.hnk_setImageFromURL(fileUrl as URL)
        //
        //            }
        //        }
        array_Messages.removeAll()
        array_Chat_Messages.removeAll()
        
        if (dict?.ChatDetailInfo_conversation) != nil
        {
            array_Chat_Messages = (dict?.ChatDetailInfo_conversation)!
            if array_Chat_Messages.count > 0
            {
                array_Messages = array_Chat_Messages
            }
        }
//        if (dict?.ChatUserInfo_conversation) != nil {
//            array_User_Detail = (dict?.ChatUserInfo_conversation)!
//             let  getName = array_User_Detail?.username
//            if (getName?.count)! > 0 {
//            let nameSubstring = getName?.contains("@")
//            if nameSubstring == true {
//                headerLabelView.text = getName
//            } else {
//                headerLabelView.text = "@" + getName!
//            }
//            }
//            else {
//                headerLabelView.text = ""
//            }
//            if let HeaderImage = array_User_Detail?.avatar{
//                headerImageView.image = UIImage(named:"defautprofileImage")
//                if let fileUrl = NSURL(string: HeaderImage)
//                {
//                    headerImageView.hnk_setImageFromURL(fileUrl as URL)
//                }
//            }
//        }
        table_Chat.reloadData()
       self.scrollTableViewToBottom()
    }
    //MARK:- Custom Methods
    func initialSetup()  {
      //  setLocalizedText()
        
        image_back_View.isHidden = true
        getprefilledID = (Login.loadCustomerInfoFromKeychain()?.id)!
        table_Chat.tableFooterView = UIView()
        table_Chat.showsVerticalScrollIndicator = false
        table_Chat.bounces = true
        //Comment Box
        view_MessageBox.backgroundColor = UIColor.clear
        text_Message.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        text_Message.textContainer.lineFragmentPadding = 0
        text_Message.text = messageBoxPlaceholderText
        text_Message.textColor = #colorLiteral(red: 0.7176470588, green: 0.7764705882, blue: 0.8784313725, alpha: 1)
        text_Message.backgroundColor = UIColor.clear
        text_Message.autocorrectionType = .no
        text_Message.autocapitalizationType = .none
        text_Message.spellCheckingType = .no
        text_Message.delegate = self
        text_Message.isScrollEnabled = false
        enableDisableSendMessageButton(isEnabled: false)
        
        
    }
    func enableDisableSendMessageButton(isEnabled:Bool) {
        btn_SendMessage.isUserInteractionEnabled = isEnabled
        if isEnabled == true {
            //btn_SendMessage.setTitleColor(UIColor.black, for: .normal)
        }else {
            //btn_SendMessage.setTitleColor(UIColor.lightGray, for: .normal)
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
           // print(keyboardSize.height)
            if constraint_Message_bottom.constant == 0{
                
                if UIScreen.main.nativeBounds.height == 2436 {
                 self.constraint_Message_bottom.constant = (keyboardSize.height - 30)
                  //  self.constraint_Scroll_bottom.constant =  (keyboardSize.height-60)
                  //  self.constraint_Table_bottom.constant = keyboardSize.height
                    table_Chat.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                        self.scrollTableViewToBottom()
                    }
                }else {
                    self.constraint_Message_bottom.constant = (keyboardSize.height - 3)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
           print(keyboardSize.height)
            if constraint_Message_bottom.constant != 0{
                self.constraint_Message_bottom.constant = 0
               //  self.constraint_Scroll_bottom.constant = 15
                 self.constraint_Table_bottom.constant = 0
            }
        }
    }
    func resetMessageBoxView() {
        //text_Message.text = messageBoxPlaceholderText
        text_Message.resignFirstResponder()
        text_Message.text = ""
        text_Message.textColor = UIColor.lightGray
        self.constraint_MessageBoxHeight.constant = 46
        enableDisableSendMessageButton(isEnabled: false)
    }
    @objc func scrollTableViewToBottom() {
        if array_Messages.count > 0 {
            let indexPath : IndexPath = IndexPath(row: array_Messages.count-1, section: 0)
            print(indexPath)
            self.table_Chat.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    @IBAction func cross_Image_ButtonTapped(_ sender: UIButton) {
        image_full_View.image = nil
        image_back_View.isHidden = true
    }
    func updateChat() {
    }
    @IBAction func unapproved_Tapped(_ sender: Any) {
            let message = str_Un_Approved
            self.showAlertWithMessage(message: message , title: "")
            return
    }
    func showAlertWithMessage(message:String, title: String) {
        AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: title, message: message, btnTitle: str_OK, viewController: self) { (success)
            in
        }
    }
    @IBAction func downloadImageTapped(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            if let fileUrl = URL(string: self.selectedFileUrl) {
                self.downloadFileFromUrl(fileUrl: fileUrl)
            }
        }
    }
    func downloadFileFromUrl(fileUrl: URL) {
        var isUrlData = false
        if let fileData = NSData.init(contentsOf: fileUrl) {
            isUrlData = true
            let activityViewController:UIActivityViewController = UIActivityViewController(activityItems:  [fileData], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [.postToVimeo, .postToWeibo, .postToFlickr, .postToTwitter, .airDrop,.assignToContact]
            self.present(activityViewController, animated: true, completion: nil)
            //Hide Loader
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                SVProgressHUD.dismiss()
            }
        }
        if isUrlData == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                SVProgressHUD.dismiss()
            }
        }
    }
    @IBAction func sendMessageTapped(_ sender: Any) {
        if text_Message.text.caseInsensitiveCompare(messageBoxPlaceholderText) == .orderedSame {
            let alert = UIAlertController(title: nil, message: str_No_Message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: str_OK, style: .cancel
                , handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        //        let dict : NSMutableDictionary = ["Name": "pidan", "Message": text_Message.text, "Time": "Just Now", "Image": "Pidan", "Attachment": "", "IsSender": "0","isVideo":false]
        //        array_Messages.append(dict)
       // table_Chat.reloadData()
        self.scrollTableViewToBottom()
        self.callSendMsg()
        resetMessageBoxView()
    }
    @IBAction func viewMembersTapped(_ sender: Any) {
        /*let isTribe = chatHistory?.isTribe ?? false
         let isGroup = chatHistory?.isGroup ?? false
         if isTribe || isGroup {
         self.performSegue(withIdentifier: "ChatGroupMembersVC", sender: self)
         }
         else{
         moveToBrandProfile()
         }*/
    }
     @objc func VideoPlayFromCell(sender: UIButton!) {
        
//        let geturl = array_Messages[btnsendtag.tag].media
//        let fileUrl = URL(string: geturl)
//        let player = AVPlayer(url: videoMediaUrl!)
//        let playerController = AVPlayerViewController()
//        playerController.player = player
//        present(playerController, animated: true) {
//            player.play()
//        }
        
         let btnsendtag: UIButton = sender
        selectedFileUrl = array_Messages[btnsendtag.tag].media
        let actionSheet = UIAlertController(title: dict_Localized["label_Select_Option_Video"], message: nil, preferredStyle: .actionSheet)
        self.present(actionSheet, animated: true, completion: nil)
        let attributedString = NSAttributedString(string: dict_Localized["label_Select_Option_Video"]!, attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor : UIColor.black
            ])
        actionSheet.setValue(attributedString, forKey: "attributedTitle")
        //1
        let PlayAction = UIAlertAction(title: dict_Localized["label_Play"], style: .default) { (action) in
            self.play_video()
        }
        actionSheet.addAction(PlayAction)
        //2
        let DownloadAction = UIAlertAction(title: dict_Localized["label_Download"], style: .default) { (action) in
            self.downloadVideoTapped()
        }
        actionSheet.addAction(DownloadAction)
        // 3
        let cancelAction = UIAlertAction(title: str_Cancel, style: .cancel) { (action) in
//            let btn = UIButton()
//            self.close_ButtonTapped(btn)
        }
        actionSheet.addAction(cancelAction)
       
    }
    @IBAction func close_ButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func play_video() {
        
      
         let fileUrl = URL(string: selectedFileUrl)
        let player = AVPlayer(url: fileUrl!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
        
    }
    func downloadVideoTapped() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if let fileUrl = URL(string: self.selectedFileUrl) {
                self.downloadFileFromUrl(fileUrl: fileUrl)
            }
        }
    }
    @IBAction func addAttachmentButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SelectionOfAttacthmentsViewController", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "SelectionOfAttacthmentsViewController" {
                    if let nextView = segue.destination as? SelectionOfAttacthmentsViewController {
                       
                        nextView.to_id = to_id
                        nextView.withWhom_Id = withWhom_Id
                        nextView.getstrchatid = getstrchatid
                        nextView.getprefilledID = getprefilledID
                    }
                }
        if segue.identifier == "opendoc"  {
            if let nextView = segue.destination as? SelectionOfAttacthmentsViewController {
                nextView.getfile_openUrl = selectedFileUrl_Doc
            }
        }
    }
}

//MARK:- UITextViewDelegate
extension ChatViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == messageBoxPlaceholderText {
            self.constraint_MessageBoxHeight.constant = 46
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" || textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            textView.text = messageBoxPlaceholderText
            textView.textColor = #colorLiteral(red: 0.7176470588, green: 0.7764705882, blue: 0.8784313725, alpha: 1)
        }else {
            textView.textColor = #colorLiteral(red: 0.7176470588, green: 0.7764705882, blue: 0.8784313725, alpha: 1)
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if self.constraint_MessageBoxHeight.constant < 150 {
            let fixedWidth = textView.frame.size.width
            textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            var newFrame = textView.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height < 36 ? 36 : newSize.height)
            self.constraint_MessageBoxHeight.constant = newFrame.size.height + 10
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true && text == "\n" {
            textView.text = messageBoxPlaceholderText
            textView.resignFirstResponder()
        }else {
            enableDisableSendMessageButton(isEnabled: !(newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty))
        }
       // return newText.count <= 200
        return true
    }
}

//MARK:- UITableViewDelegate & UITableViewDataSource

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_Messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var superCell = UITableViewCell()
        if indexPath.row < array_Messages.count {
            if array_Messages[indexPath.row].from_id == getprefilledID {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderChatCell", for: indexPath) as! SenderChatCell
                cell.configureCell(item:array_Messages[indexPath.row])
                cell.play_btn.tag = indexPath.row
                cell.play_btn.addTarget(self, action: #selector(VideoPlayFromCell), for: .touchUpInside)
                superCell = cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserChatCell", for: indexPath) as! UserChatCell
                cell.configureCell(item: array_Messages[indexPath.row])
                cell.play_btn.tag = indexPath.row
                cell.play_btn.addTarget(self, action: #selector(VideoPlayFromCell), for: .touchUpInside)
                superCell = cell
            }
        }
      //  else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TypingCell", for: indexPath)
//            superCell = cell
//        }
        superCell.selectionStyle = .none
        return superCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var getChatmediaType = String()
        getChatmediaType = array_Messages[indexPath.row].media_type
         if getChatmediaType == "" {
            var getChatmediaStr = String()
            getChatmediaStr = array_Messages[indexPath.row].message
            
            let labelheight = getChatmediaStr.labelHeight(withConstrainedWidth: 200, font: UIFont(name: "Montserrat-Regular", size: 11.0)!)
            return CGFloat(Int(labelheight) + 70)
        }
         else if  array_Messages[indexPath.row].media_type == "video" || array_Messages[indexPath.row].media_type == "image"{
            var getChatmediaStr = String()
            getChatmediaStr = array_Messages[indexPath.row].message

            let labelheight = getChatmediaStr.labelHeight(withConstrainedWidth: 200, font: UIFont(name: "Montserrat-Regular", size: 11.0)!)
             return CGFloat(Int(labelheight * 2) + 70 + 160)
        }
        return 200.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFileUrl = ""
        var getChatmediaType = String()
        getChatmediaType = array_Messages[indexPath.row].media_type
        if getChatmediaType == "video" {
            let geturl = array_Messages[indexPath.row].media
            let fileUrl = URL(string: geturl)
            let player = AVPlayer(url: fileUrl!)
            let playerController = AVPlayerViewController()
            playerController.player = player
            present(playerController, animated: true) {
                player.play()
            }
        }
        else if getChatmediaType == "image" {
            self.view.endEditing(true)
            image_back_View.isHidden = false
            self.view.bringSubviewToFront(image_back_View)
            self.image_full_View.image = UIImage(named: "PlaceholderImage")
            selectedFileUrl = array_Messages[indexPath.row].media
            let fileUrl = URL(string: selectedFileUrl)
            self.image_full_View.kf.setImage(with: fileUrl)
        }
        else {
            selectedFileUrl_Doc = array_Messages[indexPath.row].media
            self.performSegue(withIdentifier: "opendoc", sender: self)
        }
    }
    
}
extension ChatViewController{
    @objc func getChatDetailInfoData()
    {
       if let fileUrl = URL(string: support_chat_logo)
        {
            headerImageView.kf.setImage(with: fileUrl)
            headerLabelView.text = support_chat_Name
        }
       else {
            if let fileUrl = URL(string: "https://uat-hubcn.wahhao.com//public/assets/images/wahhao-avatar.jpg")
            {
                // cell.productImage.kf.setImage(with: url)
                headerImageView.kf.setImage(with: fileUrl)
            }
            headerLabelView.text = "@wahhaosupport"
        }
        
        
        if supportChatInfo != nil
        {
            getstrchatid   = (supportChatInfo?.chat_id)!
            getinfoapi = "Yes"
        }
        else {
        if getstrchatid.count == 0 {
            getinfoapi = "No"
        }
        else {
            getinfoapi = "Yes"
        }
        }
        
        
        if  getinfoapi == "Yes" && getstrchatid.count > 0 &&  getstrchatid != "0"{
            store.callChatDetailData(value: getstrchatid, showLoader: true, outhType: "",completionBlockSuccess: { (success) -> Void in
                //Success block
                print("success")
                if self.refreshControl.isRefreshing == true {
                    self.refreshControl.endRefreshing()
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                    self.prefilledData()
                    
                }
                
            }) { (failure) -> Void in
                // your failure handle
                if self.refreshControl.isRefreshing == true {
                    self.refreshControl.endRefreshing()
                }
                if let value = failure["message"] {
                    AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: (value as? String)!, btnTitle: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelOk"), viewController: self, completionHandler: { (success) in
                    })
                } else{
                    AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:  GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelSomethingWrong"), btnTitle: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelOk"), viewController: self, completionHandler: { (success) in
                    })
                }
            }
        }
    }
    
    
    func callSendMsg() {
//        if  getinfoapi == "Yes" {
//            to_id = (array_User_Detail?.withwhom_id)!
//            withWhom_Id = (array_User_Detail?.withwhom_group)!
//        }
//        else {
//            getstrchatid = ""
//
//                to_id = (recentChat?.support_chat_userID)!
//                let whithWhomInt = (recentChat?.support_withwhom_group)! ? 1 : 0
//
//                withWhom_Id = whithWhomInt
//        }
        let gettextmsg: String = text_Message.text ?? ""
        let chat_Media = [NSDictionary]()
        let parameters:  [String: Any] = [
            "chat_id": getstrchatid,
            "from_id": getprefilledID,
            "to_id": to_id,
            "message": gettextmsg,
            "resource": chat_Media,
            "withwhom_group": withWhom_Id,
            ]
        
        store.callWebserviceforsendMsg(parameters: parameters, outhType: "", isShowLoader: true,showLoader: true, completionBlockSuccess: { (success) -> Void in
            
            print("Success")
            
            if let response = success["response"] as? NSDictionary {
                if let chat_id_dict = response["message"] as? NSDictionary {
                    if  let value = chat_id_dict["chat_id"] as? Int {
                        self.getstrchatid = String(value)
                    }else if  let value = chat_id_dict["chat_id"] as? NSNumber {
                        self.getstrchatid = value.stringValue
                    }else {
                        self.getstrchatid = chat_id_dict["chat_id"] as? String ?? ""
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        self.getChatDetailInfoData()
                    }
                }
            }
            
            // self.navigationController?.popViewController(animated: true)
            
            
        }) { (failure) -> Void in
            // your failure handle
            if let value = failure["message"] {
                AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: (value as? String)!, btnTitle: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelOk"), viewController: self, completionHandler: { (success) in
                })
            } else{
                AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelSomethingWrong"), btnTitle: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelOk"), viewController: self, completionHandler: { (success) in
                })
            }
        }
    }
    
    
    @objc func getRecentChat()
    {
       let store1 = GetRecentChat.sharedInstance
        store1.callRecentChatData(completionBlockSuccess: { (success) -> Void in
            //Success block
            print(success)
            if self.refreshControl.isRefreshing == true {
                self.refreshControl.endRefreshing()
            }
            if let response = success["response"] as? NSDictionary {
                if let to_id_get = response["support_chat_userID"] as? Int {
                    self.to_id = String(to_id_get)
                }
                if let to_id_withWhom_Id = response["business_withwhom_group"] as? Int {
                    self.withWhom_Id = to_id_withWhom_Id
                }
                if let support_chat_logo_Info = response["support_chat_logo"] as? String {
                    self.support_chat_logo = support_chat_logo_Info
                    let fileUrl = URL(string: self.support_chat_logo)
                    self.headerImageView.kf.setImage(with:fileUrl)
                    
                }
                if let support_chat_info = response["support_chat"] as? String {
                    self.support_chat_Name =  support_chat_info
                    self.headerLabelView.text = self.support_chat_Name
                }
            }
            
            
            
//            let  getstrchatid_dict :  [Chat]? = nil
//            if getstrchatid_dict!.count > 0 {
//                for dict in getstrchatid_dict! {
//                self.getstrchatid = dict.chat_id
//                print("get id",self.getstrchatid)
//            }
//            }
            
           // getstrchatid
            //let dict = self.store.brandprofileMasterdata
            //self.profileInfo = dict?.profileDeatils
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                
                var array_ChatHistory = [Chat]()
                let store_Chat = GetRecentChat.sharedInstance
                if let latestConversation = store_Chat.recentChat {
                    for chat in (latestConversation.latest_conversation) {
                        array_ChatHistory.append(chat)
                    }
                }
                
                for chat in array_ChatHistory {
                    self.getstrchatid = chat.chat_id
                    print("get id for fetch chat",self.getstrchatid)
                }
                
                if let latestConversation = store1.recentChat {
                    let filteredArray = latestConversation.support_conversation
                    for chat in filteredArray {
                        self.array_supportChat.append(chat)
                    }
                }
                if self.array_supportChat.count > 0
                {
                    self.supportChatInfo = self.array_supportChat[0]
                }
                self.getChatDetailInfoData()
                
                
            }
            print("success")
            
        }) { (failure) -> Void in
            // your failure handle
            if self.refreshControl.isRefreshing == true {
                self.refreshControl.endRefreshing()
            }
            if let value = failure["message"] {
                AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: (value as? String)!, btnTitle: self.str_OK, viewController: self, completionHandler: { (success) in
                })
            } else{
                AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:  GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelSomethingWrong"), btnTitle: self.str_OK, viewController: self, completionHandler: { (success) in
                })
            }
        }
    }
    
    
}
