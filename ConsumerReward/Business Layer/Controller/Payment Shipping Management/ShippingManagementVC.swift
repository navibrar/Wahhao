//  Created by Navpreet on 19/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit


class ShippingManagementVC: UIViewController {
    
    //MARK:- Variable Declaration
    let checkoutService = CheckoutServices.sharedInstance
    var isAddAddress = Bool()
    var addressType = ""
    var stateCode = ""
    var address: ShippingAddress? = nil
    var formatter = PhoneFormatter(rulesets: PNFormatRuleset.usHyphen())
    var array_USStates = [NSDictionary]()
    var isStateSelected = false
    
    //MARK:- Outlet Connections
    @IBOutlet weak var scroll_Content: UIScrollView!
    @IBOutlet weak var view_Content: UIView!
    @IBOutlet weak var tf_Name: UITextField!
    @IBOutlet weak var tf_Address1: UITextField!
    @IBOutlet weak var tf_Address2: UITextField!
    @IBOutlet weak var tf_Zip: UITextField!
    @IBOutlet weak var tf_City: UITextField!
    @IBOutlet weak var tf_State: UITextField!
    @IBOutlet weak var tf_Country: UITextField!
    @IBOutlet weak var tf_PhoneNumber: UITextField!
    @IBOutlet weak var view_AddressType: UIView!
    @IBOutlet weak var lbl_Home: UILabel!
    @IBOutlet weak var img_HomeAddress: UIImageView!
    @IBOutlet weak var lbl_Office: UILabel!
    @IBOutlet weak var img_OfficeAddress: UIImageView!
    @IBOutlet weak var lbl_Other: UILabel!
    @IBOutlet weak var img_OtherAddress: UIImageView!
    @IBOutlet weak var btn_Save: UIBarButtonItem!
    //Picker
    @IBOutlet weak var view_Picker: UIView!
    @IBOutlet weak var toolBar_Picker: UIToolbar!
    @IBOutlet weak var picker_States: UIPickerView!
    @IBOutlet weak var barBtn_Cancel: UIBarButtonItem!
    @IBOutlet weak var barBtn_Done: UIBarButtonItem!
    @IBOutlet weak var constraint_ContentHeight: NSLayoutConstraint!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
        ADD_DONE_BUTTON_TO_TOOLBAR(textField: tf_Name)
        ADD_DONE_BUTTON_TO_TOOLBAR(textField: tf_Address1)
        ADD_DONE_BUTTON_TO_TOOLBAR(textField: tf_Address2)
        ADD_DONE_BUTTON_TO_TOOLBAR(textField: tf_City)
        ADD_DONE_BUTTON_TO_TOOLBAR(textField: tf_State)
        ADD_DONE_BUTTON_TO_TOOLBAR(textField: tf_Zip)
        ADD_DONE_BUTTON_TO_TOOLBAR(textField: tf_PhoneNumber)
        
        //self.perform(#selector(self.callFetchStates), with: self, afterDelay: 0.1)
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
    
    //MARK:- Keyboard Hiding
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //MARK:- Custom Methods
    func initialSetup() {
        view_Picker.isHidden = true
        toolBar_Picker.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        toolBar_Picker.barTintColor = #colorLiteral(red: 0.03608750924, green: 0.09721792489, blue: 0.1571344137, alpha: 1)
        
        self.scroll_Content.contentSize = CGSize(width: 0, height: 600)
        let contentHeight = self.scroll_Content.contentSize.height - self.getContentViewHeight()
        if contentHeight > 0 {
            self.constraint_ContentHeight.constant = contentHeight
        }
        self.parseStates()
        self.setUpData()
    }
    
    func getContentViewHeight() -> CGFloat {
        var safeAreaHeight:CGFloat = 0
        var bottomPadding:CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomPadding = window?.safeAreaInsets.bottom ?? 0
        }
        if tabBarController?.tabBar != nil {
            safeAreaHeight += (tabBarController?.tabBar.bounds.height)!
        }else {
            safeAreaHeight += bottomPadding == 0 ? 34 : bottomPadding
        }
        if navigationController?.navigationBar != nil {
            safeAreaHeight += (navigationController?.navigationBar.bounds.height)!
        }else {
            safeAreaHeight += bottomPadding == 0 ? 34 : bottomPadding
        }
        return self.view.bounds.height - safeAreaHeight
    }
    
    func setUpData() {
            if isAddAddress == false {
                tf_Name.text = address?.full_name
                tf_Address1.text = address?.address1
                tf_Address2.text = address?.address2
                tf_Zip.text = "\(address?.zipcode ?? 0)"
                tf_City.text = address?.city
                let formattedNo = self.formatter.format(number: address?.phone ?? "")
                tf_PhoneNumber.text = formattedNo
                
                let filtered = self.checkoutService.array_States.filter({$0.name.caseInsensitiveCompare((address?.province)!) == .orderedSame})
                if filtered.count > 0 {
                    stateCode = filtered[0].code
                    tf_State.text = filtered[0].name
                    self.parseCities(code: stateCode)
                }else {
                    stateCode = self.checkoutService.array_States[0].code
                    tf_State.text = self.checkoutService.array_States[0].name
                }
                if address?.address_type.caseInsensitiveCompare("Home") == .orderedSame {
                    setAddressTypeHome()
                }else if address?.address_type.caseInsensitiveCompare("Office") == .orderedSame {
                    setAddressTypeOffice()
                }else if address?.address_type.caseInsensitiveCompare("Other") == .orderedSame {
                    setAddressTypeOther()
                }else {
                    deselectAddressType()
                }
            }
    }
    
    func shippingAddressValidations() {
        let phoneNumber = tf_PhoneNumber.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        guard let _ = tf_Name.text, tf_Name.text?.trimmingCharacters(in: .whitespaces).isEmpty == false && (tf_Name.text?.count)! >= ConfigurationManager.CharacterLength.FullNameMinLength.value else{
            var message = ""
            if tf_Name.text?.count == 0 || tf_Name.text == "" {
                message = "Please enter name"
            }else {
                message = "Please enter valid name (Minimum 2 characters)"
            }
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: "OK", viewController: self, completionHandler: { (success) in
                self.tf_Name.becomeFirstResponder()
            })
            return
        }
        guard let _ = tf_Address1.text, tf_Address1.text?.trimmingCharacters(in: .whitespaces).isEmpty == false && (tf_Address1.text?.count)! >= ConfigurationManager.CharacterLength.MinimumLength.value else{
            var message = ""
            if tf_Address1.text?.count == 0 || tf_Address1.text == "" {
                message = "Please enter address"
            }else {
                message = "Please enter valid address (Minimum 2 characters)"
            }
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: "OK", viewController: self, completionHandler: { (success) in
                self.tf_Address1.becomeFirstResponder()
            })
            return
        }
        /*guard let _ = tf_Address2.text, tf_Address2.text?.trimmingCharacters(in: .whitespaces).isEmpty == false && (tf_Address2.text?.count)! >= ConfigurationManager.CharacterLength.MinimumLength.value else{
         var message = ""
         if tf_Address2.text?.count == 0 || tf_Address2.text == "" {
         message = "Please enter address line 2"
         }else {
         message = "Please enter valid address line 2 (Minimum 2 characters)"
         }
         AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: "OK", viewController: self, completionHandler: { (success) in
         self.tf_Address2.becomeFirstResponder()
         })
         return
         }*/
        guard let _ = tf_State.text, tf_State.text?.trimmingCharacters(in: .whitespaces).isEmpty == false else{
            let message = "Please select state"
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: "OK", viewController: self, completionHandler: { (success) in
                let button = UIButton()
                self.selectStateTapped(button)
            })
            return
        }
        guard let _ = tf_City.text, tf_City.text?.trimmingCharacters(in: .whitespaces).isEmpty == false else{
            let message = "Please select city"
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: "OK", viewController: self, completionHandler: { (success) in
                let button = UIButton()
                self.selectCityTapped(button)
            })
            return
        }
        guard let _ = tf_Zip.text, tf_Zip.text?.trimmingCharacters(in: .whitespaces).isEmpty == false && (tf_Zip.text?.count)! >= ConfigurationManager.CharacterLength.MinimumLength.value else{
            var message = ""
            if tf_Zip.text?.count == 0 || tf_Zip.text == "" {
                message = "Please enter zip code"
            }else {
                message = "Please enter valid zip code (5 characters in length)"
            }
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: "OK", viewController: self, completionHandler: { (success) in
                self.tf_Zip.becomeFirstResponder()
            })
            return
        }
        guard let _ = tf_PhoneNumber.text, phoneNumber?.trimmingCharacters(in: .whitespaces).isEmpty == false && (phoneNumber?.count)! >= ConfigurationManager.CharacterLength.PhoneNumberLengthUS.value else{
            var message = ""
            if phoneNumber?.count == 0 || phoneNumber == "" {
                message = "Please enter phone number"
            }else {
                message = "Please enter valid phone number"
            }
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: "OK", viewController: self, completionHandler: { (success) in
                self.tf_PhoneNumber.becomeFirstResponder()
            })
            return
        }
        if addressType == "" {
            let message = "Please select address type"
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message:message, btnTitle: "OK", viewController: self, completionHandler: { (success) in
                self.view.endEditing(true)
            })
            return
        }
        var parameters: [String:Any] = [
            "id": address != nil ? address!.id as Any : "0",
            "full_name": tf_Name.text!,
            "address1": tf_Address1.text!,
            "address2": tf_Address2.text ?? "",
            "zipcode": tf_Zip.text!,
            "city": tf_City.text!,
            "province": tf_State.text!,
            "province_code": stateCode,
            "address_type": addressType,
            "latitude": "",
            "longitude": "",
            "country_code": "1",
            "phone": phoneNumber!,
            "country": "US",
            "is_billing": false
        ]
        if isAddAddress == true {
            parameters.removeValue(forKey: "id")
        }
        print(parameters)
        self.callAddEditShippingAddress(parameters: parameters)
    }
    func setAddressTypeHome() {
        addressType = "Home"
        img_HomeAddress.image = UIImage(named: "radio_check")
        img_OfficeAddress.image = UIImage(named: "radio_uncheck")
        img_OtherAddress.image = UIImage(named: "radio_uncheck")
    }
    func setAddressTypeOffice() {
        addressType = "Office"
        img_OfficeAddress.image = UIImage(named: "radio_check")
        img_OtherAddress.image = UIImage(named: "radio_uncheck")
        img_HomeAddress.image = UIImage(named: "radio_uncheck")
    }
    func setAddressTypeOther() {
        addressType = "Other"
        img_OtherAddress.image = UIImage(named: "radio_check")
        img_HomeAddress.image = UIImage(named: "radio_uncheck")
        img_OfficeAddress.image = UIImage(named: "radio_uncheck")
    }
    func deselectAddressType() {
        addressType = ""
        img_OfficeAddress.image = UIImage(named: "radio_uncheck")
        img_HomeAddress.image = UIImage(named: "radio_uncheck")
        img_OtherAddress.image = UIImage(named: "radio_uncheck")
    }
    func parseStates() {
        checkoutService.array_States.removeAll()
        array_USStates = GET_US_STATES()
        for item in array_USStates {
            let state = States(dictionary: item)
            checkoutService.array_States.append(state)
        }
    }
    func parseCities(code: String) {
        checkoutService.array_Cities.removeAll()
        let filtered = array_USStates.filter({$0["state_code"] as! String == code})
        if filtered.count > 0 {
            let cities = (filtered[0])["city"] as! [NSDictionary]
            print(cities)
            for item in cities {
                let city = Cities(dictionary: item)
                checkoutService.array_Cities.append(city)
            }
        }
    }
    //MARK:- Button Methods
    @IBAction func back_Tapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.shippingAddressValidations()
    }
    @IBAction func homeAddressTapped(_ sender: Any) {
        setAddressTypeHome()
    }
    @IBAction func officeAddressTapped(_ sender: Any) {
        setAddressTypeOffice()
    }
    @IBAction func otherAddressTapped(_ sender: Any) {
        setAddressTypeOther()
    }
    @IBAction func selectStateTapped(_ sender: Any) {
        self.view.endEditing(true)
        if view_Picker.isHidden == false {
            view_Picker.isHidden = true
            return
        }
        self.isStateSelected = true
        view_Picker.isHidden = false
        self.view.bringSubviewToFront(view_Picker)
        picker_States.reloadAllComponents()
        if tf_State.hasText {
            let index = self.checkoutService.array_States.index{ $0.name == tf_State.text }
            if index != nil{
                picker_States.selectRow(index!, inComponent: 0, animated: true)
            }else {
                picker_States.selectRow(0, inComponent: 0, animated: true)
            }
        }else {
            picker_States.selectRow(0, inComponent: 0, animated: true)
        }
    }
    @IBAction func selectCityTapped(_ sender: Any) {
        self.view.endEditing(true)
        if tf_State.text == "" {
            self.showToastMessage(message: "State is not selected")
            return
        }
        if view_Picker.isHidden == false {
            view_Picker.isHidden = true
            return
        }
        self.isStateSelected = false
        view_Picker.isHidden = false
        self.view.bringSubviewToFront(view_Picker)
        picker_States.reloadAllComponents()
        if tf_City.hasText {
            let index = self.checkoutService.array_Cities.index{ $0.name == tf_City.text }
            if index != nil{
                picker_States.selectRow(index!, inComponent: 0, animated: true)
            }else {
                picker_States.selectRow(0, inComponent: 0, animated: true)
            }
        }else {
            picker_States.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    @IBAction func cancelPickerTapped(_ sender: Any) {
        view_Picker.isHidden = true
    }
    @IBAction func selectPickerValueTapped(_ sender: Any) {
        if self.isStateSelected == true {
            tf_State.text = self.checkoutService.array_States[picker_States.selectedRow(inComponent: 0)].name
            stateCode = self.checkoutService.array_States[picker_States.selectedRow(inComponent: 0)].code
            tf_City.text = ""
            self.parseCities(code: stateCode)
        }else {
            if self.checkoutService.array_Cities.count > 0 {
                tf_City.text = self.checkoutService.array_Cities[picker_States.selectedRow(inComponent: 0)].name
            }
        }
        view_Picker.isHidden = true
    }
}

//MARK:- UITextFieldDelegate
extension ShippingManagementVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tf_Name {
            _ = tf_Address1.becomeFirstResponder()
        }else if textField == tf_Address1 {
            _ = tf_Address2.becomeFirstResponder()
        }else if textField == tf_Address2 {
            let btn = UIButton()
            self.selectStateTapped(btn)
        }else if textField == tf_PhoneNumber {
            _ = textField.resignFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var success: Bool = true
        //Limit Character Length
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        if textField == tf_Name {
            success =  newLength <= ConfigurationManager.CharacterLength.FullNameMaxLength.value
        }else if textField == tf_Address1 {
            success =  newLength <= ConfigurationManager.CharacterLength.Address.value
        }else if textField == tf_Address2 {
            success =  newLength <= ConfigurationManager.CharacterLength.Address.value
        }else if textField == tf_Zip {
            success =  newLength <= ConfigurationManager.CharacterLength.ZipCode.value
        }else if textField == tf_PhoneNumber, let text = textField.text {
            
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
}

//MARK:- UIPicker View Delegate and Datasources
extension ShippingManagementVC : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isStateSelected == true {
            return self.checkoutService.array_States.count
        }else {
           return self.checkoutService.array_Cities.count
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title : String = ""
        return title
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        label.textColor = #colorLiteral(red: 0.03608750924, green: 0.09721792489, blue: 0.1571344137, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont(name: Constants.MEDIUM_FONT, size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        if isStateSelected == true {
            label.text = self.checkoutService.array_States[row].name
        }else {
            label.text = self.checkoutService.array_Cities[row].name
        }
        return label
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}

//MARK:- API METHODS
extension ShippingManagementVC {
    func callAddEditShippingAddress(parameters: [String:Any]) {
        self.btn_Save.isEnabled = false
        checkoutService.callAddEditShippingAddressAPI(isAddAddress: isAddAddress, parameters: parameters, showLoader: true, completionBlockSuccess: { (response) -> Void in
            // your successful handle
            print(response)
            NOTIFICATIONCENTER.post(name: Notification.Name(rawValue: "Address"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }) { (failure) -> Void in
            // your failure handle
            self.btn_Save.isEnabled = true
            self.handleAPIError(failure: failure)
        }
    }
    @objc func callFetchStates() {
        checkoutService.array_States.removeAll()
        checkoutService.callFetchStatesAPI(showLoader: true, completionBlockSuccess: { (response) -> Void in
            // your successful handle
            self.setUpData()
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
}
