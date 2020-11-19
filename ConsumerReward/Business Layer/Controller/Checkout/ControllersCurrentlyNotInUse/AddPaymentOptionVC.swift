//  Created by Navpreet on 20/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

//**************THIS CONTROLLER IS CURRENTLY NOT IN USE **************//

protocol PaymentOptionsDismissDelegate {
    func paymentOptionsViewDismissed(paymentOption:String)
}

class AddPaymentOptionVC: UIViewController {
    //MARK:- Protocols
    var paymentOptionsDismissDelegate: PaymentOptionsDismissDelegate!
    //MARK:- Variable Declaration
    var array_PaymentOptions = [PaymentOption]()
    //MARK:- Outlet Connections
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var view_TransparentBack: UIView!
    @IBOutlet weak var btn_Continue: UIButton!
    @IBOutlet weak var table_PaymentOptions: UITableView!

    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view_TransparentBack.addGestureRecognizer(tapGesture)
        self.view_TransparentBack.isUserInteractionEnabled = true
        
        let swipedownGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipedownGesture.direction = UISwipeGestureRecognizer.Direction.down
        self.view_TransparentBack.addGestureRecognizer(swipedownGesture)
        
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
        self.dismissViewController(option: "")
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                self.dismissViewController(option: "")
            default:
                break
            }
        }
    }
    func dismissViewController(option: String) {
        self.dismiss(animated: false) {
            self.paymentOptionsDismissDelegate.paymentOptionsViewDismissed(paymentOption: option)
        }
    }
    //MARK:- Custom Methods
    func initialSetup() {
        blurEffectView.topRoundCornnersVisualEffect(radius: 37)
        table_PaymentOptions.tableFooterView = UIView()
    }
    func setUpData() {
        //"Add Credit Card", "Pay With Apple pay", "Pay With Samsung pay", "Wallet Payment", "Add Promo Code"
        let dict1: NSDictionary = ["title": "Add Credit Card", "isSelected": false]
        let dict2: NSDictionary = ["title": "Pay With Apple pay", "isSelected": false]
        let dict3: NSDictionary = ["title": "Pay With Samsung pay", "isSelected": false]
        let dict4: NSDictionary = ["title": "Wallet Payment", "isSelected": false]
        let dict5: NSDictionary = ["title": "Add Promo Code", "isSelected": false]
        array_PaymentOptions.append(PaymentOption(dictionary: dict1))
        array_PaymentOptions.append(PaymentOption(dictionary: dict2))
        array_PaymentOptions.append(PaymentOption(dictionary: dict3))
        array_PaymentOptions.append(PaymentOption(dictionary: dict4))
        array_PaymentOptions.append(PaymentOption(dictionary: dict5))
        
    }
    //MARK:- Button Methods
    @IBAction func continueTapped(_ sender: Any) {
        if array_PaymentOptions[0].isSelected == true {
            //Credit Card
            self.dismissViewController(option: "Credit Card")
        }else if array_PaymentOptions[1].isSelected == true {
            //Apple Pay
            self.dismissViewController(option: "Apple Pay")
        }else if array_PaymentOptions[2].isSelected == true {
            //Samsung Pay
            self.dismissViewController(option: "Samsung Pay")
        }else if array_PaymentOptions[3].isSelected == true {
            //Wallet
            self.dismissViewController(option: "Wallet")
        }else if array_PaymentOptions[4].isSelected == true {
            //Promo code
            self.dismissViewController(option: "Promo Code")
        }else {
            self.dismissViewController(option: "")
        }
    }
}

//MARK:- UITableViewDelegate & UITableViewDataSource
extension AddPaymentOptionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_PaymentOptions.count
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentOptionCell", for: indexPath) as! PaymentOptionCell
        cell.configureCell(item: array_PaymentOptions[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filtered = self.array_PaymentOptions.filter({$0.isSelected == true})
        var selectedIndexPath = IndexPath()
        var isPreviouslySelected = Bool()
        if filtered.count > 0 {
            for index in 0..<self.array_PaymentOptions.count {
                if self.array_PaymentOptions[index].isSelected == true {
                    self.array_PaymentOptions[index].isSelected = false
                    selectedIndexPath = IndexPath(row: index, section: 0)
                    isPreviouslySelected = true
                    break
                }
            }
        }
        self.array_PaymentOptions[indexPath.row].isSelected = true
        tableView.beginUpdates()
        if isPreviouslySelected == true {
            tableView.reloadRows(at: [selectedIndexPath, indexPath], with: .none)
        }else {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        tableView.endUpdates()
    }
}
