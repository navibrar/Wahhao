//  Created by Navpreet on 28/09/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit
import TLPhotoPicker
import CropViewController
import Kingfisher

class UserInterestsVC: UIViewController {
    //MARK:- Variable Declaration
    var dict_Localized = [String:String]()
    var selectedAssets = [TLPHAsset]()
    var array_UserInterests = [UserInterest]()
    var selectedImage = UIImage()
    var mobileNumber = ""
    var profileImageUrl = ""
    var fullName = ""
    var facebookId = ""
    var isSocialLogin = Bool()
    var userThumbnail = UIImage(named: "facebook_profile_img")
    
    
    //MARK:- Outlet Connections
    @IBOutlet weak var tf_FullName: UITextField!
    @IBOutlet weak var tf_UserName: UITextField!
    @IBOutlet weak var tf_Email: UITextField!
    @IBOutlet weak var tf_ReferralCode: UITextField!
    @IBOutlet weak var view_FollowBrand: UIView!
    @IBOutlet weak var lbl_Interests: UILabel!
    @IBOutlet weak var constraint_ContentHeight: NSLayoutConstraint!
    @IBOutlet weak var scroll_Content: UIScrollView!
    @IBOutlet weak var collection_UserInterests: UICollectionView!
    @IBOutlet weak var constraint_CollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var img_UserProfile: UIImageView!
    @IBOutlet weak var barBtn_Done: UIBarButtonItem!
    @IBOutlet weak var lbl_SelectCategories: UILabel!
    @IBOutlet weak var btn_Done: UIButton!
    @IBOutlet weak var btn_UploadImage: UIButton!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalizedText()
        self.initialSetup()
        if isSocialLogin == true {
            self.view_FollowBrand.isHidden = true
            self.btn_UploadImage.isEnabled = false
            self.setUserProfileDataFromSocialAccount()
        }
        //Notification
        NOTIFICATIONCENTER.addObserver(self, selector: #selector(self.checkPermissionAuthorizedByUser), name: PrivacyPermissions.sharedInstance.PRIVACY_PERMISSION_NOTIFICATION_NAME, object: nil)
        self.perform(#selector(self.callGetUserInterests), with: self, afterDelay: 0.1)
        
        ADD_DONE_BUTTON_TO_TOOLBAR(textField: tf_FullName)
        ADD_DONE_BUTTON_TO_TOOLBAR(textField: tf_UserName)
        ADD_DONE_BUTTON_TO_TOOLBAR(textField: tf_Email)
        ADD_DONE_BUTTON_TO_TOOLBAR(textField: tf_ReferralCode)
        FirAnalytics.trackPageView(withScreen: FirAnalytics.Screen.createProfile)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    //MARK:- Keyboard hide Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:- NSNotification Center method
    @objc func checkPermissionAuthorizedByUser(note: NSNotification) {
        if let object = note.object as? String {
            if object == ConfigurationManager.PrivacyPermissionMessage.Image_Picker_Permission_Message.rawValue || object == ConfigurationManager.PrivacyPermissionMessage.Image_Capture_Permission_Message.rawValue {
                self.openGalleryToPickImage()
            }
        }
    }
    
    //MARK:- Custom Methods
    func setLocalizedText() {
        dict_Localized = GET_LOCALIZED_STRING_DICTIONARY(forClass: "UserInterests")
        self.title = dict_Localized["labelTitle"]?.uppercased()
        tf_FullName.placeholder = dict_Localized["labelFullName"]
        tf_UserName.placeholder = dict_Localized["labelUsername"]
        tf_Email.placeholder = dict_Localized["labelEmail"]
        tf_ReferralCode.placeholder = dict_Localized["labelReferralCode"]
        btn_Done.setTitle(dict_Localized["labelDone"]?.uppercased(), for: .normal)
        barBtn_Done.title = dict_Localized["labelDone"]
        lbl_SelectCategories.text = dict_Localized["labelCategories"]
    }
    func initialSetup()  {
        view_FollowBrand.roundCorners([.topLeft], radius: 9)
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
    }
    func setUserProfileDataFromSocialAccount()  {
        tf_FullName.text = fullName
        tf_UserName.text = ""
        tf_Email.text = ""
        tf_ReferralCode.text = ""
        if profileImageUrl != "" {
            let url = URL(string: profileImageUrl)
            img_UserProfile.kf.setImage(with: url)
        }
    }
    func adjustViewHeight() {
        //200
        var safeAreaHeight:CGFloat = 0
        var topPadding:CGFloat = 0
        var bottomPadding:CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = window?.safeAreaInsets.top ?? 0
            bottomPadding = window?.safeAreaInsets.bottom ?? 0
        }
        if tabBarController?.tabBar != nil {
            safeAreaHeight = topPadding + (tabBarController?.tabBar.bounds.height)! + bottomPadding
        }
        if self.navigationController?.navigationBar.bounds.height != nil {
            safeAreaHeight = topPadding + (self.navigationController?.navigationBar.bounds.height)! + bottomPadding
        } else {
            safeAreaHeight = topPadding + bottomPadding
        }
        let contentViewActualHeight: CGFloat = UIScreen.main.bounds.height - safeAreaHeight
        scroll_Content.contentSize = CGSize(width: self.view.bounds.width, height: self.collection_UserInterests.contentSize.height+580)
        self.constraint_CollectionHeight.constant = self.collection_UserInterests.contentSize.height
        let contentHeight = self.scroll_Content.contentSize.height - contentViewActualHeight
        if contentHeight > 0 {
            self.constraint_ContentHeight.constant = contentHeight
        }
    }
    
    @objc func userInterestsValidation() {
        self.view.endEditing(true)
        //1
        if isSocialLogin == false {
            if img_UserProfile.image == userThumbnail {
                AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:dict_Localized["errorProfilePicture"]!, btnTitle: dict_Localized["labelOk"]!, viewController: self, completionHandler: { (success) in
                    self.scroll_Content.contentOffset = .zero
                })
                return
            }
        }
        //2
        guard let _ = tf_FullName.text, tf_FullName.text?.trimmingCharacters(in: .whitespaces).isEmpty == false && (tf_FullName.text?.count)! >= ConfigurationManager.CharacterLength.FullNameMinLength.value else{
            var message = ""
            if tf_FullName.text?.count == 0 || tf_FullName.text == "" {
                message = dict_Localized["errorFullName"]!
            }else {
                message = dict_Localized["errorValidFullName"]!
            }
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: "OK", viewController: self, completionHandler: { (success) in
                self.tf_FullName.becomeFirstResponder()
            })
            return
        }
        //3
        guard let _ = tf_UserName.text, tf_UserName.text?.isEmpty == false && tf_UserName.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && (tf_UserName.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! >= ConfigurationManager.CharacterLength.UserNameMinLength.value else{
            var message = ""
            if tf_UserName.text?.count == 0 || tf_UserName.text == "" {
                message = dict_Localized["errorSetUsername"]!
            }else {
                message = dict_Localized["errorValidUsername"]!
            }
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: dict_Localized["labelOk"]!, viewController: self, completionHandler: { (success) in
                self.tf_UserName.becomeFirstResponder()
            })
            return
        }
        //4
        guard let _ = tf_Email.text, tf_Email.text?.isEmpty == false &&  Validations.isValidEmailAddress(emailId: tf_Email.text ?? "") == true else{
            var message = ""
            if tf_Email.text?.count == 0 || tf_Email.text == "" {
                message = dict_Localized["enterEmailError"]!
            }else {
                message = dict_Localized["enterValidEmailError"]!
            }
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelOk"), viewController: self, completionHandler: { (success) in
                self.tf_Email.becomeFirstResponder()
            })
            return
        }
        //5
        let filteredArray = array_UserInterests.filter({$0.isSelected == true})
        if filteredArray.count < ConfigurationManager.CharacterLength.UserInterestMinimumCategorySelection.value {
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: (dict_Localized["labelSelectCategories"]?.capitalized)!, message: dict_Localized["errorSelectCategories"]!, btnTitle: dict_Localized["labelOk"]!, viewController: self) { (success) in
            }
            return
        }
        
        var interests = [Int]()
        for item in filteredArray {
            interests.append(item.id)
        }
        if isSocialLogin == true {
            let parameters:  [String: Any] = [
                "device_token": UserdefaultStore.USERDEFAULTS_GET_STRING_KEY(key: "DeviceToken"),
                "app_version":"1.0",
                "device_type":"ios",
                "device_id":"",
                "country_code": ConfigurationManager.CountryCode.US.rawValue,
                "mobile_no":self.mobileNumber,
                "interests":interests,
                "username":tf_UserName.text!,
                "referralcode": tf_ReferralCode.text ?? "",
                "fullname": tf_FullName.text!,
                "signup_type": "social",
                "social_id": facebookId,
                "profileimageurl": profileImageUrl,
                "email_id": tf_Email.text!
            ]
            self.callRegisterSocialUser(parameters: parameters)
        }else {
            let parameters:  [String: Any] = [
                "mobile_no":self.mobileNumber,
                "interests":interests,
                "username":tf_UserName.text!,
                "referralcode": tf_ReferralCode.text ?? "",
                "fullname": tf_FullName.text!,
                "email": tf_Email.text!
            ]
            self.callSaveUserInterests(parameters: parameters)
        }
        
    }
    @objc func moveToNextView() {
        let checkout = CheckoutServices.sharedInstance
        checkout.removeUserStoredDataFromCheckout()
        
        let storyboard = UIStoryboard(name: "ProjectStoryboard", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "HomePostViewController") as! HomePostViewController
        let navController = UINavigationController(rootViewController: vcObj)
        self.show(navController, sender: self)
    }
    func openGalleryToPickImage() {
        //TLPhoto Picker
        let tlPhotoPickerController = TLPhotosPickerViewController()
        var configure = TLPhotosPickerConfigure()
        tlPhotoPickerController.delegate = self
        configure.allowedVideo = false
        tlPhotoPickerController.configure.mediaType = .image
        tlPhotoPickerController.configure.cancelTitle = GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelCancel")
        tlPhotoPickerController.configure.selectedColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1)
        tlPhotoPickerController.configure.singleSelectedMode = true
        //tlPhotoPickerController.configure.usedCameraButton = false
        tlPhotoPickerController.configure.allowedVideoRecording = false
        DispatchQueue.main.async {
            self.present(tlPhotoPickerController, animated: true, completion: nil)
        }
    }
    func cropImage(image: UIImage) {
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.aspectRatioPreset = .presetSquare
        /*cropViewController.customAspectRatio = CGSize(width: self.view.bounds.width, height: self.view.bounds.width)
         cropViewController.cropView.cropBoxResizeEnabled = false
         cropViewController.aspectRatioLockEnabled = true
         cropViewController.resetAspectRatioEnabled = false*/
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.present(cropViewController, animated: true, completion: nil)
        }
    }
    func uploadCroppedImageToServer(croppedImage: UIImage) {
        let imageDetails = CameraManager.getImageData_Name_MimeType(image: croppedImage, viewController: self, imageName: "")
        if imageDetails.fileName.isEmpty == false || imageDetails.fileName.isEmpty == false || imageDetails.mimeType.isEmpty == false {
            self.callUploadMediaFileToServer(fileData: imageDetails.imageData, fileName: imageDetails.fileName, fileType: imageDetails.mimeType)
        }
    }
    @IBAction func uploadUserProfilePictureTapped(_ sender: Any) {
        if profileImageUrl == "" {
            self.openMediaPicker()
        }else {
            let actionSheet = UIAlertController(title: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelSelectOption"), message: nil, preferredStyle: .actionSheet)
            self.present(actionSheet, animated: true, completion: nil)
            
            let attributedString = NSAttributedString(string: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelSelectOption"), attributes: [
                NSAttributedString.Key.font : UIFont(name: Constants.SEMI_BOLD_FONT, size: 15)!,
                NSAttributedString.Key.foregroundColor : UIColor.black
                ])
            actionSheet.setValue(attributedString, forKey: "attributedTitle")
            //1
            if Login.loadCustomerInfoFromKeychain()?.profile_image != "" {
                let removeAction = UIAlertAction(title: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelRemoveCurrentPhoto"), style: .destructive) { (action) in
                    self.removeUserProfileImage()
                }
                actionSheet.addAction(removeAction)
            }
            //2
            let replacePhotoAction = UIAlertAction(title: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelReplacePhoto"), style: .default) { (action) in
                self.openMediaPicker()
            }
            actionSheet.addAction(replacePhotoAction)
            //3
            let cancelAction = UIAlertAction(title: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelCancel"), style: .cancel) { (action) in
            }
            actionSheet.addAction(cancelAction)
        }
    }
    
    func removeUserProfileImage() {
        AlertController.SHOW_ALERT_CONTROLLER_DOUBLE_BUTTON(alertTitle: "", message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "msgRemoveCurrentPhoto"), btnTitle1: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelCancel"), btnTitle2: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelOk"), viewController: self) { (response) in
            if response.caseInsensitiveCompare("Button2") == .orderedSame {
                let account_id = Login.loadCustomerInfoFromKeychain()?.id ?? 0
                if account_id > 0 {
                    self.callRemoveUserProfileAPI(parameters: ["userid":account_id])
                }else {
                    self.resetUserProfileImage()
                }
            }
        }
    }
    func resetUserProfileImage() {
        self.profileImageUrl = ""
        KeychainWrapper.standard.set("", forKey: "profile_image")
        self.selectedImage = UIImage()
        self.img_UserProfile.image = userThumbnail
    }
    func openMediaPicker() {
        let isAuthorized : Bool = PrivacyPermissions.sharedInstance.CHECK_PHOTO_LIBRARY_PERMISSIONS(message: ConfigurationManager.PrivacyPermissionMessage.Image_Picker_Permission_Message.rawValue, viewController: self)
        if isAuthorized == true {
            self.openGalleryToPickImage()
        }
    }
    //MARK:- Button Actions
    @IBAction func doneTapped(_ sender: Any) {
        //self.moveToNextView()
        self.userInterestsValidation()
    }
}


//MARK: - TLPhotoPicker Controller Delegate
extension UserInterestsVC : TLPhotosPickerViewControllerDelegate {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        if withTLPHAssets.count > 0 {
            if withTLPHAssets.first!.fullResolutionImage != nil {
                self.selectedImage = withTLPHAssets.first!.fullResolutionImage!
                self.cropImage(image: self.selectedImage)
                /*self.selectedImage = withTLPHAssets.first!.fullResolutionImage!
                 self.uploadCroppedImageToServer(croppedImage: selectedImage)*/
            }else {
                AlertController.SHOW_AUTOHIDE_MESSAGE(controller: self, message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "errorImageFetching"), time: 1.0)
            }
        }
    }
    func photoPickerDidCancel() {
        print("TLPhotoPicker Cancelled")
    }
    func uploadSelectedAssetToServer(asset: TLPHAsset) {
        if let _ = asset.fullResolutionImage {
            //print("file name",asset.phAsset?.location as Any)
            asset.tempCopyMediaFile(convertLivePhotosToJPG: false, progressBlock: { (progress) in
                print(progress)
            }, completionBlock: { (url, mimeType) in
                print("completion\(url)")
                let imageDetails = CameraManager.getImageData_Name_MimeType(image: asset.fullResolutionImage!, viewController: self, imageName: asset.originalFileName!)
                if imageDetails.fileName.isEmpty == false || imageDetails.fileName.isEmpty == false || imageDetails.mimeType.isEmpty == false {
                    self.callUploadMediaFileToServer(fileData: imageDetails.imageData, fileName: imageDetails.fileName, fileType: imageDetails.mimeType)
                }
            })
        }
    }
}
//MARK:- Crop View Controller Delegate
extension UserInterestsVC: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        self.dismiss(animated: true, completion: nil)
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.selectedImage = image
        //self.photoImageView.image  = image
        self.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
            self.uploadCroppedImageToServer(croppedImage: image)
        }
    }
    
}
//MARK:- UICollectionViewDelegate & UICollectionViewDataSource
extension UserInterestsVC :UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array_UserInterests.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((self.view.bounds.width-74)/2)-7
        return CGSize(width: width, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserInterestCell", for: indexPath) as! UserInterestCell
        cell.configureCell(item: array_UserInterests[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.array_UserInterests[indexPath.item].isSelected = !self.array_UserInterests[indexPath.item].isSelected
        var indexPaths = [IndexPath]()
        indexPaths.append(indexPath)
        UIView.performWithoutAnimation {
        collectionView.reloadItems(at: indexPaths)
        }
    }
}

//MARK:- UITextFieldDelegate
extension UserInterestsVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var success : Bool! = true
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        if textField == tf_FullName {
            success = newLength > ConfigurationManager.CharacterLength.FullNameMaxLength.value ? false : true
        }else if textField == tf_UserName {
            let result = newString.prefix(1)
            if result == "_" || result == "."{
                return false
            }
            let cs = NSCharacterSet(charactersIn: USERNAME).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            let isValidCharacters  = (string == filtered)
            success = isValidCharacters == true ? (newLength <= ConfigurationManager.CharacterLength.UserNameMaxLength.value) : false
        }else if textField == tf_Email {
            success = newLength > ConfigurationManager.CharacterLength.EmailLength.value ? false : true
        }else if textField == tf_ReferralCode {
            success = newLength > ConfigurationManager.CharacterLength.ReferralCodeMaxLength.value ? false : true
        }
        return success
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tf_FullName {
            _ = tf_UserName.becomeFirstResponder()
        }else if textField == tf_UserName {
            _ = tf_Email.becomeFirstResponder()
        }else if textField == tf_Email {
            _ = tf_ReferralCode.becomeFirstResponder()
        }else if textField == tf_ReferralCode {
            _ = tf_ReferralCode.resignFirstResponder()
        }
        return true
    }
}

//MARK:- API CALL
extension UserInterestsVC {
    @objc func callGetUserInterests() {
        let service = LoginServices()
        service.callGetUserInterestsAPI(isSocialLogin: self.isSocialLogin, socialId: self.facebookId, showLoader: true, completionBlockSuccess: { (success) -> Void in
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
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                        self.adjustViewHeight()
                    }
                }
            }
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    func callSaveUserInterests(parameters: [String:Any]) {
        let service = LoginServices()
        service.callSetUserInterestsAPI(parameters: parameters, showLoader: true, completionBlockSuccess: { (success) -> Void in
            // your successful handle
            FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.createProfile, category: FirAnalytics.Category.createProfile, label: FirAnalytics.Label.Profile_completed_success, action: FirAnalytics.Actions.createProfileBtn, value: 1)
            print(success)
            if let response = success["response"] as? NSDictionary {
                if let details = response["user_info"] as? NSDictionary {
                    KeychainWrapper.standard.set(details["username"] as? String ?? "", forKey: "username")
                    KeychainWrapper.standard.set(true, forKey: "has_username")
                }
            }
            self.moveToNextView()
        }) { (failure) -> Void in
            // your failure handle
            FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.createProfile, category: FirAnalytics.Category.createProfile, label: FirAnalytics.Label.Profile_completed_success, action: FirAnalytics.Actions.createProfileBtn, value: 0)
            self.handleAPIError(failure: failure)
        }
    }
    func callRegisterSocialUser(parameters: [String:Any]) {
        let service = LoginServices()
        service.callVerifySocialLoginRegisterAPi(parameters: parameters, isLogin: false, completionBlockSuccess: { (success) -> Void in
            // your successful handle
            FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.createProfile, category: FirAnalytics.Category.createProfile, label: FirAnalytics.Label.Profile_completed_success, action: FirAnalytics.Actions.createProfileBtn, value: 1)
            print(success)
            if let response = success["response"] as? NSDictionary {
                if let details = response["user_info"] as? NSDictionary {
                    KeychainWrapper.standard.set(details["username"] as? String ?? "", forKey: "username")
                    KeychainWrapper.standard.set(true, forKey: "has_username")
                    KeychainWrapper.standard.set(details["profile_image"] as? String ?? "", forKey: "profile_image")
                }
            }
            self.moveToNextView()
        }) { (failure) -> Void in
            // your failure handle
            FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.createProfile, category: FirAnalytics.Category.createProfile, label: FirAnalytics.Label.Profile_completed_success, action: FirAnalytics.Actions.createProfileBtn, value: 0)
            self.handleAPIError(failure: failure)
        }
    }
    func callRemoveUserProfileAPI(parameters: [String:Any]) {
        let service = LoginServices()
        service.removeUserImageAPI(parameters: parameters, showLoader: true, completionBlockSuccess: { (success) -> Void in
            // your successful handle
            print(success)
            if let _ = success["response"] as? NSDictionary {
                self.resetUserProfileImage()
            }
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    func callUploadMediaFileToServer(fileData: Data, fileName: String, fileType: String) {
        self.img_UserProfile.image = self.selectedImage
        let services = LoginServices()
        let parameters: [String: Any] = ["mobile_no":mobileNumber]
        services.callUploadUserProfileImageAPI(parameters: parameters, fileData: fileData, fileName: fileName, fileType: fileType, forKey: "resource", showLoader: true, completionBlockSuccess: { (success) -> Void in
            //Success block
            print(success)
            self.img_UserProfile.image = self.selectedImage
            if let response = success["response"] as? NSDictionary {
                if let details = response["user_details"] as? NSDictionary {
                    self.profileImageUrl = details["profileimage"] as? String ?? ""
                    KeychainWrapper.standard.set(details["profileimage"] as? String ?? "", forKey: "profile_image")
                }
            }
        },andFailureBlock: { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        })
    }
}
