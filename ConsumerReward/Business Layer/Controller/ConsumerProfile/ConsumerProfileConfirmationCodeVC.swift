//
//  ConsumerProfileConfirmationCodeVC.swift
//  ConsumerReward
//
//  Created by apple on 08/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import UIKit
import PinCodeTextField
import SwiftPhoneNumberFormatter

class ConsumerProfileConfirmationCodeVC: UIViewController {
    
    //MARK:- Variable Declaration
    var counter = 60
    var timer_ResendCode  = Timer()
    @IBOutlet weak var lbl_Message: UILabel!
    var mobileNumber = String()
    var email = String()
    var field_type = String()
    var countryCode = String()
   // let service = UserProfileServices()
    var isVerifyPhone = Bool()
    var dict_Localized = [String:String]()
    //MARK:- Outlet Connections
    @IBOutlet var lbl_Timer: UILabel!
    @IBOutlet var btn_Resend: UIButton!
    @IBOutlet weak var pinCodeTextField: PinCodeTextField!
    @IBOutlet weak var lbl_ResendCode: UILabel!
     var formatter = PhoneFormatter(rulesets: PNFormatRuleset.usHyphen())
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalizedText()
        initialSetup()
        timer_ResendCode = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        btn_Resend.isUserInteractionEnabled = false
        self.pinCodeTextField.becomeFirstResponder()
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
    func initialSetup()  {
        pinCodeTextField.delegate = self
        pinCodeTextField.keyboardType = .numberPad
        let showKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(ShowKeyboard))
        pinCodeTextField.addGestureRecognizer(showKeyboardGesture)
        
//        //Show Phone Number
//        let temp_TextField = PhoneFormattedTextField(frame: .zero)
//        temp_TextField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "###-###-####")
//        temp_TextField.formattedText = mobileNumber
//        //
//        let phoneNumber = "\(ConfigurationManager.CountryCode.US.rawValue) \(temp_TextField.formattedText!)"
//        let completeMessage = "\(String(describing: dict_Localized["labelEnterOTP"]!)) \(phoneNumber)"
//        if let range = completeMessage.range(of: phoneNumber) {
//            let nsRange = NSRange(range, in: completeMessage)
//            let myMutableString = NSMutableAttributedString(string: completeMessage, attributes: [NSAttributedString.Key.font:UIFont(name: Constants.REGULAR_FONT, size: 15)!])
//            myMutableString.addAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.6166976094, blue: 1, alpha: 1), NSAttributedString.Key.font: UIFont(name: Constants.SEMI_BOLD_FONT, size: 15)!], range: nsRange)
//            lbl_Message.attributedText = myMutableString
//        }
        
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
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    //MARK:- Custom Methods
    func setLocalizedText() {
        dict_Localized = GET_LOCALIZED_STRING_DICTIONARY(forClass: "Otp")
        self.lbl_Message.text = dict_Localized["labelTitle"]?.uppercased()
      //  lbl_ResendCode.text = dict_Localized["labelResendOTP"]
    }
    
    @objc func updateCounter() {
        if counter > 0 {
            lbl_Timer.text =  String(counter) + " (s)"
            counter -= 1
        }else {
            lbl_Timer.isHidden = true
            timer_ResendCode.invalidate()
            btn_Resend.setTitleColor(UIColor.white, for: .normal)
            btn_Resend.isUserInteractionEnabled = true
        }
    }
    @objc func ShowKeyboard() {
        pinCodeTextField.becomeFirstResponder()
    }
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    @objc func moveToNextView() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is CounsumerEditProfileVC {
                NOTIFICATIONCENTER.post(name: NSNotification.Name("UpdateDetails"), object: nil)
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }
    func showAlertWithMessage(message:String, title: String) {
        AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: title, message: message, btnTitle: "OK", viewController: self) { (success)
            in
            self.pinCodeTextField.text = ""
            self.pinCodeTextField.becomeFirstResponder()
        }
    }
    //MARK:- Button Methods
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func resendCodeButtonTapped(_ sender: UIButton) {
        pinCodeTextField.text = ""
        pinCodeTextField.becomeFirstResponder()
        lbl_Timer.isHidden = false
        btn_Resend.isUserInteractionEnabled = false
        btn_Resend.setTitleColor(UIColor.lightGray, for: .normal)
        timer_ResendCode.invalidate()
        counter = 59
        lbl_Timer.text = "60 (s)"
        timer_ResendCode = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
}

//MARK:- PinCodeTextFieldDelegate
extension ConsumerProfileConfirmationCodeVC: PinCodeTextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
    }
    func textFieldValueChanged(_ textField: PinCodeTextField) {
        let value = textField.text ?? ""
        if value.count == 6 {
             self.countryCode = Constants.AREA_CODE
            if field_type == "email" {
                let parameters:  [String: Any] = [
                    "field_type": field_type,
                    "field_val": email,
                    "secure_code": pinCodeTextField.text!
                ]
                self.callVerifyOTP(parameters: parameters)
            } else {
                let parameters:  [String: Any] = [
                    "field_type": field_type,
                    "field_val": mobileNumber,
                    "secure_code": pinCodeTextField.text!
                ]
                self.callVerifyOTP(parameters: parameters)
            }
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
extension ConsumerProfileConfirmationCodeVC {
    func callVerifyOTP(parameters : [String: Any] ) {
         let service = UserProfileServices()
        service.callVerifyOTPAPI(parameters: parameters, isLogin: false, completionBlockSuccess: { (success)
            -> Void in
            // your successful handle
            self.timer_ResendCode.invalidate()
           
            if self.field_type == "email" {
        KeychainWrapper.standard.set(self.email, forKey: "email")
             } else {
        KeychainWrapper.standard.set(self.mobileNumber, forKey: "registered_mobile")
            }
        KeychainWrapper.standard.set(self.countryCode, forKey: "registered_mobile_area_code")
            self.moveToNextView()
        }) { (failure) -> Void in
            // your failure handle

            self.pinCodeTextField.text = ""
            self.pinCodeTextField.becomeFirstResponder()
            self.handleAPIError(failure: failure)
        }
    }
}


