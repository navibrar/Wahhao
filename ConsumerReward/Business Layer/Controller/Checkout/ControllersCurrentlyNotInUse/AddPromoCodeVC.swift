//  Created by apple on 7/19/18.
//  Copyright © 2018 wahhao. All rights reserved.


import UIKit

//**************THIS CONTROLLER IS CURRENTLY NOT IN USE **************//

protocol AddPromoCodeDismissDelegate {
    func addPromoCodeViewDismissed(code:String)
}
class AddPromoCodeVC: UIViewController {
    //MARK:- Protocols
    var addPromoCodeDismissDelegate: AddPromoCodeDismissDelegate!
    //MARK:- Protocols
    let promoCodeViewHeight: CGFloat = 240
    
    //MARK:- OUTLET DECLARATION
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var btn_Apply: UIButton!
    @IBOutlet weak var view_TransparentBack: UIView!
    @IBOutlet weak var tf_PromoCode: UITextField!
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddPromoCodeVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddPromoCodeVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.75, delay: 0.4, options: .allowUserInteraction, animations: {
            self.view_TransparentBack.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:- Keyboard Notifications
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize)
            UIView.animate(withDuration: 0.5, animations: {
                if UIScreen.main.nativeBounds.height == 2436 {
                    self.constraint_BlurViewHeight.constant = self.promoCodeViewHeight+155
                }else {
                    self.constraint_BlurViewHeight.constant = self.promoCodeViewHeight+120
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
                self.constraint_BlurViewHeight.constant = self.promoCodeViewHeight
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
        let clearButton = tf_PromoCode.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.setImage(UIImage(named: "cross_icon_01"), for: .normal)
        tf_PromoCode.delegate = self
    }
    //MARK:- Gesture Recognizer
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismissViewController(code: "")
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                self.dismissViewController(code: "")
            default:
                break
            }
        }
    }
    func dismissViewController(code: String) {
        self.dismiss(animated: false) {
            self.addPromoCodeDismissDelegate.addPromoCodeViewDismissed(code: code)
        }
    }
    
    //MARK:- Button Methods
    @IBAction func applyPromoCodeTapped(_ sender: UIButton){
        dismissViewController(code: tf_PromoCode.text!)
    }
}

//MARK:- UITextFieldDelegate
extension AddPromoCodeVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if  string.isAlphanumeric {
            let charsLimit = 6
            if textField == tf_PromoCode {
                let startingLength = textField.text?.count ?? 0
                let lengthToAdd = string.count
                let lengthToReplace =  range.length
                let newLength = startingLength + lengthToAdd - lengthToReplace
                return newLength <= charsLimit
            }
            return true
        }else {
            return false
         }
    
}
}


