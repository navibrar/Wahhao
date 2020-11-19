//
//  ConsumerUpdateEmailVC.swift
//  ConsumerReward
//
//  Created by apple on 31/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.
//

import UIKit

class ConsumerUpdateEmailVC: UIViewController {
     var email_address = String()
    let service = UserProfileServices()
    @IBOutlet weak var tf_email: UITextField!
    var dict_Localized = [String:String]()
     @IBOutlet weak var btn_Update: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalizedText()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    //MARK:- Button Methods
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func setLocalizedText() {
        dict_Localized = GET_LOCALIZED_STRING_DICTIONARY(forClass: "Login")
        // tf_email.placeholder = dict_Localized["labelMobileNumber"]
    }
    
    //MARK:- Keyboard Hiding
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //MARK:- Custom Methods
    func initialSetup() {
        tf_email.text = email_address
        // addButtonOnNumericKeyboard()
    }
    func moveToNextView() {
        let storyboard = UIStoryboard(name: "ConsumerProfile", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "ConsumerProfileConfirmationCodeVC") as! ConsumerProfileConfirmationCodeVC
        vcObj.email = (tf_email.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: ""))!
        vcObj.countryCode = Constants.AREA_CODE
        vcObj.email = tf_email.text!
        vcObj.field_type = "email"
        vcObj.isVerifyPhone = true
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    //MARK:- Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "VerifyDetailsVC") {
            if let navController = segue.destination as? UINavigationController {
                if let destinationVC = navController.topViewController as? ConsumerProfileConfirmationCodeVC {
                    destinationVC.email = tf_email.text!
                    destinationVC.field_type = "email"
                    destinationVC.countryCode = ""
                }
            }
        }
    }
    @IBAction func updateEmailTapped(_ sender: Any) {
        self.view.endEditing(true)
        guard let _ = tf_email.text, tf_email.text?.isEmpty == false &&  Validations.isValidEmailAddress(emailId: tf_email.text ?? "") == true else{
            var message = ""
            if tf_email.text?.count == 0 || tf_email.text == "" {
                message = "Email Address is required"
            }else {
                message = "Please enter valid email format"
            }
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: "OK", viewController: self, completionHandler: { (success) in
                self.tf_email.becomeFirstResponder()
            })
            return
        }
        let parameters:  [String: Any] = [
            "email": tf_email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        ]
        self.callUpdateemail(parameters: parameters)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//MARK:- API CALL
extension ConsumerUpdateEmailVC {
    func callUpdateemail(parameters : [String: Any] ) {
        service.callUpdateUseremail(parameters: parameters, showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            self.moveToNextView()
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
}
