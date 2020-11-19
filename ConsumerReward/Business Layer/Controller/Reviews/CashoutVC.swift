//  Created by Navpreet on 18/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.

import UIKit

class CashoutVC: UIViewController {
    //MARK:- Variable Declaration
    var cashoutBalance = Float()
    //MARK:- Outlet Connections
    @IBOutlet weak var lbl_CashoutBalance: UILabel!
    @IBOutlet weak var lbl_Balance: UILabel!
    @IBOutlet weak var tf_Email: UITextField!
    @IBOutlet weak var lbl_Message: UILabel!
    @IBOutlet weak var btn_Cashout: UIButton!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        self.initialSetup()
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
    //MARK:- Keyboard hide Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //MARK:- Custom Methods
    func initialSetup() {
        
    }
    func setupData() {
        if self.cashoutBalance == 0 {
            btn_Cashout.isUserInteractionEnabled = false
            tf_Email.isUserInteractionEnabled = false
        }else {
            btn_Cashout.isUserInteractionEnabled = true
            tf_Email.isUserInteractionEnabled = true
        }
        lbl_CashoutBalance.text = formatPriceToTwoDecimalPlace(amount: self.cashoutBalance)
        lbl_Message.text = "$5.00 MINIMUM BALANCE TO CASHOUT.\nYOUR REQUEST WILL BE PROCESSED WITHIN\n 5 BUSINESS DAYS."
    }

    //MARK:- Button Methods
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func cashoutTapped(_ sender: Any) {
        self.view.endEditing(true)
        guard let _ = tf_Email.text, tf_Email.text?.isEmpty == false &&  Validations.isValidEmailAddress(emailId: tf_Email.text ?? "") == true else{
            var message = ""
            if tf_Email.text?.count == 0 || tf_Email.text == "" {
                message = "Email Address is required"
            }else {
                message = "Please enter valid email format"
            }
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: "OK", viewController: self, completionHandler: { (success) in
                self.tf_Email.becomeFirstResponder()
            })
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- UITextFieldDelegate
extension CashoutVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var success : Bool! = true
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        if textField == tf_Email {
            success = newLength > ConfigurationManager.CharacterLength.EmailLength.value ? false : true
        }
        return success
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
