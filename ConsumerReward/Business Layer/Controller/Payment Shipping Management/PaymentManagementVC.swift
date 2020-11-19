//  Created by Navpreet on 20/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit
import Stripe

class PaymentManagementVC: UIViewController {
    
    //MARK:- Variable Declaration
    let checkoutService = CheckoutServices.sharedInstance
    let paymentTextField = STPPaymentCardTextField()
    
    
    //MARK:- Outlet Connections
    @IBOutlet weak var view_Payment: UIView!
    @IBOutlet weak var btn_Save: UIBarButtonItem!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    //MARK:- Custom Methods
    func initialSetup() {
        view_Payment.backgroundColor = .clear
        btn_Save.title = ""
        
        paymentTextField.frame = CGRect(x: view_Payment.bounds.origin.x, y: view_Payment.bounds.origin.y, width: self.view.bounds.width-32, height: view_Payment.bounds.height)
        paymentTextField.layer.cornerRadius = 22.5
        paymentTextField.clipsToBounds = true
        paymentTextField.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.137254902, blue: 0.2549019608, alpha: 1)
        paymentTextField.layer.borderWidth = 2.0
        paymentTextField.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.1882352941, blue: 0.3333333333, alpha: 1)
        paymentTextField.textColor = #colorLiteral(red: 0.7663985491, green: 0.8196891546, blue: 0.9026022553, alpha: 1)
        paymentTextField.placeholderColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1)
        paymentTextField.numberPlaceholder = "CARD NUMBER"
        paymentTextField.delegate = self
        view_Payment.addSubview(paymentTextField)
        self.paymentTextField.becomeFirstResponder()
    }
    
    //MARK:- Button Methods
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveTapped(_ sender: Any) {
        if paymentTextField.isValid {
            self.btn_Save.isEnabled = false
            self.createStripeTokenToChargeCard()
        }
    }
}

// MARK: STPPaymentCardTextFieldDelegate
extension PaymentManagementVC: STPPaymentCardTextFieldDelegate {
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        // Toggle buy button state
        print(textField.cardNumber ?? "No Card Number")
        if textField.isValid {
            textField.resignFirstResponder()
            btn_Save.isEnabled = true
            btn_Save.title = "Save"
        }else {
            btn_Save.isEnabled = false
            btn_Save.title = ""
        }
    }
    func createStripeTokenToChargeCard() {
        DispatchQueue.main.async {
            showActivityIndicator()
        }
        let cardParams = STPCardParams()
        cardParams.number = paymentTextField.cardNumber
        cardParams.cvc = paymentTextField.cvc
        cardParams.expYear = paymentTextField.expirationYear
        cardParams.expMonth = paymentTextField.expirationMonth
        cardParams.currency = "usd"
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                print("Error: \(String(describing: error?.localizedDescription))")
                hideActivityIndicator()
                self.showToastMessage(message: "Unable to read your card details")
                return
            }
            hideActivityIndicator()
            let parameters: [String:Any] = ["save_type": true, "country_code": "1", "token": token.tokenId]
            self.callSaveUserCard(parameters: parameters)
        }
    }
}

//MARK:- API Methods

    extension PaymentManagementVC {
        func callSaveUserCard(parameters: [String:Any]) {
            checkoutService.callSaveUserCardDetailsAPI(parameters: parameters, showLoader: true, completionBlockSuccess: { (response) -> Void in
                // your successful handle
                print(response)
                NOTIFICATIONCENTER.post(name: Notification.Name(rawValue: "Cards"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }) { (failure) -> Void in
                // your failure handle
                self.btn_Save.isEnabled = true
                self.handleAPIError(failure: failure)
            }
        }
    }
