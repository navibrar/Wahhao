//  Created by Navpreet on 15/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.

import UIKit

class PaymentShippingManagementVC: UIViewController {
    //MARK:- Variable Declaration
    private enum PaymentShippingHeader {
        static let SavedCards = 0
        static let Addresses = 1
    }
    let checkoutService = CheckoutServices.sharedInstance
    var array_Addresses = [ShippingAddress]()
    //MARK:- Outlet Connections
    @IBOutlet weak var segment_Options: HBSegmentedControl!
    @IBOutlet weak var table_PaymentShipping: UITableView!
    @IBOutlet weak var btn_Add: UIButton!
    @IBOutlet weak var constraint_TableTop: NSLayoutConstraint!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        //SWIPE GESTURES
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        segment_Options.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        segment_Options.addGestureRecognizer(swipeRight)
        
        //Notification
        NOTIFICATIONCENTER.addObserver(self, selector: #selector(self.updateAddresses), name: Notification.Name(rawValue: "Address"), object: nil)
        NOTIFICATIONCENTER.addObserver(self, selector: #selector(self.updateCards), name: Notification.Name(rawValue: "Cards"), object: nil)
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let view = table_PaymentShipping
            .allSubViews //get all the subviews
            .filter {String(describing:type(of: $0)) ==  "UISwipeActionPullView"}
        print(view)
        if view.count > 0 {
               view[0].backgroundColor = UIColor.clear
        }
  }
    //MARK:- Notifications
    @objc func updateAddresses(notification: NSNotification) {
        self.callFetchShippingAddress()
    }
    @objc func updateCards(notification: NSNotification) {
        self.callFetchUserCardDetails()
    }
    //MARK:- Swipe Gesture
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                print("move Left")
                if segment_Options.selectedIndex == PaymentShippingHeader.Addresses {
                    segment_Options.selectedIndex = PaymentShippingHeader.SavedCards
                    setUpCardsView()
                }
            case UISwipeGestureRecognizer.Direction.right:
                print("move Right")
                if segment_Options.selectedIndex == PaymentShippingHeader.SavedCards {
                    segment_Options.selectedIndex = PaymentShippingHeader.Addresses
                    setUpAddressView()
                }
            default:
                break
            }
        }
    }
    
    //MARK:- Custom Methods
    func initialSetup() {
        checkoutService.array_CardDetails.removeAll()
        checkoutService.array_ShippingAddress.removeAll()
        segment_Options.items = ["SAVED CARDS", "ADDRESSES"]
        segment_Options.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: 11)
        segment_Options.setFont()
        segment_Options.selectedIndex = PaymentShippingHeader.SavedCards
        segment_Options.borderColor = .clear
        segment_Options.backgroundColor = #colorLiteral(red: 0.08003249019, green: 0.1880437434, blue: 0.3238782883, alpha: 1)
        segment_Options.addTarget(self, action: #selector(PaymentShippingManagementVC.segmentValueChanged(_:)), for: .valueChanged)
        
        //Headers
        table_PaymentShipping.register(UINib(nibName: "AddressHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "AddressHeader")
        //Table Cells
        table_PaymentShipping.register(UINib(nibName: "SavedCardCell", bundle: nil), forCellReuseIdentifier: "SavedCardCell")
        table_PaymentShipping.register(UINib(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier: "AddressCell")
        
        self.setUpCardsView()
    }
    @objc func segmentValueChanged(_ sender: AnyObject?){
        if segment_Options.selectedIndex == PaymentShippingHeader.SavedCards {
            self.setUpCardsView()
        }else if segment_Options.selectedIndex == PaymentShippingHeader.Addresses{
            self.setUpAddressView()
        }
    }
    func setUpCardsView() {
        self.constraint_TableTop.constant = 8
        self.btn_Add.setTitle("ADD NEW CARD", for: .normal)
        if checkoutService.array_CardDetails.count == 0 {
            self.callFetchUserCardDetails()
        }else {
            table_PaymentShipping.reloadData()
        }
    }
    func setUpAddressView() {
        self.constraint_TableTop.constant = 0
        self.btn_Add.setTitle("ADD NEW ADDRESS", for: .normal)
        if self.array_Addresses.count == 0 {
            self.callFetchShippingAddress()
        }else {
            table_PaymentShipping.reloadData()
        }
    }
    func setUpAddressData() {
        self.array_Addresses.removeAll()
        var homeFiltered = self.checkoutService.array_ShippingAddress.filter({$0.address_type.caseInsensitiveCompare("Home") == .orderedSame})
        if homeFiltered.count > 0 {
            homeFiltered[0].isTitleDisplayed = true
            for item in homeFiltered {
                array_Addresses.append(item)
            }
        }
        var officeFiltered = self.checkoutService.array_ShippingAddress.filter({$0.address_type.caseInsensitiveCompare("Office") == .orderedSame})
        if officeFiltered.count > 0 {
            officeFiltered[0].isTitleDisplayed = true
            for item in officeFiltered {
                array_Addresses.append(item)
            }
        }
        
        var otherFiltered = self.checkoutService.array_ShippingAddress.filter({$0.address_type.caseInsensitiveCompare("Other") == .orderedSame})
        if otherFiltered.count > 0 {
            otherFiltered[0].isTitleDisplayed = true
            for item in otherFiltered {
                array_Addresses.append(item)
            }
        }
        self.table_PaymentShipping.reloadData()
    }
    func editAddress(address: ShippingAddress) {
        let storyboard = UIStoryboard(name: "PaymentShippingManagement", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "ShippingManagementVC") as! ShippingManagementVC
        vcObj.isAddAddress = false
        vcObj.address = address
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    //MARK:- Button Actions
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addTapped(_ sender: Any) {
        if segment_Options.selectedIndex == PaymentShippingHeader.SavedCards {
            let storyboard = UIStoryboard(name: "PaymentShippingManagement", bundle: nil)
            let vcObj = storyboard.instantiateViewController(withIdentifier: "PaymentManagementVC") as! PaymentManagementVC
            self.navigationController?.pushViewController(vcObj, animated: true)
        }else {
            let storyboard = UIStoryboard(name: "PaymentShippingManagement", bundle: nil)
            let vcObj = storyboard.instantiateViewController(withIdentifier: "ShippingManagementVC") as! ShippingManagementVC
            vcObj.isAddAddress = true
            self.navigationController?.pushViewController(vcObj, animated: true)
        }
    }
}

//MARK:- UITableViewDelegate & UITableViewDataSource
extension PaymentShippingManagementVC: UITableViewDelegate, UITableViewDataSource {
    //MARK:-
    func numberOfSections(in tableView: UITableView) -> Int {
        if segment_Options.selectedIndex == PaymentShippingHeader.SavedCards {
            return checkoutService.array_CardDetails.count
        }else {
            return array_Addresses.count
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if segment_Options.selectedIndex == PaymentShippingHeader.SavedCards {
            return 16
        }else {
            if array_Addresses[section].isTitleDisplayed == true {
              return 49
            }else {
              return 16
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var superHeader = UIView()
        superHeader.tag = section
        if segment_Options.selectedIndex == PaymentShippingHeader.SavedCards {
            superHeader.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 16)
            superHeader.backgroundColor = .clear
        }else {
            if array_Addresses[section].isTitleDisplayed == true {
                let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AddressHeader") as! AddressHeader
                headerView.tintColor = UIColor.clear
                headerView.configureHeader(title: array_Addresses[section].address_type.uppercased())
                superHeader = headerView
            }else {
                superHeader.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 16)
                superHeader.backgroundColor = .clear
            }
        }
        return superHeader
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if segment_Options.selectedIndex == PaymentShippingHeader.SavedCards {
            return 0
        }else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segment_Options.selectedIndex == PaymentShippingHeader.SavedCards {
            return 1
        }else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if segment_Options.selectedIndex == PaymentShippingHeader.SavedCards {
            return 58
        }else {
            return 78
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var superCell = UITableViewCell()
        if segment_Options.selectedIndex == PaymentShippingHeader.SavedCards {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCardCell", for: indexPath) as! SavedCardCell
            cell.configureCell(item: checkoutService.array_CardDetails[indexPath.section])
            superCell = cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
            cell.configureCell(item: self.array_Addresses[indexPath.section])
            superCell = cell
        }
        superCell.selectionStyle = .none
        return superCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segment_Options.selectedIndex == PaymentShippingHeader.SavedCards {
        }else {
        }
    }
    //MARK:- Table Editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.view.setNeedsLayout()
    }
    
   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if segment_Options.selectedIndex == PaymentShippingHeader.SavedCards {
            let kDeleteActionWidth = CGFloat(75.0)// The width you want of delete button
            let kDeleteActionHeight = CGFloat(58) // The height you want of delete button
            let whitespace = whitespaceString(width: kDeleteActionWidth,height:kDeleteActionHeight)
            
            //Delete
            let deleteAction = UITableViewRowAction(style: .default, title: whitespace) {_,_ in
                AlertController.SHOW_ALERT_CONTROLLER_DOUBLE_BUTTON(alertTitle: "Confirmation", message: "Are you sure you want to delete selected card?", btnTitle1: "No", btnTitle2: "Yes", viewController: self) { (response) in
                    if response.caseInsensitiveCompare("Button2") == .orderedSame {
                        self.callDeleteCard(card: self.checkoutService.array_CardDetails[indexPath.section])
                    }
                }
            }
            
            
            // create a color from patter image and set the color as a background color of action
            let view_Main = UIView(frame: CGRect(x: tableView.frame.size.width-kDeleteActionWidth, y: 0, width: kDeleteActionWidth, height: kDeleteActionHeight))
            view_Main.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.0862745098, blue: 0.1411764706, alpha: 1)
            view_Main.layer.cornerRadius = 0.0
            view_Main.clipsToBounds = true
            
            let view_Delete = UIView(frame: CGRect(x: 6, y: 0, width: kDeleteActionWidth-8, height: kDeleteActionHeight))
            view_Delete.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.1411764706, blue: 0.2549019608, alpha: 1) // background color of view
            view_Delete.layer.cornerRadius = 6.0
            view_Delete.clipsToBounds = true
            view_Main.addSubview(view_Delete)
            
            let img_View = UIImageView(frame: CGRect(x: ((kDeleteActionWidth/2)-8.5)+4, y: (kDeleteActionHeight/2)-9, width: 17, height: 18))
            img_View.image = UIImage(named: "delete-icon")! // required image
            img_View.contentMode = .center
            view_Main.addSubview(img_View)
            
            let image_Delete = view_Main.image()
            // deleteAction.backgroundColor = UIColor.clear
             deleteAction.backgroundColor = UIColor.init(patternImage: image_Delete)
         
            return [deleteAction]
        }else {
            let kDeleteActionWidth = CGFloat(75.0)// The width you want of delete button
            let kDeleteActionHeight = CGFloat(78) // The height you want of delete button
            let whitespace = whitespaceString(width: kDeleteActionWidth,height:kDeleteActionHeight)
            
            //Delete
            let deleteAction = UITableViewRowAction(style: .default, title: whitespace) {_,_ in
                AlertController.SHOW_ALERT_CONTROLLER_DOUBLE_BUTTON(alertTitle: "Confirmation", message: "Are you sure you want to delete selected address?", btnTitle1: "No", btnTitle2: "Yes", viewController: self) { (response) in
                    if response.caseInsensitiveCompare("Button2") == .orderedSame {
                        //Delet address API
                        self.callDeleteAddress(address: self.array_Addresses[indexPath.section])
                    }
                }
            }
            
            // create a color from patter image and set the color as a background color of action
            let view_Main = UIView(frame: CGRect(x: tableView.frame.size.width-kDeleteActionWidth, y: 0, width: kDeleteActionWidth, height: kDeleteActionHeight))
            view_Main.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.0862745098, blue: 0.1411764706, alpha: 1)
            view_Main.layer.cornerRadius = 0.0
            view_Main.clipsToBounds = true
            
            let view_Delete = UIView(frame: CGRect(x: 6, y: 0, width: kDeleteActionWidth-8, height: kDeleteActionHeight))
            view_Delete.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.1411764706, blue: 0.2549019608, alpha: 1) // background color of view
            view_Delete.layer.cornerRadius = 6.0
            view_Delete.clipsToBounds = true
            view_Main.addSubview(view_Delete)
            
            let img_View = UIImageView(frame: CGRect(x: ((kDeleteActionWidth/2)-8.5)+4, y: (kDeleteActionHeight/2)-9, width: 17, height: 18))
            img_View.image = UIImage(named: "delete-icon")! // required image
            img_View.contentMode = .center
            view_Main.addSubview(img_View)
            
            let image_Delete = view_Main.image()
            deleteAction.backgroundColor = UIColor.clear
            deleteAction.backgroundColor = UIColor.init(patternImage: image_Delete)
            
            //Edit
            let editAction = UITableViewRowAction(style: .default, title: whitespace) {_,_ in
                self.editAddress(address: self.array_Addresses[indexPath.section])
            }
            
            // create a color from patter image and set the color as a background color of action
            let view_MainEdit = UIView(frame: CGRect(x: tableView.frame.size.width-kDeleteActionWidth, y: 0, width: kDeleteActionWidth, height: kDeleteActionHeight))
            view_MainEdit.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.0862745098, blue: 0.1411764706, alpha: 1)
            view_MainEdit.layer.cornerRadius = 0.0
            view_MainEdit.clipsToBounds = true
            
            let view_Edit = UIView(frame: CGRect(x: 8, y: 0, width: kDeleteActionWidth-8, height: kDeleteActionHeight))
            view_Edit.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.1411764706, blue: 0.2549019608, alpha: 1) // background color of view
            view_Edit.layer.cornerRadius = 6.0
            view_Edit.clipsToBounds = true
            view_MainEdit.addSubview(view_Edit)
            
            let img_Edit = UIImageView(frame: CGRect(x: ((kDeleteActionWidth/2)-9)+4, y: (kDeleteActionHeight/2)-9, width: 19, height: 19))
            img_Edit.image = UIImage(named: "edit_icon")! // required image
            img_Edit.contentMode = .center
            view_MainEdit.addSubview(img_Edit)
            
            let image_Edit = view_MainEdit.image()
            editAction.backgroundColor = UIColor.clear
            editAction.backgroundColor = UIColor.init(patternImage: image_Edit)
            
            return [deleteAction, editAction]
        }
    }
    /*func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //Delete
        if segment_Options.selectedIndex == PaymentShippingHeader.SavedCards {
            //Delete
            let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {_,_ in
                AlertController.SHOW_ALERT_CONTROLLER_DOUBLE_BUTTON(alertTitle: "Confirmation", message: "Are you sure you want to delete selected card?", btnTitle1: "No", btnTitle2: "Yes", viewController: self) { (response) in
                    if response.caseInsensitiveCompare("Button2") == .orderedSame {
                        self.callDeleteCard(card: self.checkoutService.array_CardDetails[indexPath.section])
                    }
                }
            }
            return [deleteAction]
        }else {
            //Delete
            let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {_,_ in
                AlertController.SHOW_ALERT_CONTROLLER_DOUBLE_BUTTON(alertTitle: "Confirmation", message: "Are you sure you want to delete selected address?", btnTitle1: "No", btnTitle2: "Yes", viewController: self) { (response) in
                    if response.caseInsensitiveCompare("Button2") == .orderedSame {
                        //Delet address API
                        self.callDeleteAddress(address: self.array_Addresses[indexPath.section])
                    }
                }
            }
            //Edit
            let editAction = UITableViewRowAction(style: .normal, title: "Edit") {_,_ in
                self.editAddress(address: self.array_Addresses[indexPath.section])
            }
            return [deleteAction, editAction]
        }
    }*/
 
    
    fileprivate func whitespaceString(font: UIFont = UIFont.systemFont(ofSize: 4), width: CGFloat,height:CGFloat) -> String {
        let kPadding: CGFloat = 40
        let mutable = NSMutableString(string: "")
        let text_Font = UIFont(name: Constants.REGULAR_FONT, size: 12)!
        let attribute = [NSAttributedString.Key.font: text_Font]
        while mutable.size(withAttributes: attribute).width < width - (2 * kPadding) {
            mutable.append("")
        }
        return mutable as String
    }
}

extension UIView {
    var allSubViews : [UIView] {
        var array = [self.subviews].flatMap {$0}
        array.forEach { array.append(contentsOf: $0.allSubViews) }
        return array
    }
}

//MARK:-  API CALLS
extension PaymentShippingManagementVC {
    @objc func callFetchShippingAddress() {
        checkoutService.array_ShippingAddress.removeAll()
        checkoutService.callFetchShippingAddressAPI(showLoader: true, completionBlockSuccess: { (response) -> Void in
            // your successful handle
            self.setUpAddressData()
            print(response)
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    @objc func callFetchUserCardDetails() {
        checkoutService.array_CardDetails.removeAll()
        checkoutService.callfetchUserCardDetailsAPI(context: "CARD_LIST", showLoader: true, completionBlockSuccess: { (response) -> Void in
            // your successful handle
            self.table_PaymentShipping.reloadData()
            print(response)
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    
    func callDeleteAddress(address: ShippingAddress) {
        checkoutService.callDeleteShippingAddressAPI(addressId: address.id, showLoader: true, completionBlockSuccess: { (response) in
            let index = self.checkoutService.array_ShippingAddress.index{ $0.id == address.id }
            if index != nil{
                self.checkoutService.array_ShippingAddress.remove(at: index!)
            }
            self.setUpAddressData()
            
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    
    func callDeleteCard(card: CardDetail) {
        let params: [String:Any] = ["card_id": card.card_id]
        checkoutService.callDeleteCardAPI(parameters: params, showLoader: true, completionBlockSuccess: { (response) in
            let index = self.checkoutService.array_CardDetails.index{ $0.card_id == card.card_id }
            if index != nil{
                self.checkoutService.array_CardDetails.remove(at: index!)
            }
            self.table_PaymentShipping.reloadData()
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
}
