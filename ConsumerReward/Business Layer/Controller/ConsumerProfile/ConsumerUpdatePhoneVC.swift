//
//  ConsumerUpdatePhoneVC.swift
//  ConsumerReward
//
//  Created by apple on 08/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import UIKit
import SwiftPhoneNumberFormatter

class ConsumerUpdatePhoneVC: UIViewController {
    
    //MARK:- Variable Declaration
    var codeDropIconView: SidesView!
    let service = UserProfileServices()
    var phoneNumber = String()
    var dict_Localized = [String:String]()
    //MARK:- Outlet Connections
    @IBOutlet weak var btn_CountryCode: UIButton!
    @IBOutlet weak var tf_CountryCode: UITextField!
    @IBOutlet weak var tf_Phone: PhoneFormattedTextField!
    @IBOutlet weak var btn_Update: UIButton!
    var formatter = PhoneFormatter(rulesets: PNFormatRuleset.usHyphen())
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
         self.setLocalizedText()
        initialSetup()
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
    func setLocalizedText() {
        dict_Localized = GET_LOCALIZED_STRING_DICTIONARY(forClass: "Login")
        tf_Phone.placeholder = dict_Localized["labelMobileNumber"]
    }
    
    //MARK:- Keyboard Hiding
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //MARK:- Custom Methods
    func initialSetup() {
        tf_Phone.delegate = self
          tf_Phone.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "###-###-####")
        tf_Phone.formattedText = phoneNumber
       // addButtonOnNumericKeyboard()
    }
    func addButtonOnNumericKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIButton(type: .custom)
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.setTitleColor(#colorLiteral(red: 0.08028721064, green: 0.1908286512, blue: 0.3668289781, alpha: 1), for: .normal)
        doneBtn.titleLabel?.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: 15)
        doneBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
        doneBtn.addTarget(self, action: #selector(doneKeyboardBarButtonTapped), for: .touchUpInside)
        let barBtnItem = UIBarButtonItem(customView: doneBtn)
        doneToolbar.items = [flexSpace,barBtnItem]
        doneToolbar.sizeToFit()
        tf_Phone.inputAccessoryView = doneToolbar
    }
    @objc func doneKeyboardBarButtonTapped() {
        _ = tf_Phone.resignFirstResponder()
    }
    func showAlertWithMessage(message:String, title: String) {
        AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: title, message: message, btnTitle: "OK", viewController: self) { (success)
            in
        }
    }
    func moveToNextView() {
        let storyboard = UIStoryboard(name: "ConsumerProfile", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "ConsumerProfileConfirmationCodeVC") as! ConsumerProfileConfirmationCodeVC
        vcObj.mobileNumber = (tf_Phone.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: ""))!
        vcObj.countryCode = Constants.AREA_CODE
        vcObj.isVerifyPhone = true
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    //MARK:- Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "VerifyDetailsVC") {
            if let navController = segue.destination as? UINavigationController {
                if let destinationVC = navController.topViewController as? ConsumerProfileConfirmationCodeVC {
                    destinationVC.mobileNumber = tf_Phone.text!
                    destinationVC.field_type = "phone"
                    destinationVC.countryCode = ""
                }
            }
        }
    }
    //MARK:- Button Methods
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func updatePhoneTapped(_ sender: Any) {
       // self.moveToNextView()
        let mobileNo = tf_Phone.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        if phoneNumber == mobileNo {
            return
        }
        guard let _ = tf_Phone.text, mobileNo!.trimmingCharacters(in: .whitespaces).isEmpty == false && (mobileNo?.count)! >= 10 else{
            var message = ""
            if mobileNo?.count == 0 || mobileNo == "" {
                message = "Please enter your phone number"
            }else {
                message = "Please enter valid phone number"
            }
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: "OK", viewController: self, completionHandler: { (success) in
               // self.tf_Phone.lineErrorColor?.c
            })
            return
        }
        let parameters:  [String: Any] = [
            "country_code": Constants.AREA_CODE,
            "mobile_no": mobileNo!
        ]
        self.callUpdateUserPhoneNumber(parameters: parameters)
    }
}



//MARK:- UITextFieldDelegate
extension ConsumerUpdatePhoneVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var success : Bool!
        //var newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        /*if let title = textField.text  {
         if title.isEmpty && string == " " {
         return false
         }
         }*/
       // guard let text = textField.text else { return true }
       // let newLength = text.count + string.count - range.length
        if textField == tf_Phone , let text = textField.text {
            
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
            success = true
        }
        return success
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == tf_Phone {
            // self.tf_Phone.hideError()
            self.tf_Phone.rightViewMode = .never
        }
        return true
    }
}

//MARK:- API CALL
extension ConsumerUpdatePhoneVC {
    func callUpdateUserPhoneNumber(parameters : [String: Any] ) {
        service.callUpdateUserPhoneNumber(parameters: parameters, showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
                    self.moveToNextView()
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
}
