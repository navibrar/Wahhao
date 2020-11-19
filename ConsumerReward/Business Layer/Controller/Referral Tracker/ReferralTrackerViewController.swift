//
//  ReferralTrackerViewController.swift
//  ConsumerReward
//
//  Created by apple on 1/16/19.
//  Copyright © 2019 Navpreet. All rights reserved.
//

import UIKit
import Contacts
import MessageUI
import Messages

class ReferralTrackerViewController: UIViewController {
    //MARK:- Variable Declaration
    var referralUsersList = [ReferralTrackerData]()
    var array_Filtered = [ReferralTrackerData]()

    var fetchedUsersList = false
    let store = ReferralTrackerServices.sharedInstance
    var contacts = [CNContact]()
    var offset = UIOffset()
    var selectedIndex = 0
    var refreshControl = UIRefreshControl()
    var img_ReferralCode = UIImage()

    //MARK:- Outlet Connections
    @IBOutlet weak var referralUsersTableView: UITableView!
    @IBOutlet weak var search_bar: UISearchBar!

    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        fetchPhoneContactList()
        fetchUsersListFromAPI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    //MARK:- Custom Methods
    func initialSetup() {
        referralUsersTableView.tableFooterView = UIView()
        referralUsersTableView.showsVerticalScrollIndicator = false
        
        // PUL TO REFRESH
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        referralUsersTableView.addSubview(refreshControl) // not required when using UITableViewController

        // search Bar Setup
        searchBarSetup()
    }
    
    @objc private func refresh(_ sender: Any) {
        // Code to refresh table view
        fetchUsersListFromAPI()
        self.refreshControl.endRefreshing()
    }

    //MARK:- Custom Methods
    func searchBarSetup() {
        search_bar.isHidden = true
        search_bar.backgroundImage = UIImage()
        search_bar.placeholder = "Search"
        search_bar.isTranslucent = true
        search_bar.searchBarStyle = .default
        search_bar.delegate = self
        // SearchBar text
        let textFieldInsideUISearchBar = search_bar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = #colorLiteral(red: 0.7176470588, green: 0.7764705882, blue: 0.8784313725, alpha: 1)
        textFieldInsideUISearchBar?.font = UIFont(name: Constants.REGULAR_FONT, size: 15)
        textFieldInsideUISearchBar?.textAlignment = .left
        textFieldInsideUISearchBar?.backgroundColor = UIColor.clear
        // SearchBar placeholder
        let textFieldInsideUISearchBarLabel = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideUISearchBarLabel?.textColor = #colorLiteral(red: 0.7176470588, green: 0.7764705882, blue: 0.8784313725, alpha: 1)
        textFieldInsideUISearchBarLabel?.textAlignment = .center
        
        offset = UIOffset(horizontal: 120, vertical: 0)
        search_bar.setPositionAdjustment(offset, for: .search)
        
        search_bar.backgroundColor = UIColor.clear
        search_bar.layer.borderColor = UIColor.white.cgColor
        search_bar.layer.borderWidth = 1
        search_bar.layer.cornerRadius = 14
        search_bar.clipsToBounds = true
        referralUsersTableView.tableFooterView = UIView()
        referralUsersTableView.showsVerticalScrollIndicator = false
    }
    func fetchPhoneContactList() {
        let contactStore = CNContactStore()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactPhoneNumbersKey,
                    CNContactEmailAddressesKey,
                    CNContactThumbnailImageDataKey] as [Any]

        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        
        do {
            try contactStore.enumerateContacts(with: request) { (contact, stop) in
                self.contacts.append(contact)
            }
        } catch {
            print(error.localizedDescription)
        }
//        print(contacts)
        var contactValue : [NSDictionary] = []
        contactValue.removeAll()
        for cont in contacts
        {
            var alreadyAdded = false
            let firstname = cont.givenName
            let lastname = cont.familyName
            let emailAddresses = cont.emailAddresses
            var mobileArray : [NSDictionary] = []
            var emailValue = ""

            for email in emailAddresses
            {
                emailValue = email.value as String
            }
            
            let mobileNums = cont.phoneNumbers
            for number in mobileNums
            {
                let mobile_type = number.label
                let mobile_no = number.value.stringValue
                let mobile_no_str : String = self.removeSpecialCharsFromString(mobile_no)
                let filtered = self.referralUsersList.filter({$0.mobile_no == mobile_no_str})
                if filtered.count == 0 {
                    alreadyAdded = false
                    let mobileDict  =   ["mobile_no": mobile_no_str,
                                         "mobile_type": mobile_type as Any] as NSDictionary
                    mobileArray.append(mobileDict)
                }
                else{
                    alreadyAdded = true
                }
            }
            
            let dict : [String:Any] =  [
                    "firstname": firstname,
                    "lastname": lastname,
                    "mobile": mobileArray,
                    "email": emailValue
                ]
            if !alreadyAdded
            {
                contactValue.append(dict as NSDictionary)
            }
        }
        if contactValue.count > 0
        {
            let parameters: [String:Any] = [
                "contacts": contactValue
            ]
            self.callSaveContacts(parameters: parameters)
        }
    }
    
    func removeSpecialCharsFromString(_ str: String) -> String {
        struct Constants {
            static let validChars = Set("1234567890".characters)
        }
        return String(str.characters.filter { Constants.validChars.contains($0) })
    }

    //MARK:- Button Methods
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.search_bar.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        self.search_bar.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    func setupUI() {
        self.referralUsersTableView.reloadData()
        if !self.fetchedUsersList
        {
            self.fetchPhoneContactList()
            self.fetchedUsersList = true
        }
        if self.referralUsersList.count > 0
        {
            self.search_bar.isHidden = false
        }
        else{
            self.search_bar.isHidden = true
        }
        if self.store.referralDetails?.referal_code_image != "" {
            DispatchQueue.global(qos: .background).async {
                do {
                    let url = URL(string: (self.store.referralDetails?.referal_code_image)!)
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        self.img_ReferralCode = UIImage(data: data!)!
                    }
                }
            }
        }
    }
}

//MARK:- UITableViewDelegate & UITableViewDataSource
extension ReferralTrackerViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_Filtered.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var superCell = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReferralUserCell", for: indexPath) as! ReferralUserCell
        cell.configureCell(item: array_Filtered[indexPath.row])
        cell.btn_invite.tag = indexPath.row
        cell.btn_invite.addTarget(self, action: #selector(self.contactInviteTapped(sender:)), for: .touchUpInside)
        
        cell.btn_reload.tag = indexPath.row
        cell.btn_reload.addTarget(self, action: #selector(self.reInviteTapped(sender:)), for: .touchUpInside)

        superCell = cell
        superCell.selectionStyle = .none
        return superCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    //MARK:- TableView Custom Methods
    @objc func contactInviteTapped(sender:UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.referralUsersTableView)
        if let indexPath = self.referralUsersTableView.indexPathForRow(at: buttonPosition) {
            print(indexPath.row)
            let value = array_Filtered[indexPath.row]
            if value.status == "0" {
                selectedIndex = indexPath.row
                self.sendText()
            }
        }
    }
    
    @objc func reInviteTapped(sender:UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.referralUsersTableView)
        if let indexPath = self.referralUsersTableView.indexPathForRow(at: buttonPosition) {
            selectedIndex = indexPath.row
            self.sendText()
        }
    }
}

//MARK:- UISearchBarDelegate
extension ReferralTrackerViewController : UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let noOffset = UIOffset(horizontal: 0, vertical: 0)
        searchBar.setPositionAdjustment(noOffset, for: .search)
        searchBar.resignFirstResponder()
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        //searchBar.setPositionAdjustment(offset, for: .search)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            array_Filtered.removeAll()
            array_Filtered = self.referralUsersList
            referralUsersTableView.reloadData()
        }else {
            let filtered = referralUsersList.filter { (($0.firstname).lowercased()).contains(searchText.lowercased())  || (($0.lastname).lowercased()).contains(searchText.lowercased()) }
            array_Filtered = filtered
            referralUsersTableView.reloadData()
        }
    }
    
    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.search_bar.text = ""
        search_bar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: SHARE CODE SOCIAL CALLS
extension ReferralTrackerViewController : MFMessageComposeViewControllerDelegate {
    func sendText() {
        if (MFMessageComposeViewController.canSendText()) {
            UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: UIColor.color(.appThemeColor)), for: .default)
            let controller = MFMessageComposeViewController()
            controller.messageComposeDelegate = self
            let value = self.array_Filtered[selectedIndex]
            controller.body = (self.store.referralDetails?.text_msg)! + "\n" + (self.store.referralDetails?.url)!
            controller.recipients = [value.mobile_no]
//            let dataImage =  UIImageJPEGRepresentation(img_ReferralCode, 1)
            let imageData: NSData = img_ReferralCode.pngData()! as NSData

            guard imageData != nil else {
                print("Image is nil return")
                return}

            
            controller.addAttachmentData(
                imageData as Data,
                typeIdentifier: "public.data",
                filename: "image.png"
            )

            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        switch result {
        case .sent:
            self.contactInviteAPI()
        default:
            print("not sent")
        }
        UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: UIColor.clear), for: .default)
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: API CALLS
extension ReferralTrackerViewController{
    @objc func fetchUsersListFromAPI() {
        store.fetchContactsList(showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            self.referralUsersList.removeAll()
            self.array_Filtered.removeAll()

            if let _ = success as? [String: Any] {
                print(success)
                print("success")
                self.referralUsersList = self.store.referralUsersList
                self.array_Filtered = self.referralUsersList

                self.setupUI()

                //self.moveToNextView()
            }
        }) { (failure) -> Void in
            self.referralUsersList.removeAll()
            self.array_Filtered.removeAll()
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    
    func callSaveContacts(parameters: [String:Any]) {
        store.contactSave(parameters: parameters, showLoader: true, outhType: "", completionBlockSuccess: { (response) -> Void in
            // your successful handle
//            print(response)
            self.fetchUsersListFromAPI()
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    
    func contactInviteAPI()
    {
        let value = self.array_Filtered[selectedIndex]
        store.contactInviteAPI(parameters: ["contact_id":value.id], showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any]
            {
                print(success)
                print("success")
                let message = "Invite sent successfully".uppercased()
                let alert = CustomAlert()
                alert.showCustomAlertWithImage(message: message, imageName: "invite_msg_icon", viewController: self)

                // self.followUnFollowUIsetup(index: index)
                self.fetchUsersListFromAPI()
            }
        }) { (failure) -> Void in
            self.handleAPIError(failure: failure)
        }
    }
}
extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
