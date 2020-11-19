//  Created by Navpreet on 20/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit
import SkyFloatingLabelTextField

//**************THIS CONTROLLER IS CURRENTLY NOT IN USE **************//

protocol WalletPaymentDismissDelegate {
    func walletPaymentViewDismissed(amount:String)
}
class WalletPaymentVC: UIViewController {
    //MARK:- Protocols
    var walletPaymentDismissDelegate: WalletPaymentDismissDelegate!
    let walletViewHeight: CGFloat = 270
    
    //MARK:- Variable Declaration
    
    //MARK:- Outlet Connections
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var view_TransparentBack: UIView!
    @IBOutlet weak var btn_Pay: UIButton!
    @IBOutlet weak var tf_PaymentAmount: SkyFloatingLabelTextField!
    @IBOutlet weak var constraint_BlurViewHeight: NSLayoutConstraint!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view_TransparentBack.addGestureRecognizer(tapGesture)
        self.view_TransparentBack.isUserInteractionEnabled = true
        
        let swipedownGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipedownGesture.direction = UISwipeGestureRecognizer.Direction.down
        self.view_TransparentBack.addGestureRecognizer(swipedownGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(WalletPaymentVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WalletPaymentVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        initialSetup()
        setUpData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.75, delay: 0.4, options: .allowUserInteraction, animations: {
            self.view_TransparentBack.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    //MARK:- Gesture Recognizer
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismissViewController(amount: "")
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                self.dismissViewController(amount: "")
            default:
                break
            }
        }
    }
    func dismissViewController(amount: String) {
        self.dismiss(animated: false) {
            self.walletPaymentDismissDelegate.walletPaymentViewDismissed(amount: amount)
        }
    }
    //MARK:- Keyboard Notifications
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize)
            UIView.animate(withDuration: 0.5, animations: {
                if UIScreen.main.nativeBounds.height == 2436 {
                    self.constraint_BlurViewHeight.constant = self.walletViewHeight+160
                }else {
                    self.constraint_BlurViewHeight.constant = self.walletViewHeight+120
                }
                self.view.layoutIfNeeded()
            }) { (success) in
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize)
            UIView.animate(withDuration: 0.5, animations: {
                self.constraint_BlurViewHeight.constant = self.walletViewHeight
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
        /*let clearButton = tf_PaymentAmount.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.setImage(UIImage(named: "cross_icon_01"), for: .normal)*/
        tf_PaymentAmount.delegate = self
    }
    func setUpData() {
    }
    //MARK:- Button Methods
    @IBAction func payAmountTapped(_ sender: Any) {
        self.dismissViewController(amount: tf_PaymentAmount.text!)
    }
}

//MARK:- UITextFieldDelegate
extension WalletPaymentVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let regex : String = "\\d{0,5}(\\.\\d{0,2})?"
        let str = text as NSString?
        let editedStr = str?.replacingCharacters(in: range , with: string)
        let predicate : NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: editedStr)
    }
}
