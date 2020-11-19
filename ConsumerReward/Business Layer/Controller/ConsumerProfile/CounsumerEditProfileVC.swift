//
//  CounsumerEditProfileVC.swift
//  ConsumerReward
//
//  Created by apple on 08/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import UIKit
import TLPhotoPicker
import AVFoundation
import MobileCoreServices
import CropViewController
import SkyFloatingLabelTextField
import SwiftPhoneNumberFormatter

protocol EditProfileDismissDelegate {
    func editProfileDismissed(EditconsumerBasic: consumerBasicInfo)
}


class CounsumerEditProfileVC: UIViewController {
    //MARK:- Variable Declaration
    let str_StatusPlaceholder = "STATUS"
     var array_Gender = [Gender]()
    var user_Gender = 0
    var imagePicker: UIImagePickerController!
    let str_BirthdayPlaceholder = "BIRTH DTAE"
    let store = UserProfileServices()
    var dict_Resource = NSMutableDictionary()
    var capturedImage = UIImage()
    var user_DOB = String()
    var isChangesMade = false
    var profileimage_url = String()
    var editProfileDismissDelegate :  EditProfileDismissDelegate!
    @IBOutlet weak var view_Content: UIView!
    @IBOutlet weak var img_User: UIImageView!
    @IBOutlet weak var btn_EditProfile: UIButton!
    @IBOutlet weak var tf_userName: SkyFloatingLabelTextField!
    @IBOutlet weak var tf_fullName: SkyFloatingLabelTextField!
    @IBOutlet weak var lbl_Status: UILabel!
    @IBOutlet weak var text_Status: UITextView!
    @IBOutlet weak var lbl_StatusErrorLine: UILabel!
    @IBOutlet weak var tf_CountryCode_lbl: UILabel!
    @IBOutlet weak var btn_Phone: UIButton!
    @IBOutlet weak var btn_Email: UIButton!
    @IBOutlet weak var tf_Phone: PhoneFormattedTextField!
    @IBOutlet weak var tf_Email: SkyFloatingLabelTextField!
//    @IBOutlet weak var btn_Email: UIButton!
//    @IBOutlet weak var tf_Email: SkyFloatingLabelTextField!
    @IBOutlet weak var tf_Gender: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_Gender: UIButton!
    @IBOutlet weak var tf_BirthDate: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_Birthday: UIButton!
    // @IBOutlet weak var constraint_ViewImgHeight: NSLayoutConstraint!
  //  @IBOutlet weak var constraint_ViewContentHeight: NSLayoutConstraint!
    //Picker Gender
    @IBOutlet var picker_Options: UIPickerView!
    @IBOutlet weak var view_Picker: UIView!
    @IBOutlet weak var barBtn_Cancel: UIBarButtonItem!
    @IBOutlet weak var barBtn_Select: UIBarButtonItem!
    
    //Picker Date
    @IBOutlet var picker_Date: UIDatePicker!
    @IBOutlet weak var view_PickerDate: UIView!
    @IBOutlet weak var barBtn_CancelDate: UIBarButtonItem!
    @IBOutlet weak var barBtn_SelectDate: UIBarButtonItem!
    var consumerBasic: consumerBasicInfo? = nil
    var formatter = PhoneFormatter(rulesets: PNFormatRuleset.usHyphen())
    var profileImageUrl = ""
    var selectedImage = UIImage()
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPicker()
        self.initializeImagePickerController()
      //  self.perform(#selector(self.callFetchUserProfile), with: self, afterDelay: 0.1)
        //Notification
        NOTIFICATIONCENTER.addObserver(self, selector: #selector(self.checkPermissionAuthorizedByUser), name: PrivacyPermissions.sharedInstance.PRIVACY_PERMISSION_NOTIFICATION_NAME, object: nil)
        NOTIFICATIONCENTER.addObserver(self, selector: #selector(updateDetails), name: NSNotification.Name("UpdateDetails"), object: nil)
        
        //Mark : - Gender Drop Data With Replace with Dtaa Get In Api
        let dict1: NSMutableDictionary = ["name":"Select an Option", "id":"0"]
         let dict2: NSMutableDictionary = ["name":"Male", "id":"1"]
         let dict3: NSMutableDictionary = ["name":"Female", "id":"2"]
        let dict4: NSMutableDictionary = ["name":"Others", "id":"3"]

        array_Gender.append(Gender(dictionary: dict1))
        array_Gender.append(Gender(dictionary: dict2))
        array_Gender.append(Gender(dictionary: dict3))
        array_Gender.append(Gender(dictionary: dict4))
        initialSetup()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
         self.view.addGestureRecognizer(tap)
        
        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipedown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipedown)
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                self.moveToPreviousController()
            default:
                break
            }
        }
    }
    
    @objc func viewTapped() {
        //   self.dismiss(animated: true, completion: nil)
        self.view.endEditing(true)
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
        text_Status.setContentOffset(CGPoint.zero, animated: false)
    }
    //MARK:- NSNotification Center method
    @objc func checkPermissionAuthorizedByUser(note: NSNotification) {
        if let object = note.object as? String {
            if object == ConfigurationManager.PrivacyPermissionMessage.Image_Picker_Permission_Message.rawValue  {
                self.openGalleryToPickImage()
            }
            if object == ConfigurationManager.PrivacyPermissionMessage.Image_Capture_Permission_Message.rawValue {
                self.openCameraToCaptureImage()
            }
        }
    }
    @objc func updateDetails() {
      //  tf_Email.text = KeychainWrapper.standard.string(forKey: "email")
         print("get Area no","+" + KeychainWrapper.standard.string(forKey: "registered_mobile_area_code")!)
        tf_CountryCode_lbl.text = "+" + KeychainWrapper.standard.string(forKey: "registered_mobile_area_code")!
        
        print("get phone no",KeychainWrapper.standard.string(forKey: "registered_mobile") as Any)
        tf_Phone.text = KeychainWrapper.standard.string(forKey: "registered_mobile")
       // tf_Email.text = KeychainWrapper.standard.string(forKey: "email")
        view_Picker.isHidden = true
        view_PickerDate.isHidden = true
    }
    //MARK:- Custom Methods
    func initialSetup() {
       tf_userName.text = self.consumerBasic?.username
        tf_userName.isUserInteractionEnabled = false
        
       tf_fullName.text = self.consumerBasic?.full_name
        
        if (self.consumerBasic?.dob.count)! > 0 {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
            if let showDate = inputFormatter.date(from: (self.consumerBasic?.dob)!) {
                inputFormatter.dateFormat = "dd-MMM-yyyy"
                let resultString = inputFormatter.string(from: showDate)
                tf_BirthDate.text = resultString
            }
        
        user_DOB = (self.consumerBasic?.dob)!
        }
        lbl_Status.text = "Status".uppercased()
        
        let getMobileNumber = Login.loadCustomerInfoFromKeychain()?.registered_mobile
        if getMobileNumber!.count > 0 {
            
            let formattedText = self.formatter.format(number: getMobileNumber!)
            print("mobile number",formattedText)
            tf_Phone.text = formattedText
          //  tf_Phone.text = getMobileNumber
        }
        
        let getAreaCode = Login.loadCustomerInfoFromKeychain()?.registered_mobile_area_code
        if getAreaCode!.count > 0 {
            tf_CountryCode_lbl.text = getAreaCode
        }
        tf_Email.text = self.consumerBasic?.reg_email_id
        
        
        self.img_User.image = UIImage(named:  Constants.USER_DUMMY_IMAGE)

        let userImageUrl = self.consumerBasic?.user_media ?? ""
       // let userImageUrl = Login.loadCustomerInfoFromKeychain()?.profile_image ?? ""
        if userImageUrl != "" {
            let url = URL(string: userImageUrl)
            profileImageUrl = userImageUrl
            self.img_User.kf.setImage(with: url, placeholder: UIImage(named:Constants.USER_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        view_PickerDate.isHidden = true
        view_Picker.isHidden = true
        self.text_Status.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.text_Status.delegate = self
        self.text_Status.showsHorizontalScrollIndicator = false
        self.text_Status.text = self.consumerBasic?.bio
        
        for dict in array_Gender {
            let get_gender = dict.id
            if String(get_gender)  == self.consumerBasic?.gender {
                tf_Gender.text = dict.name
                user_Gender = get_gender
                break
            }
        }
        
       // tf_userName.isUserInteractionEnabled = true
    }
    func loadPicker() {
        self.picker_Options.delegate = self
        self.picker_Options.dataSource = self
        self.view_Picker.isHidden = true
        
        self.view_PickerDate.isHidden = true
        picker_Date.maximumDate = Date()
        
//        barBtn_CancelDate.setTitleTextAttributes([
//            NSAttributedString.Key.font : UIFont(name: Constants.REGULAR_FONT, size: 14)!,
//            NSAttributedString.Key.foregroundColor : UIColor.white,
//            ], for: .normal)
//        barBtn_SelectDate.setTitleTextAttributes([
//            NSAttributedString.Key.font : UIFont(name: Constants.REGULAR_FONT, size: 14)!,
//            NSAttributedString.Key.foregroundColor : UIColor.white,
//            ], for: .normal)
//
//
//        barBtn_Cancel.setTitleTextAttributes([
//            NSAttributedString.Key.font : UIFont(name: Constants.REGULAR_FONT, size: 14)!,
//            NSAttributedString.Key.foregroundColor : UIColor.white,
//            ], for: .normal)
//        barBtn_SelectDate.setTitleTextAttributes([
//            NSAttributedString.Key.font : UIFont(name: Constants.REGULAR_FONT, size: 14)!,
//            NSAttributedString.Key.foregroundColor : UIColor.white,
//            ], for: .normal)

        
    }
    func handleStatusFieldPlaceholder() {
        if text_Status.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" || text_Status.text.trimmingCharacters(in: .whitespacesAndNewlines) == str_StatusPlaceholder  {
            text_Status.text = str_StatusPlaceholder.uppercased()
            lbl_Status.isHidden = true
        }else {
            lbl_Status.isHidden = false
        }
        if text_Status.text.caseInsensitiveCompare(str_StatusPlaceholder) == .orderedSame {
            text_Status.textColor = #colorLiteral(red: 0.7663985491, green: 0.8196891546, blue: 0.9026022553, alpha: 1)
        }else{
            text_Status.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    func moveToPreviousController() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.editProfileDismissDelegate.editProfileDismissed(EditconsumerBasic: consumerBasic!)
        self.navigationController?.popViewController(animated: false)
    }
    func initializeImagePickerController() {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
    }
    func uploadImage() {
        let isAuthorized : Bool = PrivacyPermissions.sharedInstance.CHECK_PHOTO_LIBRARY_PERMISSIONS(message: ConfigurationManager.PrivacyPermissionMessage.Image_Picker_Permission_Message.rawValue, viewController: self)
        if isAuthorized == true {
            self.openGalleryToPickImage()
        }
    }
    func openGalleryToPickImage(){
        //TLPhoto Picker
        let tlPhotoPickerController = TLPhotosPickerViewController()
        var configure = TLPhotosPickerConfigure()
        tlPhotoPickerController.delegate = self
        configure.allowedVideo = false
        tlPhotoPickerController.configure.mediaType = .image
        tlPhotoPickerController.configure.cancelTitle = "Cancel"
        tlPhotoPickerController.configure.selectedColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1)
        tlPhotoPickerController.configure.singleSelectedMode = true
        tlPhotoPickerController.configure.usedCameraButton = false
        DispatchQueue.main.async {
            self.present(tlPhotoPickerController, animated: true, completion: nil)
        }
    }
    func removePhoto() {
        AlertController.SHOW_ALERT_CONTROLLER_DOUBLE_BUTTON(alertTitle: "", message: "Are you sure you want to remove your profile photo?", btnTitle1: "Cancel", btnTitle2: "Remove", viewController: self) { (response) in
            if response.caseInsensitiveCompare("Button2") == .orderedSame {
                self.dict_Resource.removeAllObjects()
                self.img_User.image = UIImage(named:"profile-img_1")
                self.isChangesMade = true
            }
        }
    }
    func captureImage() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            AlertController.SHOW_AUTOHIDE_MESSAGE(controller: self, message: "Device has no camera!", time: 1.0)
            return
        }
        let isAuthorized : Bool = PrivacyPermissions.sharedInstance.CHECK_CAMERA_PERMISSIONS(message: ConfigurationManager.PrivacyPermissionMessage.Image_Capture_Permission_Message.rawValue, viewController: self)
        if isAuthorized == true {
            self.openCameraToCaptureImage()
        }
    }
    func openCameraToCaptureImage() {
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = false
        imagePicker.cameraDevice = .rear
        imagePicker.cameraFlashMode = .auto
        imagePicker.videoQuality = .typeMedium
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    func cropImage(image: UIImage) {
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        //cropViewController.aspectRatioPreset = .presetSquare
        cropViewController.aspectRatioPreset = .presetCustom
        cropViewController.customAspectRatio = CGSize(width: self.view.bounds.width, height: self.view.bounds.width)
        cropViewController.cropView.cropBoxResizeEnabled = false
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.resetAspectRatioEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.present(cropViewController, animated: true, completion: nil)
        }
    }
    func uploadCroppedImageToServer(croppedImage: UIImage) {
        let imageDetails = CameraManager.getImageData_Name_MimeType(image: croppedImage, viewController: self, imageName: "")
        if imageDetails.fileName.isEmpty == false || imageDetails.fileName.isEmpty == false || imageDetails.mimeType.isEmpty == false {
            self.callUploadMediaFileToServer(fileData: imageDetails.imageData, fileName: imageDetails.fileName, fileType: imageDetails.mimeType)
        }
        // just for testing
       // self.img_User.image = croppedImage
    }
    func showAlertWithMessage(message:String, title: String) {
        AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: title, message: message, btnTitle: "OK", viewController: self) { (success)
            in
        }
    }
    //MARK:- Button Methods
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        if self.isChangesMade == true {
            AlertController.SHOW_ALERT_CONTROLLER_DOUBLE_BUTTON(alertTitle: "Unsaved Changes", message: "You have unsaved changes. Are you sure you want to cancel?", btnTitle1: "No", btnTitle2: "Yes", viewController: self) { (response) in
                if response.caseInsensitiveCompare("Button2") == .orderedSame {
                    self.moveToPreviousController()
                }
            }
        }else {
            self.moveToPreviousController()
        }
    }
    func callUploadMediaFileToServer(fileData: Data, fileName: String, fileType: String) {
       
        let services = LoginServices()
        let parameters: [String: Any] = ["mobile_no":tf_Phone.text as Any]
        services.callUploadUserProfileImageAPI(parameters: parameters, fileData: fileData, fileName: fileName, fileType: fileType, forKey: "resource", showLoader: true, completionBlockSuccess: { (success) -> Void in
            //Success block
            print(success)
             self.img_User.image = self.selectedImage
             self.isChangesMade = true
            if let response = success["response"] as? NSDictionary {
                if let details = response["user_details"] as? NSDictionary {
                    self.profileImageUrl = details["profileimage"] as? String ?? ""
//                    KeychainWrapper.standard.set(details["profileimage"] as? String ?? "", forKey: "profile_image")
                }
            }
        },andFailureBlock: { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        })
    }
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        if self.isChangesMade == false {
            self.moveToPreviousController()
            return
        }
        guard let _ = tf_fullName.text, tf_fullName.text!.trimmingCharacters(in: .whitespaces).isEmpty == false && (tf_fullName.text?.count)! > 2 else{
            var message = ""
            if tf_fullName.text?.count == 0 || tf_fullName.text == "" {
                message = "Please enter your full name"
            }else {
                message = "Please enter valid full name(Minimum 3 characters)"
            }
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: "OK", viewController: self, completionHandler: { (success) in
                self.tf_fullName.lineErrorColor = .red
            })
            return
        }
        
        
            //2
            guard let _ = tf_Email.text, tf_Email.text?.isEmpty == false &&  Validations.isValidEmailAddress(emailId: tf_Email.text ?? "") == true else{
                var message = ""
                if tf_Email.text?.count == 0 || tf_Email.text == "" {
                    message = "Email Address is required"
                }else {
                    message = "Please enter valid email format"
                }
                AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelOk"), viewController: self, completionHandler: { (success) in
//                    self.tf_Email.becomeFirstResponder()
                })
                return
            }
        
        /*guard let _ = text_Status.text, !(text_Status.text!.trimmingCharacters(in: .whitespaces).isEmpty) &&  text_Status.text != str_StatusPlaceholder && (text_Status.text?.count)! > 2 else{
         var message = ""
         if tf_fullName.text?.count == 0 || tf_fullName.text == "" {
         message = "Please enter status"
         }else {
         message = "Please enter valid status(Minimum 3 characters)"
         }
         AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message , btnTitle: "OK", viewController: self, completionHandler: { (success) in
         self.text_Status.becomeFirstResponder()
         self.lbl_StatusErrorLine.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
         })
         return
         }*/
//        let status = (text_Status.text!.trimmingCharacters(in: .whitespacesAndNewlines).caseInsensitiveCompare(str_StatusPlaceholder) == .orderedSame || text_Status.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "") ? "" : text_Status.text
        let parameters : [String:Any] = [
            "username": tf_userName.text!.trimmingCharacters(in: .whitespacesAndNewlines),
            "full_name": tf_fullName.text!.trimmingCharacters(in: .whitespacesAndNewlines),
            "status": text_Status.text!.trimmingCharacters(in: .whitespacesAndNewlines),
            "gender": String(user_Gender),
            "dob": user_DOB,
            "email": tf_Email.text!.trimmingCharacters(in: .whitespacesAndNewlines),
            "profile_pic":profileImageUrl]
           // "profile_pic": dict_Resource.allKeys.count > 0 ? [dict_Resource] : []]
        self.callUpdateUserProfile(parameters: parameters)
    }
    @IBAction func editImageTapped(_ sender: Any) {
        self.view.endEditing(true)
        let actionSheet = UIAlertController(title: "Change Profile Photo", message: nil, preferredStyle: .actionSheet)
        self.present(actionSheet, animated: true, completion: nil)
        let attributedString = NSAttributedString(string: "Change Profile Photo", attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor : UIColor.black
            ])
        actionSheet.setValue(attributedString, forKey: "attributedTitle")
        //1
        if dict_Resource.allKeys.count > 0 {
            let removeAction = UIAlertAction(title: "Remove Current Photo", style: .destructive) { (action) in
                self.removePhoto()
            }
            actionSheet.addAction(removeAction)
        }
        //2
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            self.captureImage()
        }
        actionSheet.addAction(takePhotoAction)
        //3
        let chooseFromLibraryAction = UIAlertAction(title: "Choose From Library", style: .default) { (action) in
            self.uploadImage()
        }
        actionSheet.addAction(chooseFromLibraryAction)
        //4
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        actionSheet.addAction(cancelAction)
        
    }
    @IBAction func phoneTapped(_ sender: Any) {
        self.view.endEditing(true)
        let storyboard = UIStoryboard(name: "ConsumerProfile", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "ConsumerUpdatePhoneVC") as! ConsumerUpdatePhoneVC
        vcObj.phoneNumber = (tf_Phone.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: ""))!
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
//    @IBAction func EmailTapped(_ sender: Any) {
//        self.view.endEditing(true)
//        let storyboard = UIStoryboard(name: "ConsumerProfile", bundle: nil)
//        let vcObj = storyboard.instantiateViewController(withIdentifier: "ConsumerUpdateEmailVC") as! ConsumerUpdateEmailVC
//        vcObj.email_address = tf_Email.text!
//        self.navigationController?.pushViewController(vcObj, animated: true)
//    }
    @IBAction func genderTapped(_ sender: Any) {
        self.view.endEditing(true)
        if view_PickerDate.isHidden == false {
            view_PickerDate.isHidden = true
        }
        if view_Picker.isHidden == false {
            view_Picker.isHidden = true
            return
        }
        view_Picker.isHidden = false
        picker_Options.reloadAllComponents()
        if tf_Gender.hasText {
            let index = array_Gender.index{ $0.name == tf_Gender.text }
            if index != nil{
                picker_Options.selectRow(index!, inComponent: 0, animated: true)
            }else {
                picker_Options.selectRow(0, inComponent: 0, animated: true)
            }
        }else {
            picker_Options.selectRow(0, inComponent: 0, animated: true)
        }
    }
    @IBAction func birthdateTapped(_ sender: Any) {
        self.view.endEditing(true)
        if view_Picker.isHidden == false {
            view_Picker.isHidden = true
        }
        if view_PickerDate.isHidden == false {
            view_PickerDate.isHidden = true
            return
        }
        view_PickerDate.isHidden = false
       if tf_BirthDate.hasText && tf_BirthDate.text != str_BirthdayPlaceholder {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd-MMM-yyyy"
        let date = dateFormatter.date(from: tf_BirthDate.text!)
        picker_Date.date = date!
        tf_BirthDate.text = dateFormatter.string(from: date!)
        }
    }
    @IBAction func cancelPickerOptionBarBtnTapped(_ sender: Any) {
        view_Picker.isHidden = true
    }
    @IBAction func selectPickerOptionsBarBtnTapped(_ sender: Any) {
        tf_Gender.text = array_Gender[picker_Options.selectedRow(inComponent: 0)].name
        user_Gender = array_Gender[picker_Options.selectedRow(inComponent: 0)].id
        view_Picker.isHidden = true
        self.isChangesMade = true
    }
    @IBAction func cancelDatePickerBarBtnTapped(_ sender: Any) {
        view_PickerDate.isHidden = true
    }
    @IBAction func selectDatePickerOptionsBarBtnTapped(_ sender: Any) {
        let dateFormatter = DateFormatter()
        //1
        //dateFormatter.dateFormat = "dd-MMM-yyyy"
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        tf_BirthDate.text = dateFormatter.string(from: picker_Date.date)
        //2
        dateFormatter.dateFormat = "yyyy-MM-dd"
        user_DOB = dateFormatter.string(from: picker_Date.date)
        
        view_PickerDate.isHidden = true
        self.isChangesMade = true
    }
}


//MARK:- UITextViewDelegate
extension CounsumerEditProfileVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.isChangesMade = true
        if view_Picker.isHidden == false {
            view_Picker.isHidden = true
        }
        if textView.tag == 1000 {
            if textView.text.caseInsensitiveCompare(str_StatusPlaceholder) == .orderedSame {
                textView.text = ""
            }
            lbl_Status.isHidden = false
            lbl_Status.textColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1)
            textView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 1000 {
            if textView.text == "" || textView.text?.trimmingCharacters(in: .whitespaces) == nil {
                textView.text = str_StatusPlaceholder.uppercased()
                lbl_Status.isHidden = true
                textView.textColor = #colorLiteral(red: 0.7663985491, green: 0.8196891546, blue: 0.9026022553, alpha: 1)
                lbl_StatusErrorLine.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.137254902, blue: 0.2941176471, alpha: 1)
            }else {
                lbl_Status.textColor = #colorLiteral(red: 0, green: 0.6166976094, blue: 1, alpha: 1)
                lbl_Status.isHidden = false
            }
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if(text == "\n") {
            if textView.tag == 1000 {
               // textView.resignFirstResponder()
                tf_Email.becomeFirstResponder()
            }
            return false
        }
        if textView.tag == 1000 {
            if newText.count > 0 {
                lbl_Status.isHidden = false
                lbl_Status.textColor = #colorLiteral(red: 0, green: 0.6166976094, blue: 1, alpha: 1)
                textView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).count > 2 {
            lbl_StatusErrorLine.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.137254902, blue: 0.2941176471, alpha: 1)
        }else {
            lbl_StatusErrorLine.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
}


//MARK:- UITextFieldDelegate
extension CounsumerEditProfileVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isChangesMade = true
        if view_Picker.isHidden == false {
            view_Picker.isHidden = true
        }
        else if textField == tf_Email {
           tf_Email.becomeFirstResponder()
            tf_Email.clearButtonMode = .never
        } else if textField == tf_fullName {
            tf_fullName.becomeFirstResponder()
            tf_fullName.clearButtonMode = .never
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tf_userName {
            _ = tf_fullName.becomeFirstResponder()
        }else if textField == tf_fullName {
            _ = text_Status.becomeFirstResponder()
        }else if textField == tf_Email {
            self.view.endEditing(true)
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var success : Bool!
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        /*if let title = textField.text  {
         if title.isEmpty && string == " " {
         return false
         }
         }*/
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        if textField == tf_userName {
            if (newString.count) == 0 || newString == "" {
                self.tf_userName.lineErrorColor = .red
                self.tf_userName.rightViewMode = .never
            }else {
                if (newString.count) < 3 {
                    self.tf_userName.lineErrorColor = .red
                    self.tf_userName.rightViewMode = .never
                }else {
                    self.tf_userName.lineErrorColor = .black
                    self.tf_userName.rightViewMode = .always
                }
            }
            let cs = NSCharacterSet(charactersIn: USERNAME).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            let isValidCharacters  = (string == filtered)
            success = isValidCharacters == true ? (newLength <= 70) : false
        }else if textField == tf_fullName {
            if (newString.count) == 0 || newString == "" {
                self.tf_fullName.lineErrorColor = .black
                self.tf_fullName.rightViewMode = .never
            }else {
                if (newString.count) < 3 {
                    self.tf_fullName.lineErrorColor = .red
                    self.tf_fullName.rightViewMode = .never
                }else {
                    self.tf_fullName.lineErrorColor = .black
                    self.tf_fullName.rightViewMode = .always
                }
            }
            /*let cs = NSCharacterSet(charactersIn: USERNAME).inverted
             let filtered = string.components(separatedBy: cs).joined(separator: "")
             let isValidCharacters  = (string == filtered)
             success = isValidCharacters == true ? (newLength <= 70) : false*/
            success = newLength > ConfigurationManager.CharacterLength.FullNameMaxLength.value ? false : true
           // success = (newLength <= 70)
        }else if textField == tf_Email {
            success = newLength > ConfigurationManager.CharacterLength.EmailLength.value ? false : true
        }else{
            success = true
        }
        return success
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == tf_userName {
            self.tf_userName.lineErrorColor = .black
            self.tf_userName.rightViewMode = .never
        }else if textField == tf_fullName {
            self.tf_fullName.lineErrorColor = .black
            self.tf_fullName.rightViewMode = .never
        }
        return true
    }
}

//MARK:- UIPicker View Delegate and Datasources
extension CounsumerEditProfileVC : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        /*var rowCount = Int()
         if selectedDropdown == "Country" {
         rowCount = array_Countries.count
         }else if selectedDropdown == "State" {
         rowCount = array_States.count
         }*/
        return array_Gender.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title : String = ""
        return title
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        label.textColor = UIColor.color(.textColor)
        label.textAlignment = .center
        label.font = UIFont(name: Constants.MEDIUM_FONT, size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.text = array_Gender[row].name
        return label
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}

//MARK: - TLPhotoPicker Controller Delegate
extension CounsumerEditProfileVC : TLPhotosPickerViewControllerDelegate {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        if withTLPHAssets.count > 0 {
            //uploadSelectedAssetToServer(asset: withTLPHAssets.first!)
            if withTLPHAssets.first!.fullResolutionImage != nil {
                self.capturedImage = withTLPHAssets.first!.fullResolutionImage!
                self.cropImage(image: self.capturedImage)
            }else {
                AlertController.SHOW_AUTOHIDE_MESSAGE(controller: self, message: "Error in fetching image", time: 1.0)
            }
        }
    }
    func photoPickerDidCancel() {
        print("TLPhotoPicker Cancelled")
    }
//    func uploadSelectedAssetToServer(asset: TLPHAsset) {
//        if let _ = asset.fullResolutionImage {
//            //print("file name",asset.phAsset?.location as Any)
//            asset.tempCopyMediaFile(convertLivePhotosToJPG: false, progressBlock: { (progress) in
//                print(progress)
//            }, completionBlock: { (url, mimeType) in
//                print("completion\(url)")
//                //*********File Size************
//                /*var filePath = String()
//                 filePath = url.absoluteString*/
//                let imageData = UIImageJPEGRepresentation(asset.fullResolutionImage!, 0.5)
//                let fileSize : Double = Double(imageData!.count)
//                let size = (fileSize/1000.0)/1000.0
//                if size > FILE_SIZE {
//                    AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: "Maximum file size: 10MB", btnTitle: "OK", viewController: self, completionHandler: { (success) in
//                    })
//                    return
//                }else {
//                    //****************
//                    // Upload File API
//                    self.callUploadUserImageToServer(fileData: imageData!, fileName: asset.originalFileName!, fileType: "image/png")
//                }
//            })
//        }
//    }
}

extension CounsumerEditProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - Image Controller Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let capturedImage = info[UIImagePickerController.InfoKey.originalImage]! as! UIImage
        self.capturedImage = capturedImage
        self.cropImage(image: capturedImage)
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- Crop View Controller Delegate
extension CounsumerEditProfileVC: CropViewControllerDelegate {
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
//
////MARK:- Api Call
extension CounsumerEditProfileVC {
//    @objc func callFetchUserProfile() {
//        store.callFetchUserProfile(showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
//            // your successful handle
//            if let response = success["response"] {
//                self.prefillUserData(dictionary: response as! NSDictionary)
//            }
//        }) { (failure) -> Void in
//            // your failure handle
//            if let value = failure["message"] {
//                self.showAlertWithMessage(message: (value as? String)!, title: "")
//                return
//            }else {
//                self.showAlertWithMessage(message: AlertController.AlertTitle.apiFailure.rawValue, title: "")
//                return
//            }
//        }
//    }
   
    @objc func callUpdateUserProfile(parameters: [String: Any]) {
    store.callWebserviceForUpdateConsumerProfile(parameters: parameters, showLoader: true, outhType: "",completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let response = success["response"] {
                print(response ?? "NR")
    KeychainWrapper.standard.set(self.profileImageUrl, forKey: "profile_image")
                self.consumerBasic?.bio = self.text_Status.text
                self.consumerBasic?.username = self.tf_userName.text!
                self.consumerBasic?.full_name = self.tf_fullName.text!
                self.consumerBasic?.user_media = self.profileImageUrl
                self.consumerBasic?.gender = String(self.user_Gender)
                self.consumerBasic?.dob = self.user_DOB
                self.consumerBasic?.reg_email_id = self.tf_Email.text!
                self.moveToPreviousController()
            }
        }) { (failure) -> Void in
            // your failure handle
            if let value = failure["message"] {
                self.showAlertWithMessage(message: (value as? String)!, title: "")
                return
            }else {
                self.showAlertWithMessage(message: AlertController.AlertTitle.apiFailure.rawValue, title: "")
                return
            }
        }
    }
//    func callUploadUserImageToServer(fileData: Data, fileName: String, fileType: String) {
//        store.callUploadUserProfileImageToServer(fileData: fileData, fileName: fileName, fileType: fileType, forKey: "resource", showLoader: true, completionBlockSuccess: { (respone) -> Void in
//            //Success block
//            print("success")
//            if (respone as! NSDictionary)["status"] as! Bool == true {
//                let apiResponse = respone["response"] as! NSDictionary
//                self.dict_Resource.setValue(apiResponse["id"], forKey: "id")
//                self.dict_Resource.setValue("profile_image", forKey: "name")
//                self.dict_Resource.setValue(true, forKey: "is_new")
//                self.img_User.image = self.capturedImage
//                print(self.dict_Resource)
//                self.isChangesMade = true
//            }else {
//                self.showAlertWithMessage(message: AlertController.AlertTitle.apiFailure.rawValue, title: "")
//            }
//        },andFailureBlock: { (failure) -> Void in
//            // your failure handle
//            if let value = failure["message"] {
//                self.showAlertWithMessage(message: (value as? String)!, title: "")
//                return
//            }else {
//                self.showAlertWithMessage(message: AlertController.AlertTitle.apiFailure.rawValue, title: "")
//                return
//            }
//        })
//    }
}
/*
 let str = "I have to #go to the #kitchen"
 let result:[String] =  str.components(separatedBy: " ").filter({$0.range(of: "#", options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil) != nil})
 print(result)
 */
