//  Created by apple on 7/19/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit
import PinCodeTextField

class OTPVerificationVC: UIViewController {
    //MARK:- Variable Declaration
    var counter = 60
    var timer_ResendCode  = Timer()
    var mobileNumber = String()
    var countryCode = String()
    let account = Network.currentAccount
    var dict_Localized = [String:String]()
    var formatter = PhoneFormatter(rulesets: PNFormatRuleset.usHyphen())
    var remainingAttempts: Int = 5
    var isMaxAttemptsReached = false
    
    //MARK:- Outlet Connections
    @IBOutlet var lbl_Timer: UILabel!
    @IBOutlet weak var lbl_ResendCode: UILabel!
    @IBOutlet var btn_Resend: UIButton!
    @IBOutlet weak var tf_Code: PinCodeTextField!
    @IBOutlet weak var view_Resend: UIView!
    @IBOutlet weak var lbl_Message: UILabel!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalizedText()
        self.initialSetup()
        self.enableDisableResentBtn(isEnabled: false)
        self.tf_Code.becomeFirstResponder()
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
    
    //MARK:- Custom Methods
    func setLocalizedText() {
        dict_Localized = GET_LOCALIZED_STRING_DICTIONARY(forClass: "Otp")
        self.lbl_Message.text = dict_Localized["labelTitle"]?.uppercased()
        lbl_ResendCode.text = dict_Localized["labelResendOTP"]
    }
    func initialSetup()  {
        tf_Code.text = ""
        tf_Code.delegate = self
        tf_Code.keyboardType = .numberPad
        let showKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(ShowKeyboard))
        tf_Code.addGestureRecognizer(showKeyboardGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        
        //Show Phone Number
        let formattedText = self.formatter.format(number: mobileNumber)
        let phoneNumber = "\(ConfigurationManager.CountryCode.US.rawValue) \(formattedText)"
        let completeMessage = "\(String(describing: dict_Localized["labelEnterOTP"]!)) \(phoneNumber)"
        if let range = completeMessage.range(of: phoneNumber) {
            let nsRange = NSRange(range, in: completeMessage)
            let myMutableString = NSMutableAttributedString(string: completeMessage, attributes: [NSAttributedString.Key.font:UIFont(name: Constants.REGULAR_FONT, size: 15)!])
            myMutableString.addAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.6166976094, blue: 1, alpha: 1), NSAttributedString.Key.font: UIFont(name: Constants.SEMI_BOLD_FONT, size: 15)!], range: nsRange)
            lbl_Message.attributedText = myMutableString
        }
    }
    @objc func updateCounter() {
        if counter > 0 {
            lbl_Timer.text =  String(counter) + " (s)"
            counter -= 1
        }else {
            self.enableDisableResentBtn(isEnabled: true)
        }
    }
    @objc func enableUserToEnterCode() {
        self.tf_Code.isUserInteractionEnabled = true
        self.tf_Code.text = ""
        self.tf_Code.becomeFirstResponder()
        
        self.enableDisableResentBtn(isEnabled: true)
        btn_Resend.isHidden = false
    }
    @objc func ShowKeyboard() {
        tf_Code.becomeFirstResponder()
    }
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    func callCodeVerificationAPI() {
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
            "device_token": UserdefaultStore.USERDEFAULTS_GET_STRING_KEY(key: "DeviceToken"),
            "app_version": "1.0",
            "device_type": "ios",
            "device_id": "",
            "otp": tf_Code.text!,
            "country_code": ConfigurationManager.CountryCode.US.rawValue,
            "mobile_no": mobileNumber
        ]
        self.callVerifyOTP(parameters: parameters)
    }
    @objc func moveToNextView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "UserInterestsVC") as! UserInterestsVC
        vcObj.mobileNumber = self.mobileNumber
        vcObj.isSocialLogin = false
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    func enableDisableResentBtn(isEnabled: Bool, _ time: Int = 59) {
        if isEnabled == true {
            lbl_Timer.isHidden = true
            timer_ResendCode.invalidate()
            lbl_ResendCode.textColor = .white
            btn_Resend.isUserInteractionEnabled = true
            isMaxAttemptsReached = false
            self.remainingAttempts = 5
        }else {
            btn_Resend.isUserInteractionEnabled = false
            lbl_ResendCode.textColor = .lightGray
            lbl_Timer.isHidden = false
            if timer_ResendCode.isValid {
                timer_ResendCode.invalidate()
            }
            counter = time
            lbl_Timer.text = "\(counter) (s)"
            timer_ResendCode = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        }
    }
    //MARK:- Button Methods
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func resendCodeButtonTapped(_ sender: UIButton) {
        tf_Code.text = ""
        let parameters:  [String: Any] = [
            "country_code": ConfigurationManager.CountryCode.US.rawValue.replacingOccurrences(of: "+", with: ""),
            "mobile_no": mobileNumber
        ]
        self.callResendOTP(parameters: parameters)
    }
    @IBAction func nextTapped(_ sender: Any) {
        //self.moveToNextView()
        self.callCodeVerificationAPI()
    }
}

//MARK:- PinCodeTextFieldDelegate
extension OTPVerificationVC: PinCodeTextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
    }
    func textFieldValueChanged(_ textField: PinCodeTextField) {
        let value = textField.text ?? ""
        if value.count == ConfigurationManager.CharacterLength.LoginVerficationCode.value {
            callCodeVerificationAPI()
        }
    }
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        return true
    }
}

//MARK:- API CALL
extension OTPVerificationVC {
    func callVerifyOTP(parameters : [String: Any] ) {
        let service = LoginServices()
        service.callVerifyOTPAPI(parameters: parameters, isLogin: false, completionBlockSuccess: { (success)
            -> Void in
            // your successful handle
            if let attempts = success["remaining_attempts"] as? Int {
                self.remainingAttempts = attempts
                if let msg = success["message"] as? String {
                    AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: msg, btnTitle: "OK", viewController: self, completionHandler: { (success) in
                        if self.remainingAttempts <= 0 && self.isMaxAttemptsReached == false {
                            self.isMaxAttemptsReached = true
                            self.enableDisableResentBtn(isEnabled: false, 299)
                        }
                        self.tf_Code.text = ""
                        self.tf_Code.becomeFirstResponder()
                    })
                }
                return
            }
            FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.signUp, category: FirAnalytics.Category.signUp, label: FirAnalytics.Label.signupVerify_code_success, action: FirAnalytics.Actions.otpBtn, value: 1)
            self.timer_ResendCode.invalidate()
            self.moveToNextView()
        }) { (failure) -> Void in
            FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.signUp, category: FirAnalytics.Category.signUp, label: FirAnalytics.Label.signupVerify_code_success, action: FirAnalytics.Actions.otpBtn, value: 0)
            // your failure handle
            self.tf_Code.text = ""
            self.tf_Code.becomeFirstResponder()
            self.handleAPIError(failure: failure)
        }
    }
    func callResendOTP(parameters: [String:Any]) {
        let service = LoginServices()
        service.callRegisterUserAPI(parameters: parameters, showLoader: true, completionBlockSuccess: { (success) -> Void in
            // your successful handle
            //FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.login, category: FirAnalytics.Category.login, label: FirAnalytics.Label.login_OTP, action: FirAnalytics.Actions.loginOTPBtn, value: 1)
            self.tf_Code.text = ""
            self.tf_Code.becomeFirstResponder()
            self.enableDisableResentBtn(isEnabled: false)
        }) { (failure) -> Void in
            // your failure handle
            //FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.login, category: FirAnalytics.Category.login, label: FirAnalytics.Label.login_OTP, action: FirAnalytics.Actions.loginOTPBtn, value: 0)
            self.handleAPIError(failure: failure)
        }
    }
}



