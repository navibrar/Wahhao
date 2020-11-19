//  Created by apple on 6/26/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit
import Stripe

protocol AddressDelegate {
    func addShippingAddress(checkoutPreferences: CheckoutProtocolModel?)
    func editShippingAddress(checkoutPreferences: CheckoutProtocolModel?)
    func addBillingAddress(checkoutPreferences: CheckoutProtocolModel?)
}
protocol AddCardPaymentMethodDelegate {
    func addPaymentMethod(checkoutPreferences: CheckoutProtocolModel?)
}
protocol ThankYouScreenDelegate {
    func navigateToThankYouVC()
}
protocol ShowProductDetailDelegate {
    func navigateToProductDetailVC(product: Product, isShowCartButtons: Bool, checkoutPreferences: CheckoutProtocolModel?)
}

private enum CheckoutTableHeader: Int {
    case ItemToBuy = 0
    case ShippingAddress
    case PaymentOption
    case OrderSummary
}

class CheckoutVC: UIViewController {
    //MARK:- Protocols
    var addressDelegate: AddressDelegate!
    var paymentMethodDelegate: AddCardPaymentMethodDelegate!
    var thankYouScreenDelegate: ThankYouScreenDelegate!
    var showProductDetailDelegate: ShowProductDetailDelegate!
    //Protocol Variables
    var checkoutPreferences: CheckoutProtocolModel? = nil
    
    //MARK:- Variable Declaration
    let checkoutService = CheckoutServices.sharedInstance
    var baseViewInitialHeight : CGFloat = 320
    var array_Sections = [CheckoutHeader]()
    var array_OrderSummary = [OrderSummary]()
    
    
    //MARK:- Outlet Connections
    @IBOutlet weak var transparentBackView: UIView!
    @IBOutlet weak var checkOutLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var table_Checkout: UITableView!
    @IBOutlet weak var constraint_ContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btn_Checkout: UIButton!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.transparentBackView.addGestureRecognizer(tapGesture)
        self.transparentBackView.isUserInteractionEnabled = true
        
        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipedown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipedown)
        
        initialSetup()
        self.perform(#selector(self.callFetchShippingAddress), with: self, afterDelay: 0.1)
        
         FirAnalytics.trackPageView(withScreen: FirAnalytics.Screen.checkOut)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIView.animate(withDuration: 0.75, delay: 0.4, options: .allowUserInteraction, animations: {
            self.transparentBackView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Gesture Method
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                self.moveBack()
            default:
                break
            }
        }
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.moveBack()
    }
    
    //MARK:- Custom Methods
    func initialSetup() {
        self.contentView.isHidden = false
        
        contentView.topRoundCornners(radius: 37)
        //blurEffectView.topRoundCornnersVisualEffect(radius: 37)
        table_Checkout.tableFooterView = UIView()
        //Headers
        table_Checkout.register(UINib(nibName: "OrderSummaryHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "OrderSummaryHeaderView")
        table_Checkout.register(UINib(nibName: "PaymentMethodHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "PaymentMethodHeaderView")
        table_Checkout.register(UINib(nibName: "ShippingAddressHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ShippingAddressHeaderView")
        
        //Table Cells
        table_Checkout.register(UINib(nibName: "ShippingAddressCell", bundle: nil), forCellReuseIdentifier: "ShippingAddressCell")
        table_Checkout.register(UINib(nibName: "AddBillingAddressCell", bundle: nil), forCellReuseIdentifier: "AddBillingAddressCell")
        table_Checkout.register(UINib(nibName: "EditBillingAddressCell", bundle: nil), forCellReuseIdentifier: "EditBillingAddressCell")
        table_Checkout.register(UINib(nibName: "AddNewOptionCell", bundle: nil), forCellReuseIdentifier: "AddNewOptionCell")
        table_Checkout.register(UINib(nibName: "PaymentMethodCell", bundle: nil), forCellReuseIdentifier: "PaymentMethodCell")
        table_Checkout.register(UINib(nibName: "OrderSummaryCell", bundle: nil), forCellReuseIdentifier: "OrderSummaryCell")
        table_Checkout.register(UINib(nibName: "CheckoutItemCell", bundle: nil), forCellReuseIdentifier: "CheckoutItemCell")
        self.getViewHeight()
    }
    
    func setUpData() {
        self.canCheckout()
        if self.checkoutPreferences?.array_ItemsToBuy.count != 0 {
            self.calculateTotalItems()
        }else {
            checkOutLabel.text = "CHECKOUT"
        }
        //Product Header
        let dict_CartItem: NSDictionary = ["title": "", "description": "", "image": UIImage(), "isExpaned": false, "isDataAvailable": false]
        
        //Shipping Address Header
        var dict_Shipping = NSDictionary()
        if self.checkoutService.array_ShippingAddress.count > 0 {
            if (self.checkoutPreferences?.shippingAddressId)! > 0 {
               let filtered = self.checkoutService.array_ShippingAddress.filter({$0.id == self.checkoutPreferences?.shippingAddressId})
                if filtered.count > 0 {
                    let index = self.checkoutService.array_ShippingAddress.index(where: { $0.id == self.checkoutPreferences?.shippingAddressId })!
                    self.checkoutService.array_ShippingAddress[index].isSelected = true
                    self.checkoutPreferences?.shippingAddressId = self.checkoutService.array_ShippingAddress[index].id
                    dict_Shipping = createShippingHeader(desc: self.checkoutService.array_ShippingAddress[index].address1, image: UIImage(), isExpanded: self.checkoutPreferences?.isAddressFieldOpen ?? false, isDataAvailable: true)
                }else {
                    dict_Shipping = createShippingHeader(desc: "", image: UIImage(), isExpanded: self.checkoutPreferences?.isAddressFieldOpen ?? false, isDataAvailable: true)
                }
            }else {
                dict_Shipping = createShippingHeader(desc: "", image: UIImage(), isExpanded: self.checkoutPreferences?.isAddressFieldOpen ?? false, isDataAvailable: true)
            }
        }else {
            dict_Shipping = createShippingHeader(desc: "Add Shipping", image: UIImage(), isExpanded: false, isDataAvailable: false)
        }
        
        //Payment Header
        var dict_Payment = NSDictionary()
        if self.checkoutService.array_CardDetails.count > 0 {
            if self.checkoutPreferences?.paymentDetails != nil {
                let filtered = self.checkoutService.array_CardDetails.filter({$0.card_id == self.checkoutPreferences?.paymentDetails?.card_id})
                if filtered.count > 0 {
                    let index = self.checkoutService.array_CardDetails.index(where: { $0.card_id == filtered[0].card_id })!
                    self.checkoutService.array_CardDetails[index].isSelected = true
                    let cardImage = getCardImage(brand: self.checkoutService.array_CardDetails[index].brand)
                    dict_Payment = createPaymentHeader(desc: self.checkoutService.array_CardDetails[index].last4digits, image: cardImage, isExpanded: self.checkoutPreferences?.isPaymentFieldOpen ?? false, isDataAvailable: true)
                }else {
                    dict_Payment = createPaymentHeader(desc: "", image: UIImage(), isExpanded: self.checkoutPreferences?.isPaymentFieldOpen ?? false, isDataAvailable: true)
                }
            }else {
                dict_Payment = createPaymentHeader(desc: "", image: UIImage(), isExpanded: self.checkoutPreferences?.isPaymentFieldOpen ?? false, isDataAvailable: true)
            }
        }else {
            dict_Payment = createPaymentHeader(desc: "Add Payment", image: UIImage(), isExpanded: false, isDataAvailable: false)
        }
        
        array_Sections.removeAll()
        array_Sections.append(CheckoutHeader(dictionary: dict_CartItem))
        array_Sections.append(CheckoutHeader(dictionary: dict_Shipping))
        array_Sections.append(CheckoutHeader(dictionary: dict_Payment))
        
        //Order Summary
        self.calculateOrderSummaryAndCreateHeader()
        
        self.table_Checkout.reloadData()
        self.adjustViewHeight()
    }
    func createPaymentHeader(desc: String, image: UIImage, isExpanded: Bool, isDataAvailable: Bool) -> NSDictionary {
        return ["title": "Payment", "description": desc, "image": image, "isExpaned": isExpanded, "isDataAvailable": isDataAvailable]
    }
    func createShippingHeader(desc: String, image: UIImage, isExpanded: Bool, isDataAvailable: Bool) -> NSDictionary {
        return ["title": "Shipping", "description": desc, "image": image, "isExpaned": isExpanded, "isDataAvailable": isDataAvailable]
    }
    
    func calculateTotalItems() {
        var totalQuantity: Int = 0
        for item in self.checkoutPreferences?.array_ItemsToBuy ?? [] {
            let qtyStr = (item?.quantity == "" ? "1" : item?.quantity)! as String
            let quantity: Int = Int(qtyStr)!
            totalQuantity += quantity
        }
        if totalQuantity == 1 {
            checkOutLabel.text = "CHECKOUT (1 ITEM)"
        }else {
            checkOutLabel.text = "CHECKOUT (\(totalQuantity) ITEMS)"
        }
    }
    func calculateOrderSummaryAndCreateHeader()  {
        //Order Summary
        let totalPriceStr = formatPriceToTwoDecimalPlace(amount: getCartItemsTotalPrice())
        //Order Summary Header
        let dict_OrderSummary: NSDictionary = ["title": "Order Summary", "description": totalPriceStr, "image": UIImage(), "isExpaned": self.checkoutPreferences?.isOrderSummaryOpen ?? false, "isDataAvailable": true]
        array_Sections.append(CheckoutHeader(dictionary: dict_OrderSummary))
        
        //Order Summary
        let summary1: NSDictionary = ["title": "ITEM(S) SUBTOTAL", "description": totalPriceStr]
        let summary2: NSDictionary = ["title": "Shipping Charges", "description": "Free"]
        let summary3: NSDictionary = ["title": "Grand Total", "description": totalPriceStr]
        array_OrderSummary.append(OrderSummary(dictionary: summary1))
        array_OrderSummary.append(OrderSummary(dictionary: summary2))
        array_OrderSummary.append(OrderSummary(dictionary: summary3))
    }
    func getCartItemsTotalPrice() -> Float {
        var totalPrice: Float = 0
        for item in self.checkoutPreferences?.array_ItemsToBuy ?? [] {
            let qtyStr = (item?.quantity == "" ? "1" : item?.quantity)! as NSString
            let quantity: Float = qtyStr.floatValue
            let priceStr = (item?.product.final_price == "" ? "1" : item?.product.final_price)! as NSString
            let price: Float =  priceStr.floatValue
            totalPrice += quantity*price
        }
        return totalPrice
    }
    func updateOrderSummary() {
       let totalPriceStr = formatPriceToTwoDecimalPlace(amount: getCartItemsTotalPrice())
        array_Sections[CheckoutTableHeader.OrderSummary.rawValue].description = totalPriceStr
        array_OrderSummary[0].description = totalPriceStr
        array_OrderSummary[2].description = totalPriceStr
        UIView.performWithoutAnimation {
            table_Checkout.beginUpdates()
            table_Checkout.reloadSections(IndexSet(integer: CheckoutTableHeader.OrderSummary.rawValue), with: .none)
            table_Checkout.endUpdates()
        }
    }
    func moveBack() {
        let filtered = checkoutService.array_CardDetails.filter({$0.isSavedForFasterPurchase == false})
        if filtered.count > 0 {
          self.callDeleteCard()
        }else {
            self.dismissController()
        }
    }
    func dismissController() {
        self.transparentBackView.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    func moveToAddNewCardVC() {
        self.dismiss(animated: false) {
            self.paymentMethodDelegate.addPaymentMethod(checkoutPreferences: self.checkoutPreferences)
        }
    }
    func moveToAddShippingAddressVC() {
        self.dismiss(animated: false) {
            self.checkoutPreferences?.isAddressFieldOpen = true
            self.addressDelegate.addShippingAddress(checkoutPreferences: self.checkoutPreferences)
        }
    }
    func moveToEditShippingAddressVC() {
        self.dismiss(animated: false) {
            self.checkoutPreferences?.isAddressFieldOpen = true
            self.addressDelegate.editShippingAddress(checkoutPreferences: self.checkoutPreferences)
        }
    }
    func moveToAddBillingAddressVC() {
        self.dismiss(animated: false) {
            self.addressDelegate.addBillingAddress(checkoutPreferences: self.checkoutPreferences)
        }
    }
    func moveToEditBillingAddressVC() {
        self.dismiss(animated: false) {
            self.addressDelegate.addBillingAddress(checkoutPreferences: self.checkoutPreferences)
        }
    }
    func moveToProductDetailVC(product: Product) {
        self.dismiss(animated: false) {
            self.showProductDetailDelegate.navigateToProductDetailVC(product: product, isShowCartButtons: true, checkoutPreferences: self.checkoutPreferences)
        }
    }
    func openAddressSection() {
        self.checkoutPreferences?.isAddressFieldOpen = true
        self.checkoutPreferences?.isPaymentFieldOpen = false
        self.checkoutPreferences?.isOrderSummaryOpen = false
    }
    func openPaymentSection() {
        self.checkoutPreferences?.isAddressFieldOpen = false
        self.checkoutPreferences?.isPaymentFieldOpen = true
        self.checkoutPreferences?.isOrderSummaryOpen = false
    }
    func openOrderSummarySection() {
        self.checkoutPreferences?.isAddressFieldOpen = false
        self.checkoutPreferences?.isPaymentFieldOpen = false
        self.checkoutPreferences?.isOrderSummaryOpen = true
    }
    func closeAllSections() {
        self.checkoutPreferences?.isAddressFieldOpen = false
        self.checkoutPreferences?.isPaymentFieldOpen = false
        self.checkoutPreferences?.isOrderSummaryOpen = false
    }
    func canCheckout() {
        if (self.checkoutPreferences?.array_ItemsToBuy.count)! > 0 && checkoutPreferences?.shippingAddressId != nil && (self.checkoutPreferences?.billingAddress != nil || self.checkoutPreferences?.isBillingAddressSimilarToShippingAddress == true) && self.checkoutPreferences?.paymentDetails != nil{
            btn_Checkout.alpha = 1.0
            //btn_Checkout.isUserInteractionEnabled = true
        }else {
            btn_Checkout.alpha = 0.5
            //btn_Checkout.isUserInteractionEnabled = false
        }
    }
    //MARK:- Button Actions
    @IBAction func checkoutNowTapped(_ sender: UIButton) {
        if self.checkoutPreferences?.array_ItemsToBuy.count == 0 {
            showAlertWithMessage(title: "", message: "Please add product in your cart to purchase.")
            return
        }
        if checkoutService.array_ShippingAddress.count == 0 {
            showAlertWithMessage(title: "", message: "Please add your shipping address.")
            return
        }
        let selectedAddress = checkoutService.array_ShippingAddress.filter({$0.isSelected == true})
        if selectedAddress.count == 0 || (selectedAddress.count > 0 && selectedAddress[0].isSelected == false) {
            showAlertWithMessage(title: "", message: "Please select your shipping address.")
            return
        }
        if self.checkoutPreferences?.billingAddress == nil && self.checkoutPreferences?.isBillingAddressSimilarToShippingAddress == false {
            showAlertWithMessage(title: "", message: "Please add your billing address.")
            return
        }
        if checkoutService.array_CardDetails.count == 0 {
            showAlertWithMessage(title: "", message: "Please add your payment details.")
            return
        }
        let selectedPaymentDetails = checkoutService.array_CardDetails.filter({$0.isSelected == true})
        if selectedPaymentDetails.count == 0 {
            showAlertWithMessage(title: "", message: "Please select your payment details.")
            return
        }
        var orderDetails = [NSDictionary]()
        for item in self.checkoutPreferences?.array_ItemsToBuy ?? [] {
            let dict: NSDictionary = [
                "product_id": item?.product.variant_id ?? "",
                "qty": item?.quantity ?? "0",
                "price": item?.product.final_price ?? "NA",
                "variant_id": item?.product.variant_id ?? "",
                "review_id": self.checkoutPreferences?.review_id ?? ""
            ]
            orderDetails.append(dict)
        }
        var dict_BillingAddress: [String: Any] = [:]
        if self.checkoutPreferences?.isBillingAddressSimilarToShippingAddress == false  {
            let filtered = self.checkoutService.array_States.filter({$0.name.caseInsensitiveCompare(self.checkoutPreferences!.billingAddress?.province ?? "") == .orderedSame})
            var stateCode = ""
            if filtered.count > 0 {
                stateCode = filtered[0].code
            }
            dict_BillingAddress = [
                "full_name": self.checkoutPreferences?.billingAddress!.full_name ?? "",
                              "address1": self.checkoutPreferences?.billingAddress!.address1 ?? "",
                              "address2": self.checkoutPreferences?.billingAddress!.address2 ?? "",
                              "zipcode": self.checkoutPreferences?.billingAddress!.zipcode ?? "",
                              "city": self.checkoutPreferences?.billingAddress!.city ?? "",
                              "province": self.checkoutPreferences?.billingAddress!.province ?? "",
                              "province_code": stateCode,
                              "latitude": "",
                              "longitude": "",
                              "country_code": "1",
                              "phone": self.checkoutPreferences?.billingAddress?.phone ?? "",
                              "country": "US"
            ]
        }
        let parameters: [String:Any] = [
        "payment_gateway_name": "STRIPE",//In current phase only stripe payment gateway is used
        "currency":"USD",
        "total_price": getCartItemsTotalPrice(),
        "card_id":self.checkoutPreferences?.paymentDetails?.card_id ?? "",
        "order_details":orderDetails,
        "order_country_code": ConfigurationManager.CountryCode.US.rawValue.replacingOccurrences(of: "+", with: ""),
        "transaction_id": "",//Not in use now
        "shipping_address": selectedAddress[0].id,
        "shipping_billing_address_same": self.checkoutPreferences?.isBillingAddressSimilarToShippingAddress ?? false,
        "billing_address": dict_BillingAddress,
        "is_clear_cart": self.checkoutPreferences?.isClearCart ?? false
        ]
        self.callPlaceOrder(parameters: parameters)
    }
    
    //MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

//MARK:- UITableViewDelegate & UITableViewDataSource
extension CheckoutVC: UITableViewDelegate, UITableViewDataSource {
    //MARK:- UITableCustomMethods
    @objc func tableHeaderTapGesture(gestureRecognizer: UIGestureRecognizer) {
        let selectedSectionHeaderTag = gestureRecognizer.view?.tag
        for section in 0..<array_Sections.count {
            if section == selectedSectionHeaderTag && section == CheckoutTableHeader.ShippingAddress.rawValue {
                if self.checkoutService.array_ShippingAddress.count > 0 {
                    array_Sections[section].isExpaned = !array_Sections[section].isExpaned
                }else {
                    array_Sections[section].isExpaned = false
                    self.moveToAddShippingAddressVC()
                }
            }else if section == selectedSectionHeaderTag && section == CheckoutTableHeader.PaymentOption.rawValue {
                if self.checkoutService.array_CardDetails.count > 0 {
                    array_Sections[section].isExpaned = !array_Sections[section].isExpaned
                }else {
                    array_Sections[section].isExpaned = false
                    self.moveToAddNewCardVC()
                }
            }else if section == selectedSectionHeaderTag && section == CheckoutTableHeader.OrderSummary.rawValue {
                array_Sections[section].isExpaned = !array_Sections[section].isExpaned
            }else {
                array_Sections[section].isExpaned = false
            }
        }
        let filteredSections = array_Sections.filter({$0.isExpaned == true})
        if filteredSections.count > 0 {
            if filteredSections[0].title.caseInsensitiveCompare("Shipping") == .orderedSame {
               self.openAddressSection()
            }else if filteredSections[0].title.caseInsensitiveCompare("Payment") == .orderedSame {
                self.openPaymentSection()
            }else if filteredSections[0].title.caseInsensitiveCompare("Order Summary") == .orderedSame {
                self.openOrderSummarySection()
            }else {
                self.closeAllSections()
            }
        }else {
            self.closeAllSections()
        }
        self.canCheckout()
        self.adjustViewHeight()
    }
    
    func adjustViewHeight() {
        DispatchQueue.main.async {
            self.table_Checkout.reloadData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            print(self.table_Checkout.contentSize.height)
            UIView.animate(withDuration: 0.5, animations: {
                self.getViewHeight()
                self.view.layoutIfNeeded()
            }) { (success) in
            }
        }
    }
    func getViewHeight() {
        /*let viewHeightExcludingTableView: CGFloat = 180
         let cartViewController = String(describing: CartViewController.self)
         if self.checkoutPreferences?.classWhereProductIsAdded !=  cartViewController{
         self.table_Checkout.layoutIfNeeded()
         }
         var newHeight = self.table_Checkout.contentSize.height + viewHeightExcludingTableView
         let defaultContentHeight: CGFloat = 455.0
         if newHeight == viewHeightExcludingTableView {
         newHeight = defaultContentHeight
         }
         let usableHeight = self.view.bounds.height - 105
         if newHeight >= usableHeight {
         self.constraint_ContentViewHeight.constant = usableHeight
         }else {
         self.constraint_ContentViewHeight.constant = newHeight
         }*/
        var navigationViewHeight: CGFloat = 0
        let filtered = array_Sections.filter({$0.isExpaned == true})
        let defaultContentHeight: CGFloat = 455.0
        if filtered.count == 0  {
            let contentHeight = table_Checkout.contentSize.height + 180
            navigationViewHeight = self.view.bounds.height - (contentHeight == 180 ? defaultContentHeight : contentHeight)
        }else {
            navigationViewHeight = 105
        }
        self.constraint_ContentViewHeight.constant = self.view.bounds.height - navigationViewHeight
    }
    
    @objc func addNewOptionTapped(sender:UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.table_Checkout)
        if let indexPath = self.table_Checkout.indexPathForRow(at: buttonPosition) {
            if indexPath.section == CheckoutTableHeader.ShippingAddress.rawValue {
                //Add Shipping Address
                print("Add Shipping Address")
                self.moveToAddShippingAddressVC()
            }else if indexPath.section == CheckoutTableHeader.PaymentOption.rawValue {
                //Add Payment Method
                print("Add Payment Method")
                self.moveToAddNewCardVC()
            }
            print(indexPath.row)
        }
    }
    
    @objc func EditShippingAddressTapped(sender:UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.table_Checkout)
        if let indexPath = self.table_Checkout.indexPathForRow(at: buttonPosition) {
            print(self.checkoutService.array_ShippingAddress[indexPath.row])
            self.checkoutPreferences?.shippingAddress = self.checkoutService.array_ShippingAddress[indexPath.row]
            self.moveToEditShippingAddressVC()
        }
    }
    @objc func increaseProductQuantity(sender: UIButton){
        let indexPath = IndexPath(row:sender.tag, section: CheckoutTableHeader.ItemToBuy.rawValue)
        let cell = table_Checkout.cellForRow(at: indexPath) as! CheckoutItemCell
        var product = self.checkoutPreferences!.array_ItemsToBuy[indexPath.row]
        
        if (product!.quantityCount < product!.product.qtyCount) {
            let quantityCount = product!.quantityCount + 1
            let quantity = "\(quantityCount)"
            cell.lbl_ProductQty.text = "\(quantity)"
            product?.quantity = quantity
            product?.quantityCount = quantityCount
            self.checkoutPreferences?.array_ItemsToBuy[indexPath.row] = product
            self.updateOrderSummary()
            self.calculateTotalItems()
        }
        if (product!.quantityCount < product!.product.qtyCount) {
            cell.btn_DecreaseQty.alpha = 1.0
        }else {
            cell.btn_IncreaseQty.alpha = 0.45
            self.showToastMessage(message: "This quantity is not available at the moment")
        }
        
    }
    @objc func decreaseProductQuantity(sender: UIButton){
        let indexPath = IndexPath(row:sender.tag, section: CheckoutTableHeader.ItemToBuy.rawValue)
        let cell = table_Checkout.cellForRow(at: indexPath) as! CheckoutItemCell
        var product = self.checkoutPreferences!.array_ItemsToBuy[indexPath.row]
        
        if (product!.quantityCount > 1) {
            let quantityCount = product!.quantityCount - 1
            let quantity = "\(quantityCount)"
            cell.lbl_ProductQty.text = "\(quantity)"
            product?.quantity = quantity
            product?.quantityCount = quantityCount
            self.checkoutPreferences?.array_ItemsToBuy[indexPath.row] = product
            self.updateOrderSummary()
            self.calculateTotalItems()
        }
        if (product!.quantityCount == 1) {
            cell.btn_DecreaseQty.alpha = 0.45
        }else {
            cell.btn_IncreaseQty.alpha = 1.0
        }
    }
    @objc func addBillingAddress(sender: UIButton){
        self.moveToAddBillingAddressVC()
    }
    @objc func editBillingAddress(sender: UIButton){
        self.moveToEditBillingAddressVC()
    }
    @objc func addBillingAddressSimilarToShippingAddress(sender: UIButton){
        let buttonPosition = sender.convert(CGPoint.zero, to: self.table_Checkout)
        if let indexPath = self.table_Checkout.indexPathForRow(at: buttonPosition) {
            let cell = table_Checkout.cellForRow(at: indexPath) as! AddBillingAddressCell
            if (self.checkoutPreferences?.shippingAddressId)! > 0 {
                if self.checkoutPreferences?.isBillingAddressSimilarToShippingAddress == false {
                    self.checkoutPreferences?.isBillingAddressSimilarToShippingAddress = true
                    cell.img_SameAsShippingAddress.image = UIImage(named: "check_icon_square")
                    cell.btn_AddAddress.alpha = 0.3
                    cell.btn_AddAddress.isUserInteractionEnabled = false
                }else {
                    self.checkoutPreferences?.isBillingAddressSimilarToShippingAddress = false
                    cell.img_SameAsShippingAddress.image = UIImage(named: "uncheck_icon_square")
                    cell.btn_AddAddress.alpha = 1.0
                    cell.btn_AddAddress.isUserInteractionEnabled = true
                }
            }else {
              self.showToastMessage(message: "Shipping address not selected")
            }
        }
        self.canCheckout()
    }
    @objc func editBillingAddressSimilarToShippingAddress(sender: UIButton){
        let buttonPosition = sender.convert(CGPoint.zero, to: self.table_Checkout)
        if let indexPath = self.table_Checkout.indexPathForRow(at: buttonPosition) {
            let cell = table_Checkout.cellForRow(at: indexPath) as! EditBillingAddressCell
            if (self.checkoutPreferences?.shippingAddressId)! > 0 {
                if self.checkoutPreferences?.isBillingAddressSimilarToShippingAddress == false {
                    self.checkoutPreferences?.isBillingAddressSimilarToShippingAddress = true
                    cell.img_SameAsShippingAddress.image = UIImage(named: "check_icon_square")
                    cell.view_Address.alpha = 0.3
                    cell.view_Address.isUserInteractionEnabled = false
                }else {
                    self.checkoutPreferences?.isBillingAddressSimilarToShippingAddress = false
                    cell.img_SameAsShippingAddress.image = UIImage(named: "uncheck_icon_square")
                    cell.view_Address.alpha = 1.0
                    cell.view_Address.isUserInteractionEnabled = true
                }
            }else {
                self.showToastMessage(message: "Shipping address not selected")
            }
        }
        self.canCheckout()
    }
    func getDeliveryDate(daysToAdd: Int) -> String {
        //Dec 08, 2018
        var dateComponent = DateComponents()
        dateComponent.day = daysToAdd
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let deliveryDate = formatter.string(from: futureDate!)
        return deliveryDate
    }
    //MARK:-
    func numberOfSections(in tableView: UITableView) -> Int {
        return array_Sections.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == CheckoutTableHeader.ItemToBuy.rawValue ? 0 : 41
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var superHeader = UIView()
        if section == CheckoutTableHeader.ItemToBuy.rawValue {
            //ITEM HEADER
            let view = UIView()
            view.backgroundColor = UIColor.clear
            superHeader = view
        }else if section == CheckoutTableHeader.ShippingAddress.rawValue {
            //SHIPPING ADDRESS HEADER
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ShippingAddressHeaderView") as! ShippingAddressHeaderView
            headerView.tintColor = UIColor.clear
            headerView.configureHeader(item: array_Sections[section])
            superHeader = headerView
        }else if section == CheckoutTableHeader.PaymentOption.rawValue {
            //PAYMENT OPTION HEADER
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PaymentMethodHeaderView") as! PaymentMethodHeaderView
            headerView.tintColor = UIColor.clear
            headerView.configureHeader(item: array_Sections[section])
            superHeader = headerView
        }else if section == CheckoutTableHeader.OrderSummary.rawValue {
            //ORDER SUMMARY HEADER
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "OrderSummaryHeaderView") as! OrderSummaryHeaderView
            headerView.tintColor = UIColor.clear
            headerView.configureHeader(item: array_Sections[section])
            superHeader = headerView
        }
        superHeader.tag = section
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableHeaderTapGesture(gestureRecognizer:)))
        superHeader.addGestureRecognizer(tapGesture)
        return superHeader
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == CheckoutTableHeader.ItemToBuy.rawValue {
            let cartViewController = String(describing: CartViewController.self)
            return (self.checkoutPreferences?.classWhereProductIsAdded ==  cartViewController) ? 0 : 24
        }else if section == CheckoutTableHeader.OrderSummary.rawValue {
            return 0
        }else {
            return 8
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = Int()
        if section == CheckoutTableHeader.ItemToBuy.rawValue {
            let cartViewController = String(describing: CartViewController.self)
            if self.checkoutPreferences?.classWhereProductIsAdded ==  cartViewController{
                rowCount = 0
            }else {
                rowCount = 1
            }
        }else if section == CheckoutTableHeader.ShippingAddress.rawValue {
            if array_Sections[section].isExpaned == false {
                rowCount = 0
            }else {
                rowCount = self.checkoutService.array_ShippingAddress.count+2
            }
        }else if section == CheckoutTableHeader.PaymentOption.rawValue {
            if array_Sections[section].isExpaned == false {
                rowCount = 0
            }else {
                rowCount = self.checkoutService.array_CardDetails.count+1
            }
        }else if section == CheckoutTableHeader.OrderSummary.rawValue {
            if array_Sections[section].isExpaned == false {
                rowCount = 0
            }else {
                rowCount = array_OrderSummary.count
            }
        }
        return rowCount
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == CheckoutTableHeader.ItemToBuy.rawValue {
            let cartViewController = String(describing: CartViewController.self)
            return (self.checkoutPreferences?.classWhereProductIsAdded ==  cartViewController) ? 0 : 112
        }else if indexPath.section == CheckoutTableHeader.PaymentOption.rawValue {
            return 41
        }else {
            return 80
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var superCell = UITableViewCell()
        if indexPath.section == CheckoutTableHeader.ItemToBuy.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutItemCell", for: indexPath) as! CheckoutItemCell
            var deliveryDate = ""
            var isShippingAddressAdded = false
            
            let filtered = self.checkoutService.array_ShippingAddress.filter({$0.isSelected == true})
            if filtered.count > 0 {
                isShippingAddressAdded = true
                deliveryDate = self.getDeliveryDate(daysToAdd: 10)
            }else {
                isShippingAddressAdded = false
                deliveryDate = ""
            }
            var item = self.checkoutPreferences!.array_ItemsToBuy[0]!
            item.product.productDeliveryDate = deliveryDate
            cell.setValueForCell(cart: item, isShippingAddressAdded)
            cell.btn_IncreaseQty.tag = indexPath.row
            cell.btn_IncreaseQty.addTarget(self, action: #selector(self.increaseProductQuantity(sender:)), for: .touchUpInside)
            cell.btn_DecreaseQty.tag = indexPath.row
            cell.btn_DecreaseQty.addTarget(self, action: #selector(self.decreaseProductQuantity(sender:)), for: .touchUpInside)
            superCell = cell
        }else if indexPath.section == CheckoutTableHeader.ShippingAddress.rawValue {
            if indexPath.row < self.checkoutService.array_ShippingAddress.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ShippingAddressCell", for: indexPath) as! ShippingAddressCell
                cell.configureCell(item: self.checkoutService.array_ShippingAddress[indexPath.row])
                cell.btn_EditAddress.addTarget(self, action: #selector(self.EditShippingAddressTapped(sender:)), for: .touchUpInside)
                superCell = cell
            }else if indexPath.row == self.checkoutService.array_ShippingAddress.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewOptionCell", for: indexPath) as! AddNewOptionCell
                cell.btn_AddNewOption.setTitle("ADD NEW ADDRESS", for: .normal)
                cell.btn_AddNewOption.addTarget(self, action: #selector(self.addNewOptionTapped(sender:)), for: .touchUpInside)
                superCell = cell
            }else {
                let filteredAddresses = self.checkoutService.array_ShippingAddress.filter({$0.isSelected == true})
                if self.checkoutPreferences?.billingAddress != nil {
                    //Edit Billing Address
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditBillingAddressCell", for: indexPath) as! EditBillingAddressCell
                    cell.btn_EditAddress.addTarget(self, action: #selector(self.editBillingAddress(sender:)), for: .touchUpInside)
                    cell.btn_SameAsShippingAddress.addTarget(self, action: #selector(self.editBillingAddressSimilarToShippingAddress(sender:)), for: .touchUpInside)
                    cell.view_Content.bottomRoundCornners(radius: 6)
                    cell.configureCell(item: self.checkoutPreferences!.billingAddress!)
                    if self.checkoutPreferences!.isBillingAddressSimilarToShippingAddress == true {
                        cell.img_SameAsShippingAddress.image = UIImage(named: "check_icon_square")
                        cell.view_Address.alpha = 0.3
                        cell.view_Address.isUserInteractionEnabled = false
                    }else {
                        cell.img_SameAsShippingAddress.image = UIImage(named: "uncheck_icon_square")
                        cell.view_Address.alpha = 1.0
                        cell.view_Address.isUserInteractionEnabled = true
                    }
                    //Disable/enable billing address based on shipping address
                    if filteredAddresses.count == 0 {
                        cell.view_BillingAddressSame.isUserInteractionEnabled = false
                        cell.view_BillingAddressSame.alpha = 0.3
                    }else {
                        cell.view_BillingAddressSame.isUserInteractionEnabled = true
                        cell.view_BillingAddressSame.alpha = 1.0
                    }
                    superCell = cell
                }else {
                    //Add Billing Address
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddBillingAddressCell", for: indexPath) as! AddBillingAddressCell
                    cell.view_Content.bottomRoundCornners(radius: 6)
                    cell.btn_AddAddress.addTarget(self, action: #selector(self.addBillingAddress(sender:)), for: .touchUpInside)
                    cell.btn_SameAsShippingAddress.addTarget(self, action: #selector(self.addBillingAddressSimilarToShippingAddress(sender:)), for: .touchUpInside)
                    if self.checkoutPreferences!.isBillingAddressSimilarToShippingAddress == true {
                        cell.img_SameAsShippingAddress.image = UIImage(named: "check_icon_square")
                        cell.btn_AddAddress.alpha = 0.3
                        cell.btn_AddAddress.isUserInteractionEnabled = false
                    }else {
                        cell.img_SameAsShippingAddress.image = UIImage(named: "uncheck_icon_square")
                        cell.btn_AddAddress.alpha = 1.0
                        cell.btn_AddAddress.isUserInteractionEnabled = true
                    }
                    //Disable/enable billing address based on shipping address
                    if filteredAddresses.count == 0 {
                        cell.view_BillingAddressSame.isUserInteractionEnabled = false
                        cell.view_BillingAddressSame.alpha = 0.3
                    }else {
                        cell.view_BillingAddressSame.isUserInteractionEnabled = true
                        cell.view_BillingAddressSame.alpha = 1.0
                    }
                    superCell = cell
                }
                
            }
        }else if indexPath.section == CheckoutTableHeader.PaymentOption.rawValue {
            if indexPath.row < self.checkoutService.array_CardDetails.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodCell", for: indexPath) as! PaymentMethodCell
                cell.configureCell(item: self.checkoutService.array_CardDetails[indexPath.row])
                if indexPath.row == 0 {
                    cell.constraint_SeperatorLeading.constant = 0
                    cell.constraint_SeperatorTrailing.constant = 0
                }else {
                    cell.constraint_SeperatorLeading.constant = 12
                    cell.constraint_SeperatorTrailing.constant = 12
                }
                superCell = cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewOptionCell", for: indexPath) as! AddNewOptionCell
                cell.view_Back.bottomRoundCornners(radius: 6)
                cell.btn_AddNewOption.setTitle("ADD NEW CARD", for: .normal)
                cell.btn_AddNewOption.addTarget(self, action: #selector(self.addNewOptionTapped(sender:)), for: .touchUpInside)
                superCell = cell
            }
        }else if indexPath.section == CheckoutTableHeader.OrderSummary.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryCell", for: indexPath) as! OrderSummaryCell
            if indexPath.row == 0 {
                cell.constraint_SeperatorLeading.constant = 0
                cell.constraint_SeperatorTrailing.constant = 0
            }else {
                cell.constraint_SeperatorLeading.constant = 12
                cell.constraint_SeperatorTrailing.constant = 12
            }
            cell.configureCell(item: array_OrderSummary[indexPath.row], indexPath: indexPath, orderSummaryCount: array_OrderSummary.count)
            superCell = cell
        }
        superCell.selectionStyle = .none
        return superCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == CheckoutTableHeader.ItemToBuy.rawValue {
            self.moveToProductDetailVC(product: (self.checkoutPreferences!.array_ItemsToBuy[indexPath.row]?.product)!)
        }else if indexPath.section == CheckoutTableHeader.ShippingAddress.rawValue {
            if indexPath.row < self.checkoutService.array_ShippingAddress.count {
                let filtered = self.checkoutService.array_ShippingAddress.filter({$0.isSelected == true})
                var selectedIndexPath = IndexPath()
                var isPreviouslySelected = Bool()
                if filtered.count > 0 {
                    for index in 0..<self.checkoutService.array_ShippingAddress.count {
                        if self.checkoutService.array_ShippingAddress[index].isSelected == true {
                            self.checkoutService.array_ShippingAddress[index].isSelected = false
                            selectedIndexPath = IndexPath(row: index, section: CheckoutTableHeader.ShippingAddress.rawValue)
                            isPreviouslySelected = true
                            break
                        }
                    }
                }
                self.checkoutService.array_ShippingAddress[indexPath.row].isSelected = true
                self.checkoutPreferences?.shippingAddress = self.checkoutService.array_ShippingAddress[indexPath.row]
                self.checkoutPreferences?.shippingAddressId = self.checkoutService.array_ShippingAddress[indexPath.row].id
                self.array_Sections[CheckoutTableHeader.ShippingAddress.rawValue].description = self.checkoutService.array_ShippingAddress[indexPath.row].address1
                UIView.performWithoutAnimation {
                    tableView.beginUpdates()
                    if isPreviouslySelected == true {
                        tableView.reloadRows(at: [selectedIndexPath, indexPath], with: .none)
                    }else {
                        tableView.reloadRows(at: [indexPath], with: .none)
                    }
                    tableView.reloadSections(IndexSet(arrayLiteral: CheckoutTableHeader.ItemToBuy.rawValue, CheckoutTableHeader.ShippingAddress.rawValue), with: .none)
                    //tableView.reloadSections(IndexSet(integer: CheckoutTableHeader.ShippingAddress.rawValue), with: .none)
                    tableView.endUpdates()
                }
            }
        }else if indexPath.section == CheckoutTableHeader.PaymentOption.rawValue {
            if indexPath.row < self.checkoutService.array_CardDetails.count {
                let filtered = self.checkoutService.array_CardDetails.filter({$0.isSelected == true})
                var selectedIndexPath = IndexPath()
                var isPreviouslySelected = Bool()
                if filtered.count > 0 {
                    for index in 0..<self.checkoutService.array_CardDetails.count {
                        if self.checkoutService.array_CardDetails[index].isSelected == true {
                            self.checkoutService.array_CardDetails[index].isSelected = false
                            selectedIndexPath = IndexPath(row: index, section: CheckoutTableHeader.PaymentOption.rawValue)
                            isPreviouslySelected = true
                            break
                        }
                    }
                }
                
                self.checkoutService.array_CardDetails[indexPath.row].isSelected = true
                self.checkoutPreferences?.paymentDetails = self.checkoutService.array_CardDetails[indexPath.row]
                self.array_Sections[CheckoutTableHeader.PaymentOption.rawValue].description = self.checkoutService.array_CardDetails[indexPath.row].last4digits
                let cardImage = getCardImage(brand: self.checkoutService.array_CardDetails[indexPath.row].brand)
                self.array_Sections[CheckoutTableHeader.PaymentOption.rawValue].image = cardImage
                UIView.performWithoutAnimation {
                    tableView.beginUpdates()
                    if isPreviouslySelected == true {
                        tableView.reloadRows(at: [selectedIndexPath, indexPath], with: .automatic)
                    }else {
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                    tableView.reloadSections(IndexSet(integer: CheckoutTableHeader.PaymentOption.rawValue), with: .none)
                    tableView.endUpdates()
                }
            }
        }
        self.canCheckout()
    }
}
//MARK:- Stripe Payment

extension UIViewController {
    //API to fetch the finger print of card(It is used to check duplicate card)
    //Also check the expiration date of the card
    func processPaymentWithStripeToken(token: STPToken, amountToPay: Int) {
        StripeClient.shared.completeCharge(with: token, amount: amountToPay) { result in
            switch result {
            // 1
            case .success:
                AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "Congrats", message: "Your payment was successful!", btnTitle: "OK", viewController: self, completionHandler: { (success) in
                })
            // 2
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
            }
        }
    }
}

//MARK:-  API CALLS
extension CheckoutVC {
    @objc func callFetchShippingAddress() {
        checkoutService.array_ShippingAddress.removeAll()
        checkoutService.callFetchShippingAddressAPI(showLoader: true, completionBlockSuccess: { (response) -> Void in
            // your successful handle
            print(response)
            self.callFetchUserCardDetails()
        }) { (failure) -> Void in
            self.callFetchUserCardDetails()
            // your failure handle
            //As per Deepak no need to display error message.
            //self.handleAPIError(failure: failure)
        }
    }
    @objc func callFetchUserCardDetails() {
        checkoutService.array_CardDetails.removeAll()
        checkoutService.callfetchUserCardDetailsAPI(context: "PAYMENT", showLoader: true, completionBlockSuccess: { (response) -> Void in
            // your successful handle
            print(response)
            self.setUpData()
        }) { (failure) -> Void in
            self.setUpData()
            // your failure handle
            //As per Deepak no need to display error message.
            //self.handleAPIError(failure: failure)
        }
    }
    func callPlaceOrder(parameters: [String:Any]) {
        checkoutService.callPlaceOrderAPI(parameters: parameters, showLoader: true, completionBlockSuccess: { (response) -> Void in
            // your successful handle
              FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.checkOut, category: FirAnalytics.Category.checkout, label: FirAnalytics.Label.checkout_placeorder, action: FirAnalytics.Actions.placeOrder_Request, value: 1)
            print(response)
            self.dismiss(animated: false) {
                self.checkoutService.removeUserStoredDataFromCheckout()
                self.thankYouScreenDelegate.navigateToThankYouVC()
            }
        }) { (failure) -> Void in
            // your failure handle
             FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.checkOut, category: FirAnalytics.Category.checkout, label: FirAnalytics.Label.checkout_placeorder, action: FirAnalytics.Actions.placeOrder_Request, value: 0)
            self.handleAPIError(failure: failure)
        }
    }
    func callDeleteCard() {
        let params: [String:Any] = ["card_id": ""]
        checkoutService.callDeleteCardAPI(parameters: params, showLoader: true, completionBlockSuccess: { (response) in
            self.dismissController()
        }) { (failure) -> Void in
            // your failure handle
            //self.handleAPIError(failure: failure)
            self.dismissController()
        }
    }
}







