//  Created by Navpreet on 20/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit
import Stripe

protocol CardPaymentDismissDelegate {
    func cardPaymentViewDismissed(checkoutPreferences: CheckoutProtocolModel?)
}

class CardPaymentVC: UIViewController {
    //MARK:- Protocols
    var cardPaymentDismissDelegate: CardPaymentDismissDelegate!
    var isSaveCardForFuture:Bool = false
    //Protocol Variables
    var checkoutPreferences: CheckoutProtocolModel? = nil
    
    //MARK:- Variable Declaration
    let checkoutService = CheckoutServices.sharedInstance
    let paymentTextField = STPPaymentCardTextField()
    let cardViewHeight: CGFloat = 280
    
    
    //MARK:- Outlet Connections
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var view_TransparentBack: UIView!
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var constraint_ContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var view_Payment: UIView!
    @IBOutlet weak var view_SavedCard: UIView!
    @IBOutlet weak var img_SaveCard: UIImageView!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view_TransparentBack.addGestureRecognizer(tapGesture)
        self.view_TransparentBack.isUserInteractionEnabled = true
        
        let swipedownGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipedownGesture.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipedownGesture)
        
        NOTIFICATIONCENTER.addObserver(self, selector: #selector(WalletPaymentVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NOTIFICATIONCENTER.addObserver(self, selector: #selector(WalletPaymentVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        initialSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIView.animate(withDuration: 0.75, delay: 0.4, options: .allowUserInteraction, animations: {
            self.view_TransparentBack.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    //MARK:- Gesture Recognizer
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismissViewController()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                self.dismissViewController()
            default:
                break
            }
        }
    }
    
    //MARK:- Keyboard Notifications
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize)
            UIView.animate(withDuration: 0.5, animations: {
                self.constraint_ContentViewHeight.constant = self.cardViewHeight + keyboardSize.height
                self.view.layoutIfNeeded()
            }) { (success) in
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize)
            UIView.animate(withDuration: 0.5, animations: {
                self.constraint_ContentViewHeight.constant = self.cardViewHeight
                self.view.layoutIfNeeded()
            }) { (success) in
            }
        }
    }
    //MARK:- Keyboard Hiding
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //MARK:- Custom Methods
    func initialSetup() {
        blurEffectView.topRoundCornnersVisualEffect(radius: 37)
        self.enableDisableSaveButton(isEnable: false)
        view_Payment.backgroundColor = .clear
        
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
        paymentTextField.becomeFirstResponder()
    }

    func dismissViewController() {
        self.dismiss(animated: false) {
            self.cardPaymentDismissDelegate.cardPaymentViewDismissed(checkoutPreferences: self.checkoutPreferences)
        }
    }
    func enableDisableSaveButton(isEnable: Bool) {
        if isEnable == true {
            btn_Save.isEnabled = true
            btn_Save.alpha = 1.0
            btn_Save.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        }else {
            btn_Save.isEnabled = false
            btn_Save.alpha = 0.5
            btn_Save.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        }
    }
    //MARK:- Button Methods
    @IBAction func saveTapped(_ sender: Any) {
        self.createStripeTokenToChargeCard()
    }
    @IBAction func saveCardForFutureTapped(_ sender: Any) {
        if isSaveCardForFuture == true {
            isSaveCardForFuture = false
            img_SaveCard.image = UIImage(named: "uncheck_icon_square")
        }else {
            isSaveCardForFuture = true
            img_SaveCard.image = UIImage(named: "check_icon_square")
        }
    }
}

// MARK: STPPaymentCardTextFieldDelegate
extension CardPaymentVC: STPPaymentCardTextFieldDelegate {
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        // Toggle buy button state
        print(textField.cardNumber ?? "No Card Number")
        if textField.isValid {
            self.enableDisableSaveButton(isEnable: true)
            textField.resignFirstResponder()
        }else {
            self.enableDisableSaveButton(isEnable: false)
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
            let parameters: [String:Any] = ["save_type": self.isSaveCardForFuture, "country_code": "1", "token": token.tokenId]
            self.callSaveUserCard(parameters: parameters)
        }
    }
}

//MARK:- API Methods

extension CardPaymentVC {
    func callSaveUserCard(parameters: [String:Any]) {
        checkoutService.callSaveUserCardDetailsAPI(parameters: parameters, showLoader: true, completionBlockSuccess: { (response) -> Void in
            // your successful handle
             FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.checkOut, category: FirAnalytics.Category.checkout, label: FirAnalytics.Label.checkout_payment_card_added, action: FirAnalytics.Actions.addpayment_card, value: 1)
            print(response)
            if let result = response["response"] as? NSDictionary {
                let details = CardDetail(dictionary: result)
                self.checkoutPreferences?.paymentDetails = details
                self.checkoutPreferences?.isPaymentFieldOpen = true
                self.checkoutPreferences?.isAddressFieldOpen = false
                self.checkoutPreferences?.isOrderSummaryOpen = false
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                    self.dismissViewController()
                })
            }
        }) { (failure) -> Void in
            // your failure handle
             FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.checkOut, category: FirAnalytics.Category.checkout, label: FirAnalytics.Label.checkout_payment_card_added, action: FirAnalytics.Actions.addpayment_card, value: 0)
            self.handleAPIError(failure: failure)
        }
    }
}
