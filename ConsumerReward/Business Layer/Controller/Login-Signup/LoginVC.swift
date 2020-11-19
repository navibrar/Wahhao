//  Created by Navpreet on 29/11/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import UIKit
import FacebookCore
import FacebookLogin

class LoginVC: UIViewController {
    //MARK:- Variable Declaration
    var dict_Localized = [String:String]()
    var isLogin = false
    var formatter = PhoneFormatter(rulesets: PNFormatRuleset.usHyphen())
    //MARK:- Outlet Connections
    @IBOutlet weak var segment_LoginOptions: HBSegmentedControl!
    @IBOutlet weak var constraint_ViewContentHeight: NSLayoutConstraint!
    @IBOutlet weak var tf_PhoneNumber: UITextField!
    @IBOutlet weak var tf_Code: UITextField!
    @IBOutlet weak var btn_GetCode: UIButton!
    @IBOutlet weak var btn_GetStarted: UIButton!
    @IBOutlet weak var btn_ContinueWithFacebook: UIButton!
    @IBOutlet weak var lbl_OR: UILabel!
    @IBOutlet weak var view_Code: UIView!
    @IBOutlet weak var constraint_CodeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constraint_CodeViewTop: NSLayoutConstraint!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalizedText()
        self.initialSetup()
        ADD_DONE_BUTTON_TO_TOOLBAR(textField: tf_PhoneNumber)
        ADD_DONE_BUTTON_TO_TOOLBAR(textField: tf_Code)
        
        //SWIPE GESTURES
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        segment_LoginOptions.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        segment_LoginOptions.addGestureRecognizer(swipeRight)
        self.setUpSignupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
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
                if segment_LoginOptions.selectedIndex == 1 {
                    segment_LoginOptions.selectedIndex = 0
                    setUpSignupView()
                }
            case UISwipeGestureRecognizer.Direction.right:
                print("move Right")
                if segment_LoginOptions.selectedIndex == 0 {
                    segment_LoginOptions.selectedIndex = 1
                    setUpLoginView()
                }
            default:
                break
            }
        }
    }
    //MARK:- Keyboard Hide Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:- Custom Methods
    func setLocalizedText() {
        dict_Localized = GET_LOCALIZED_STRING_DICTIONARY(forClass: "Login")
        tf_PhoneNumber.placeholder = dict_Localized["labelMobileNumber"]
        tf_Code.placeholder = dict_Localized["labelCode"]
        lbl_OR.text = dict_Localized["labelOr"]
        btn_GetStarted.setTitle(dict_Localized["labelGetStarted"], for: .normal)
        btn_ContinueWithFacebook.setTitle(dict_Localized["labelContinueWithFacebook"], for: .normal)
        btn_GetCode.setTitle(dict_Localized["labelGetCode"], for: .normal)
    }
    func initialSetup() {
        //Enable scrolling for small devices to show complete view
        if UIDevice().SCREEN_TYPE == .iPhone4 || UIDevice().SCREEN_TYPE == .iPhone5E || UIDevice().SCREEN_TYPE == .iPhone8{
            constraint_ViewContentHeight.constant = 100
        }
        segment_LoginOptions.items = [dict_Localized["labelSignUp"], dict_Localized["labelLogin"]] as! [String]
        segment_LoginOptions.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: 11)
        segment_LoginOptions.borderColor = .white
        segment_LoginOptions.addTarget(self, action: #selector(LoginVC.segmentValueChanged(_:)), for: .valueChanged)
        self.setUpSignupView()
    }
    
    @objc func segmentValueChanged(_ sender: AnyObject?){
        if segment_LoginOptions.selectedIndex == 0 {
            self.setUpSignupView()
        }else if segment_LoginOptions.selectedIndex == 1{
            self.setUpLoginView()
        }
    }
    func setUpLoginView() {
        self.view.endEditing(true)
        isLogin = true
        self.view_Code.isHidden = false
        self.constraint_CodeViewTop.constant = 16
        self.constraint_CodeViewHeight.constant = 45
        self.btn_ContinueWithFacebook.setTitle(dict_Localized["labelLoginWithFacebook"], for: .normal)
        FirAnalytics.trackPageView(withScreen: FirAnalytics.Screen.login)
    }
    func setUpSignupView() {
        self.view.endEditing(true)
        isLogin = false
        self.view_Code.isHidden = true
        self.constraint_CodeViewTop.constant = 0
        self.constraint_CodeViewHeight.constant = 0
        self.btn_ContinueWithFacebook.setTitle(dict_Localized["labelContinueWithFacebook"], for: .normal)
        FirAnalytics.trackPageView(withScreen: FirAnalytics.Screen.signUp)
    }
    func moveToVerificationCodeVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
        vcObj.mobileNumber = (tf_PhoneNumber.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: ""))!
        vcObj.countryCode = ConfigurationManager.CountryCode.US.rawValue
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    @objc func moveToDashboard() {
        if Login.loadCustomerInfoFromKeychain()?.has_username == true {
            let checkout = CheckoutServices.sharedInstance
            checkout.removeUserStoredDataFromCheckout()
            
            let storyboard = UIStoryboard(name: "ProjectStoryboard", bundle: nil)
            let vcObj = storyboard.instantiateViewController(withIdentifier: "HomePostViewController") as! HomePostViewController
            let navController = UINavigationController(rootViewController: vcObj)
            self.show(navController, sender: self)
        }else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vcObj = storyboard.instantiateViewController(withIdentifier: "UserInterestsVC") as! UserInterestsVC
            vcObj.mobileNumber = (tf_PhoneNumber.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: ""))!
            vcObj.isSocialLogin = false
            self.navigationController?.pushViewController(vcObj, animated: true)
        }
    }
    func moveToUserInterestScreenFromFacebookLogin(dict: [String:Any]) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "UserInterestsVC") as! UserInterestsVC
        vcObj.mobileNumber = ""
        vcObj.fullName = dict["name"] as? String ?? ""
        vcObj.facebookId = dict["id"] as? String ?? ""
        vcObj.isSocialLogin = true
        if let picture = dict["picture"] as? NSDictionary {
            if let userImage = picture["data"] as? NSDictionary {
                vcObj.profileImageUrl = userImage["url"] as? String ?? ""
            }
        }
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    func signUPViewValidations() {
        self.view.endEditing(true)
        let phoneNumber = tf_PhoneNumber.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        
        guard let _ = tf_PhoneNumber.text, phoneNumber?.trimmingCharacters(in: .whitespaces).isEmpty == false && (phoneNumber?.count)! >= ConfigurationManager.CharacterLength.PhoneNumberLengthUS.value else{
            var message = ""
            if phoneNumber?.count == 0 || phoneNumber == "" {
                message = dict_Localized["errorEnterPhoneNumber"]!
            }else {
                message = dict_Localized["errorEnterValidPhoneNumber"]!
            }
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: "OK", viewController: self, completionHandler: { (success) in
                self.tf_PhoneNumber.becomeFirstResponder()
            })
            return
        }
        let parameters:  [String: Any] = [
            "device_token":UserdefaultStore.USERDEFAULTS_GET_STRING_KEY(key: "DeviceToken"),
            "app_version":"1.0",
            "device_type":"ios",
            "device_id":"",
            "country_code": ConfigurationManager.CountryCode.US.rawValue.replacingOccurrences(of: "+", with: ""),
            "mobile_no": phoneNumber!
        ]
        self.callUserSignUpAPI(parameters: parameters)
    }
    func generateOTPValidations() {
        self.view.endEditing(true)
        var phoneNumber = ""
        phoneNumber = (tf_PhoneNumber.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: ""))!
        guard let _ = tf_PhoneNumber.text, phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty == false && (phoneNumber.count) >= ConfigurationManager.CharacterLength.PhoneNumberLengthUS.value else{
            var message = ""
            if phoneNumber.count == 0 || phoneNumber == "" {
                message = dict_Localized["errorEnterPhoneNumber"]!
            }else {
                message = dict_Localized["errorEnterValidPhoneNumber"]!
            }
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: "OK", viewController: self, completionHandler: { (success) in
                self.tf_PhoneNumber.becomeFirstResponder()
            })
            return
        }
        let parameters:  [String: Any] = [
            "country_code": ConfigurationManager.CountryCode.US.rawValue.replacingOccurrences(of: "+", with: ""),
            "mobile_no": phoneNumber
        ]
        self.callGenerateOTPForLogin(parameters: parameters)
    }
    func verificationCodeValidations() {
        self.view.endEditing(true)
        var phoneNumber = ""
        phoneNumber = (tf_PhoneNumber.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: ""))!
        guard let _ = tf_PhoneNumber.text, phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty == false && (phoneNumber.count) >= ConfigurationManager.CharacterLength.PhoneNumberLengthUS.value else{
            var message = ""
            if phoneNumber.count == 0 || phoneNumber == "" {
                message = dict_Localized["errorEnterPhoneNumber"]!
            }else {
                message = dict_Localized["errorEnterValidPhoneNumber"]!
            }
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: "OK", viewController: self, completionHandler: { (success) in
                self.tf_PhoneNumber.becomeFirstResponder()
            })
            return
        }
        
        guard let _ = tf_Code.text, tf_Code.text!.trimmingCharacters(in: .whitespaces).isEmpty == false && (tf_Code.text?.count)! == ConfigurationManager.CharacterLength.LoginVerficationCode.value else{
            var message = ""
            if tf_Code.text?.count == 0 || tf_Code.text == "" {
                message = dict_Localized["errorEnterOTP"]!
            }else {
                message = dict_Localized["errorEnterValidVarificationCode"]!
            }
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: "OK", viewController: self, completionHandler: { (success) in
                self.tf_Code.becomeFirstResponder()
            })
            return
        }
        
        let parameters:  [String: Any] = [
            "country_code": ConfigurationManager.CountryCode.US.rawValue.replacingOccurrences(of: "+", with: ""),
            "mobile_no": phoneNumber,
            "device_token": UserdefaultStore.USERDEFAULTS_GET_STRING_KEY(key: "DeviceToken"),
            "otp": tf_Code.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        ]
        self.callVerifyOTP(parameters: parameters)
    }
    //MARK:- Facebook Methods
    func loginManagerDidComplete(_ result: LoginResult) {
        switch result {
        case .cancelled:
            print("User cancelled login")
        case .failed(let error):
            print("FB Login Failed; \(error.localizedDescription)")
        case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            print("Granted Permissions: %@\nDeclined Permissions: %@\nAccess Token: %@",grantedPermissions, declinedPermissions, accessToken)
            self.getLoggedInUserDataFromFacebook()
        }
    }
    //Fetching the user data from Facebook
    func getLoggedInUserDataFromFacebook() {
        let request = GraphRequest(graphPath: "/me",
                                   parameters: ["fields": "id, name, picture.type(large)"],
                                   httpMethod: .GET)
        request.start { _, result in
            switch result {
            case .success(let response):
                print("Graph Request Succeeded: \(response)")
                if let userDetails = response.dictionaryValue {
                    print(userDetails)
                    FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.login, category: FirAnalytics.Category.login, label: FirAnalytics.Label.login_FB_CTA_success, action: FirAnalytics.Actions.loginOTPBtn, value: 1)
                    self.callCheckIfFacebookUserIsRegistered(dict: userDetails)
                }
            case .failed(let error):
                FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.login, category: FirAnalytics.Category.login, label: FirAnalytics.Label.login_FB_CTA_success, action: FirAnalytics.Actions.loginOTPBtn, value: 0)
                print("Graph Request Failed: \(error)")
            }
        }
    }
    
    //MARK:- Button Methods
    @IBAction func getCodeTapped(_ sender: Any) {
        self.generateOTPValidations()
    }
    @IBAction func getStartedTapped(_ sender: Any) {
        if isLogin == true {
            self.verificationCodeValidations()
        }else {
            self.signUPViewValidations()
        }
    }
    @IBAction func continueWithFacebookTapped(_ sender: Any) {
        self.view.endEditing(true)
        //User is already logged in
        if let accessToken = AccessToken.current {
            print(accessToken.appId)
            self.getLoggedInUserDataFromFacebook()
            return
        }
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .userFriends], viewController: self) { result in
            self.loginManagerDidComplete(result)
        }
    }
}

//MARK:- UITextFieldDelegate
extension LoginVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        if textField == tf_Code {
            return  (newLength <= ConfigurationManager.CharacterLength.LoginVerficationCode.value)
        }else if textField == tf_PhoneNumber, let text = textField.text {
            
            // get current text + new character being entered
            var newStr = text + string
            
            // check if this is a backspace
            let isDeleting = (range.length > 0) && string.isEmpty
            if isDeleting == true {
                // trim last char for correct validation
                newStr.remove(at: newStr.index(before: newStr.endIndex))
            }
            
            // strip non-numeric characters
            var numberString = ""
            //To check string only contains number
            newStr = newStr.components(separatedBy: "-").joined(separator: "")
            if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: newStr)) == true {
                //Phone number typed from keyboard
                numberString = newStr.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                // 10 character limit
                if numberString.count > 10 {
                    return false
                }
            }else {
                //Phone number picked from predictive suggestion
                numberString = newStr.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                if numberString.count > 10 {
                    numberString = String(numberString.suffix(10))
                }
                // 10 character limit
                if numberString.count > 10 {
                    return false
                }
            }
            // don't update the field if formatting hasn't changed
            DispatchQueue.main.async {
                textField.text = ""
                let formatted = self.formatter.format(number: numberString)
                textField.text = formatted
            }
        }else{
            return true
        }
        return true
    }
}

// MARK: API CALLS
extension LoginVC {
    func callUserSignUpAPI(parameters: [String:Any]) {
        let service = LoginServices()
        service.callRegisterUserAPI(parameters: parameters, showLoader: true, completionBlockSuccess: { (success) -> Void in
            // your successful handle
            FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.signUp, category: FirAnalytics.Category.signUp, label: FirAnalytics.Label.signup_CTA_success, action: FirAnalytics.Actions.signUpBtn, value: 1)
            if let value = success["message"] {
                print(value ?? "")
                if (parameters["country_code"] as! String) == "86" {
                    KeychainWrapper.standard.set("en", forKey: "Language")
                }else {
                    KeychainWrapper.standard.set("en", forKey: "Language")
                }
                self.moveToVerificationCodeVC()
            }
        }) { (failure) -> Void in
            // your failure handle
            FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.signUp, category: FirAnalytics.Category.signUp, label: FirAnalytics.Label.signup_CTA_success, action: FirAnalytics.Actions.signUpBtn, value: 0)
            self.handleAPIError(failure: failure)
        }
    }
    
    func callGenerateOTPForLogin(parameters: [String:Any]) {
        let service = LoginServices()
        service.callGenerateOTPAPI(parameters: parameters, showLoader: true, completionBlockSuccess: { (success) -> Void in
            // your successful handle
            FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.login, category: FirAnalytics.Category.login, label: FirAnalytics.Label.login_OTP, action: FirAnalytics.Actions.loginOTPBtn, value: 1)
            if let value = success["message"] {
                print(value ?? "")
            }
        }) { (failure) -> Void in
            // your failure handle
            FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.login, category: FirAnalytics.Category.login, label: FirAnalytics.Label.login_OTP, action: FirAnalytics.Actions.loginOTPBtn, value: 0)
            self.handleAPIError(failure: failure)
        }
    }
    func callVerifyOTP(parameters : [String: Any] ) {
        let service = LoginServices()
        service.callVerifyOTPAPI(parameters: parameters, isLogin: true, completionBlockSuccess: { (success)
            -> Void in
            // your successful handle
            FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.login, category: FirAnalytics.Category.login, label: FirAnalytics.Label.login_Verify_code, action: FirAnalytics.Actions.loginOTPBtn, value: 1)
            FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.login, category: FirAnalytics.Category.login, label: FirAnalytics.Label.login_CTA_success, action: FirAnalytics.Actions.loginOTPBtn, value: 1)
            self.moveToDashboard()
        }) { (failure) -> Void in
            // your failure handle
            FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.login, category: FirAnalytics.Category.login, label: FirAnalytics.Label.login_Verify_code, action: FirAnalytics.Actions.loginOTPBtn, value: 0)
            FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.login, category: FirAnalytics.Category.login, label: FirAnalytics.Label.login_CTA_success, action: FirAnalytics.Actions.loginOTPBtn, value: 0)
            self.handleAPIError(failure: failure)
        }
    }
    func callCheckIfFacebookUserIsRegistered(dict:[String:Any]) {
        let parameters:  [String: Any] = [
            "country_code": ConfigurationManager.CountryCode.US.rawValue.replacingOccurrences(of: "+", with: ""),
            "social_id": dict["id"] ?? ""
        ]
        let service = LoginServices()
        service.callVerifySocialLoginRegisterAPi(parameters: parameters, isLogin: true, completionBlockSuccess: { (success)
            -> Void in
            print(success)
            // your successful handle
            self.moveToDashboard()
        }) { (failure) -> Void in
            // your failure handle
            if let isUserRegistered = failure["socialaccount_status"] as? Bool {
                if isUserRegistered == false {
                    self.moveToUserInterestScreenFromFacebookLogin(dict: dict)
                }else {
                    self.handleAPIError(failure: failure)
                }
            }else {
                self.handleAPIError(failure: failure)
            }
        }
    }
}
