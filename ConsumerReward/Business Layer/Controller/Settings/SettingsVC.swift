//  Created by Navpreet on 24/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.

import UIKit

class SettingsVC: UIViewController {
    //MARK:- Variable Declaration
    private enum SettingHeader {
        static let Interests = 0
        static let NotificationSettings = 1
    }
    var array_UserInterests = [UserInterest]()
    var array_NotificationsSettings = [NotificationsSettings]()
    
    //MARK:- Outlet Connections
    @IBOutlet weak var segment_Options: HBSegmentedControl!
    @IBOutlet weak var table_NotificationSetting: UITableView!
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var collection_UserInterests: UICollectionView!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        self.initialSetup()
        //SWIPE GESTURES
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        segment_Options.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        segment_Options.addGestureRecognizer(swipeRight)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK:- Swipe Gesture
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                print("move Left")
                if segment_Options.selectedIndex == SettingHeader.NotificationSettings {
                    segment_Options.selectedIndex = SettingHeader.Interests
                    setUpInterestView()
                }
            case UISwipeGestureRecognizer.Direction.right:
                print("move Right")
                if segment_Options.selectedIndex == SettingHeader.Interests {
                    segment_Options.selectedIndex = SettingHeader.NotificationSettings
                    setUpNotificationSettingView()
                }
            default:
                break
            }
        }
    }
    
    //MARK:- Custom Methods
    func initialSetup() {
        segment_Options.items = ["INTERESTS", "NOTIFICATION SETTINGS"]
        segment_Options.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: 11)
        segment_Options.setFont()
        segment_Options.selectedIndex = SettingHeader.Interests
        segment_Options.borderColor = .clear
        segment_Options.backgroundColor = #colorLiteral(red: 0.08003249019, green: 0.1880437434, blue: 0.3238782883, alpha: 1)
        segment_Options.addTarget(self, action: #selector(PaymentShippingManagementVC.segmentValueChanged(_:)), for: .valueChanged)
        
        table_NotificationSetting.register(UINib(nibName: "NotificationSettingCell", bundle: nil), forCellReuseIdentifier: "NotificationSettingCell")
        
        collection_UserInterests.register(UINib(nibName: "UserInterestCell", bundle: nil), forCellWithReuseIdentifier: "UserInterestCell")
        collection_UserInterests.isScrollEnabled = false
        collection_UserInterests.showsVerticalScrollIndicator = false
        collection_UserInterests.backgroundColor = UIColor.clear
        if let layout = collection_UserInterests.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 16
            layout.minimumInteritemSpacing = 8
            collection_UserInterests.collectionViewLayout = layout
        }
        self.enableDisableSaveButton()
        
        self.setUpInterestView()
    }
    @objc func segmentValueChanged(_ sender: AnyObject?){
        if segment_Options.selectedIndex == SettingHeader.Interests {
            self.setUpInterestView()
        }else if segment_Options.selectedIndex == SettingHeader.NotificationSettings{
            self.setUpNotificationSettingView()
        }
    }
    func setUpInterestView() {
        self.table_NotificationSetting.isHidden = true
        self.collection_UserInterests.isHidden = false
        self.btn_Save.isHidden = false
        if self.array_UserInterests.count > 0 {
            self.collection_UserInterests.reloadData()
        }else {
            self.callGetUserInterests()
        }
    }
    func setUpNotificationSettingView() {
        self.table_NotificationSetting.isHidden = false
        self.collection_UserInterests.isHidden = true
        self.btn_Save.isHidden = true
        if self.array_NotificationsSettings.count > 0 {
            self.table_NotificationSetting.reloadData()
        }else {
            self.callGetNotificationSettingStatus()
        }
    }
    @objc func userInterestsValidation() {
        let filteredArray = array_UserInterests.filter({$0.isSelected == true})
        if filteredArray.count < ConfigurationManager.CharacterLength.UserInterestMinimumCategorySelection.value {
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "Select Categories", message: "Please make at least 3 selections, so that we can personalize your experience.", btnTitle: "OK", viewController: self) { (success) in
            }
            return
        }
        
        var interests = [Int]()
        for item in filteredArray {
            interests.append(item.id)
        }
        let parameters:  [String: Any] = [
            "interests":interests
        ]
        self.callSaveUserInterests(parameters: parameters)
    }
    
    func enableDisableSaveButton() {
        let filtered = self.array_UserInterests.filter({$0.isSelected == true})
        if filtered.count > 2 {
            btn_Save.alpha = 1.0
            btn_Save.isUserInteractionEnabled = true
        }else {
            btn_Save.alpha = 0.4
            btn_Save.isUserInteractionEnabled = false
        }
    }
    //MARK:- Button Actions
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveTapped(_ sender: Any) {
        self.userInterestsValidation()
    }
}

//MARK:- UITableViewDelegate & UITableViewDataSource
extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    //MARK:- Methods
    @objc func notificationItemSwitchValueChanged(sender:UISwitch) {
        let switchPosition = sender.convert(CGPoint.zero, to: self.table_NotificationSetting)
        if let indexPath = self.table_NotificationSetting.indexPathForRow(at: switchPosition) {
            self.array_NotificationsSettings[indexPath.row].is_enabled = !(self.array_NotificationsSettings[indexPath.row].is_enabled)
            var notifications = [NSDictionary]()
            for item in array_NotificationsSettings {
                let dict: NSDictionary = ["title": item.title, "is_enabled": item.is_enabled]
                notifications.append(dict)
            }
            let params: [String: Any] = ["notification": notifications]
            self.callUpdateNotificationSettingStatus(parameters: params)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_NotificationsSettings.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationSettingCell", for: indexPath) as! NotificationSettingCell
        cell.configureCell(item: array_NotificationsSettings[indexPath.row])
        cell.switch_Setting.addTarget(self, action: #selector(self.notificationItemSwitchValueChanged(sender:)), for: .valueChanged)
        if indexPath.row == 0 {
            cell.view_Bg.topRoundCornners(radius: 6)
        }else if indexPath.row == array_NotificationsSettings.count-1 {
            cell.view_Bg.bottomRoundCornners(radius: 6)
            cell.lbl_Seperator.isHidden = true
        }
        cell.selectionStyle = .none
        return cell
    }
}

//MARK:- UICollectionViewDelegate & UICollectionViewDataSource
extension SettingsVC :UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array_UserInterests.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((self.view.bounds.width-32)/2)-8
        return CGSize(width: width, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserInterestCell", for: indexPath) as! UserInterestCell
        cell.configureCell(item: array_UserInterests[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.array_UserInterests[indexPath.item].isSelected = !self.array_UserInterests[indexPath.item].isSelected
        self.enableDisableSaveButton()
        var indexPaths = [IndexPath]()
        indexPaths.append(indexPath)
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: indexPaths)
        }
    }
}

//MARK:- API CALL
extension SettingsVC {
    @objc func callGetUserInterests() {
        let service = LoginServices()
        service.callGetUserInterestsAPI(isSocialLogin: false, socialId: "", showLoader: true, completionBlockSuccess: { (success) -> Void in
            // your successful handle
            print(success)
            if let dict = success["response"] as? NSDictionary {
                if let allInterest = dict["interest"] as? [NSDictionary] {
                    self.array_UserInterests.removeAll()
                    for item in allInterest {
                        let interest = UserInterest(dictionary: item)
                        self.array_UserInterests.append(interest)
                    }
                    self.collection_UserInterests.reloadData()
                    self.enableDisableSaveButton()
                }
            }
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    func callSaveUserInterests(parameters: [String:Any]) {
        let service = LoginServices()
        service.callUpdateUserInterestsAPI(parameters: parameters, showLoader: true, completionBlockSuccess: { (success) -> Void in
            // your successful handle
            print(success)
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    @objc func callGetNotificationSettingStatus() {
        let service = SettingsServices()
        service.callGetNotificationSettingsStatusAPI(showLoader: true, completionBlockSuccess: { (success) -> Void in
            // your successful handle
            print(success)
            if let settings = success["response"] as? [NSDictionary] {
                self.array_NotificationsSettings.removeAll()
                for item in settings {
                    let setting = NotificationsSettings(dictionary: item)
                    self.array_NotificationsSettings.append(setting)
                }
                self.table_NotificationSetting.reloadData()
            }
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    func callUpdateNotificationSettingStatus(parameters: [String:Any]) {
        let service = SettingsServices()
        service.callUpdateNotificationSettingsStatusAPI(parameters: parameters, showLoader: true, completionBlockSuccess: { (success) -> Void in
            // your successful handle
            print(success)
        }) { (failure) -> Void in
            // your failure handle
            self.table_NotificationSetting.reloadData()
            self.handleAPIError(failure: failure)
        }
    }
}

