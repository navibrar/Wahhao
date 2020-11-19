//
//  CartViewController.swift
//  Consumer
//
//  Created by apple on 4/23/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
    
    let cellReuseIdentifier = "CartTableViewCell"
    var cartArray : [Cart] = []

    @IBOutlet weak var cart_TableView: UITableView!
    @IBOutlet weak var view_CheckOutBg: UIView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var lbl_SubtotalTitle: UILabel!
    @IBOutlet weak var lbl_Subtotal: UILabel!
    @IBOutlet weak var btn_Checkout: UIButton!
    let refreshControl = UIRefreshControl()
    let store = CartServices.sharedInstance
    var isPresented: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        cart_TableView.tableFooterView = UIView()
        self.view_CheckOutBg.isHidden = true

        let nib = UINib.init(nibName: cellReuseIdentifier, bundle: nil)
        self.cart_TableView.register(nib, forCellReuseIdentifier: cellReuseIdentifier)
        
        if #available(iOS 10, *) {
            cart_TableView.refreshControl = refreshControl
        } else {
            cart_TableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(self.fetchCartList), for: .valueChanged)
        refreshControl.tintColor = UIColor.clear
        //initializeActivityIndicator()
        FirAnalytics.trackPageView(withScreen: FirAnalytics.Screen.cartView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.refreshControl.isRefreshing == true {
            self.refreshControl.endRefreshing()
        }
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.perform(#selector(self.fetchCartList), with: self, afterDelay: 0.3)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let view = cart_TableView
            .allSubViews //get all the subviews
            .filter {String(describing:type(of: $0)) ==  "UISwipeActionPullView"}
        print(view)
        if view.count > 0 {
            view[0].backgroundColor = UIColor.clear
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkoutButtonTapped(_ sender: UIButton) {
        let dict: NSDictionary = ["array_ItemsToBuy": cartArray, "classWhereProductIsAdded": String(describing: CartViewController.self)]
        var preferences = CheckoutProtocolModel(dictionary: dict)
        preferences.isClearCart = true
        self.moveToCheckoutScreen(checkoutPreferences: preferences)
    }
    func visualSetup() {
        if self.cartArray.count > 0 {
            self.noDataView.isHidden = true
            self.view_CheckOutBg.isHidden = false
        }else {
            self.noDataView.isHidden = false
            self.view_CheckOutBg.isHidden = true
        }
        let filtered = self.cartArray.filter({$0.product.qtyCount == 0})
        if filtered.count > 0 {
            self.btn_Checkout.alpha = 0.5
            self.btn_Checkout.isUserInteractionEnabled = false
        }else {
            self.btn_Checkout.alpha = 1
            self.btn_Checkout.isUserInteractionEnabled = true
        }
        self.cart_TableView.reloadData()
        self.calcutateCartItemsTotalPrice()
    }
    func moveToProductDetailsPage(product: Product) {
        let storyboard = UIStoryboard(name: "ProjectStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        vc.product = product
        vc.isShowCartButtons = true
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.refreshCheckOutCallback = { success in
            self.perform(#selector(self.fetchCartList), with: self, afterDelay: 0.3)
//            self.fetchCartList()
        }
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func backTapped(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        if self.isPresented == true {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }else {
           self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func increaseQuantityCount(sender: UIButton){
        let tag = sender.tag
        let indexPath = IndexPath(row:0, section: tag)
        let cell = cart_TableView.cellForRow(at: indexPath) as! CartTableViewCell
        let cartValue = cartArray[indexPath.section]
        if (cartValue.quantityCount < cartValue.product.qtyCount ) {
            cell.contentView.isUserInteractionEnabled = false
            self.updateCartAPI(cart: cartArray[indexPath.section], isQtyIncreased: true, tag: tag)
        }else {
            cell.increaseButton.alpha = 0.45
            self.showAlertWithMessage(title: "", message: "This quantity is not available at the moment")
        }
    }
    
    @objc func decreaseQuantityCount(sender: UIButton){
        let tag = sender.tag
        let indexPath = IndexPath(row:0, section: tag)
        let cell = cart_TableView.cellForRow(at: indexPath) as! CartTableViewCell
        let cartValue = cartArray[indexPath.section]
        if (cartValue.quantityCount > 1 ) {
            cell.contentView.isUserInteractionEnabled = false
            self.updateCartAPI(cart: cartArray[indexPath.section], isQtyIncreased: false, tag: tag)
        }else if cartValue.quantityCount == 1 {
            cell.increaseButton.alpha = 0.45
            AlertController.SHOW_ALERT_CONTROLLER_DOUBLE_BUTTON(alertTitle: "", message: "Item will be removed from the Cart", btnTitle1: "Cancel", btnTitle2: "Ok", viewController: self) { (response) in
                if response.caseInsensitiveCompare("Button2") == .orderedSame {
                    self.deleteItemFromBag(variant_id: cartValue.variant_id)
                }else {
                    cell.increaseButton.alpha = 1.0
                }
            }
        }else {
            cell.decreaseButton.alpha = 0.45
        }
    }
    func increaseQuantity(tag: Int) {
        let indexPath = IndexPath(row:0, section: tag)
        let cell = cart_TableView.cellForRow(at: indexPath) as! CartTableViewCell
        
        let cartValue = cartArray[indexPath.section]
        let quantityCount = cartValue.quantityCount + 1
        let quantity = "\(quantityCount)"
        
        cell.productCountLabel.text = "\(quantity)"
        cartArray[indexPath.section].quantity = quantity
        cartArray[indexPath.section].quantityCount = quantityCount
        cell.decreaseButton.alpha = 1
        if quantityCount == cartValue.product.qtyCount
        {
            cell.increaseButton.alpha = 0.45
        }
        self.calcutateCartItemsTotalPrice()
    }
    func decreaseQuantity(tag: Int) {
        let indexPath = IndexPath(row:0, section: tag)
        let cell = cart_TableView.cellForRow(at: indexPath) as! CartTableViewCell
        
        let cartValue = cartArray[indexPath.section]
        let quantityCount = cartValue.quantityCount - 1
        let quantity = "\(quantityCount)"
        
        cell.productCountLabel.text = "\(quantity)"
        cartArray[indexPath.section].quantity = quantity
        cartArray[indexPath.section].quantityCount = quantityCount
        self.calcutateCartItemsTotalPrice()
        cell.increaseButton.alpha = 1
    }
    
    func calcutateCartItemsTotalPrice() {
        var totalPrice: Float = 0
        var totalQuantity: Int = 0
        for item in cartArray {
            let qtyStr = (item.quantity == "" ? "1" : item.quantity) as NSString
            let quantity: Float = qtyStr.floatValue
            let priceStr = (item.product.final_price == "" ? "1" : item.product.final_price) as NSString
            let price: Float =  priceStr.floatValue
            totalPrice += quantity*price
            totalQuantity += Int(quantity)
        }
        let totalPriceStr = formatPriceToTwoDecimalPlace(amount: totalPrice)
        let totalItems = totalQuantity == 1 ? "(1 Item)" : "(\(totalQuantity) Items)"
        let completeStr = "\(totalPriceStr) \(totalItems)"
        self.navigationItem.title = "CART (\(totalQuantity))"
        if let range = completeStr.range(of: totalItems) {
            let nsRange = NSRange(range, in: completeStr)
            let myMutableString = NSMutableAttributedString(string: completeStr, attributes: [NSAttributedString.Key.font:UIFont(name: Constants.SEMI_BOLD_FONT, size: 20)!])
            myMutableString.addAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), NSAttributedString.Key.font: UIFont(name: Constants.REGULAR_FONT, size: 13)!], range: nsRange)
            lbl_Subtotal.attributedText = myMutableString
        }
    }
    //MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
extension CartViewController : UITableViewDataSource ,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cartArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 16
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 128
       
    }
  
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cart = cartArray[indexPath.section]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CartTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.setValueForCell(cart : cart)
        cell.increaseButton.alpha = 1.0
        cell.decreaseButton.alpha = 1.0
        cell.increaseButton.tag = indexPath.section
        cell.decreaseButton.tag = indexPath.section
        cell.increaseButton.addTarget(self, action: #selector(self.increaseQuantityCount(sender:)), for: .touchUpInside)
        cell.decreaseButton.addTarget(self, action: #selector(self.decreaseQuantityCount(sender:)), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedProduct = self.cartArray[indexPath.section].product
          FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.cartView, category: FirAnalytics.Category.cartView, label: FirAnalytics.Label.cart_load_productDetails, action: FirAnalytics.Actions.show_productdetails, value: 1)
        selectedProduct.variant_id = self.cartArray[indexPath.section].variant_id
        self.moveToProductDetailsPage(product: selectedProduct)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.view.setNeedsLayout()
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let kDeleteActionWidth =  CGFloat(79)
       // let kCellHeight = 112
        let kDeleteActionHeight = CGFloat(128)
        let whitespace = whitespaceString(width: kDeleteActionWidth,height:kDeleteActionHeight)
        let deleteAction = UITableViewRowAction(style: .`default`, title: whitespace) { (action, indexPath) in

                let alert = UIAlertController(title: "REMOVE ITEM?", message: "Are you sure you want to delete this item from your cart?", preferredStyle: UIAlertController.Style.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Remove", style: UIAlertAction.Style.destructive,handler: { action in
//                    self.cartArray.remove(at: indexPath.row)
//                    self.bagTableView.deleteRows(at: [indexPath], with: .automatic)
                    self.deleteItemFromBag(variant_id: self.cartArray[indexPath.section].variant_id)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        
        
        // create a color from patter image and set the color as a background color of action
        let view_Main = UIView(frame: CGRect(x: tableView.frame.size.width-kDeleteActionWidth, y: 0, width: kDeleteActionWidth, height: kDeleteActionHeight))
        view_Main.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.0862745098, blue: 0.1411764706, alpha: 1)
        view_Main.layer.cornerRadius = 0.0
        view_Main.clipsToBounds = true
        
        let view_Delete = UIView(frame: CGRect(x: 6, y: 0, width: kDeleteActionWidth-12, height: kDeleteActionHeight))
        view_Delete.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.137254902, blue: 0.2549019608, alpha: 1) // background color of view
        view_Delete.layer.cornerRadius = 6.0
        view_Delete.clipsToBounds = true
        view_Main.addSubview(view_Delete)
        
       
        let img_View = UIImageView(frame: CGRect(x: ((kDeleteActionWidth/2)-8.5), y: (kDeleteActionHeight/2)-9, width: 17, height: 18))
        img_View.image = UIImage(named: "cross_icon")! // required image
        img_View.contentMode = .center
        view_Main.addSubview(img_View)
        
        let image_Delete = view_Main.image()
        // deleteAction.backgroundColor = UIColor.clear
        deleteAction.backgroundColor = UIColor.init(patternImage: image_Delete)
        return [deleteAction]
    }
    
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


 /*   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let backView = UIView(frame: CGRect(x: 0, y: 8, width: 80, height: 112))
        backView.backgroundColor = #colorLiteral(red: 0, green: 0.6166976094, blue: 1, alpha: 1)
        
        let myImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 112))
        myImage.image = UIImage(named: "cross_icon")
        myImage.center = backView.center
        myImage.contentMode = .center
        backView.addSubview(myImage)
        
        let imgSize: CGSize = tableView.frame.size
        UIGraphicsBeginImageContextWithOptions(imgSize, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        backView.layer.render(in: context!)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let delete = UITableViewRowAction(style: .destructive, title: "           ") { (action, indexPath) in
            let alert = UIAlertController(title: "REMOVE ITEM?", message: "Are you sure you want to delete this item from your cart?", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Remove", style: UIAlertAction.Style.destructive,handler: { action in
                self.cartArray.remove(at: indexPath.row)
                self.bagTableView.deleteRows(at: [indexPath], with: .automatic)
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        
        delete.backgroundColor = UIColor(patternImage: newImage)
        
        return [delete]
        
    }
 */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            // create the alert
            let alert = UIAlertController(title: "REMOVE ITEM?", message: "Are you sure you want to delete this item from your cart?", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Remove", style: UIAlertAction.Style.destructive,handler: { action in
//                self.cartArray.remove(at: indexPath.row)
//                self.bagTableView.deleteRows(at: [indexPath], with: .automatic)
               
                self.deleteItemFromBag(variant_id: self.cartArray[indexPath.section].variant_id)

            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: API CALLS
extension CartViewController {
    @objc func fetchCartList() {
        store.fetchListing(showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            self.cartArray.removeAll()
            if let _ = success as? [String: Any] {
                print(success)
                print("success")
                self.cartArray = self.store.list
                if self.refreshControl.isRefreshing == true {
                    self.refreshControl.endRefreshing()
                }
                self.visualSetup()

                //self.moveToNextView()
            }
        }) { (failure) -> Void in
            self.cartArray.removeAll()
            if self.refreshControl.isRefreshing == true {
                self.refreshControl.endRefreshing()
            }
            self.visualSetup()
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    
    func deleteItemFromBag(variant_id:String) {
        let parameters : [String:Any] = [
            "variant_id": variant_id
        ]

        store.callWebserviceToDeleteItem(parameters : parameters , showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
              FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.cartView, category: FirAnalytics.Category.cartView, label: FirAnalytics.Label.cart_product_deleted, action: FirAnalytics.Actions.product_deleted, value: 1)
            self.cartArray.removeAll()
            self.cartArray = self.store.list
            
            if let result = success as? [String: Any] {
                if let response = result["response"] as? NSDictionary {
                    if let countValue  = response["cart_items_count"]
                    {
                        let count = countValue as! Int
                        Network.currentAccount?.updateTotalItemCount(count : count)
                    }
                }
            }
            self.visualSetup()
        }) { (failure) -> Void in
            // your failure handle
              FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.cartView, category: FirAnalytics.Category.cartView, label: FirAnalytics.Label.cart_product_deleted, action: FirAnalytics.Actions.product_deleted, value: 0)
                self.handleAPIError(failure: failure)
        }
    }
    
    func updateCartAPI(cart:Cart, isQtyIncreased: Bool, tag: Int) {
        let parameters : [String:Any] = [
            "variant_id": cart.product.variant_id,
            "is_qty_increased": isQtyIncreased
            //"quantity": cart.quantityCount
        ]
        let indexPath = IndexPath(row:0, section: tag)
        let cell = cart_TableView.cellForRow(at: indexPath) as! CartTableViewCell
        if isQtyIncreased
        {
            cell.increaseButton.alpha = 0.45
        }
        else
        {
            cell.decreaseButton.alpha = 0.45
        }
        store.callWebserviceAddToCart(parameters : parameters , showLoader: false, outhType: "", completionBlockSuccess: { (success) -> Void in
             FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.cartView, category: FirAnalytics.Category.cartView, label: FirAnalytics.Label.cart_qty_update, action: FirAnalytics.Actions.qty_Uupdate, value: 1)
            cell.increaseButton.alpha = 1.0
            cell.decreaseButton.alpha = 1.0
            cell.contentView.isUserInteractionEnabled = true
            if let result = success as? [String: Any] {
                if let response = result["response"] as? NSDictionary {
                    if let countValue  = response["cart_items_count"]
                    {
                        let count = countValue as! Int
                        _ = Network.currentAccount?.updateTotalItemCount(count : count)
                        NOTIFICATIONCENTER.post(name: Notification.Name("UpdateCartCount"), object: nil)
                    }
                    if isQtyIncreased == true {
                        self.increaseQuantity(tag: tag)
                    }else {
                        self.decreaseQuantity(tag: tag)
                    }
                }
            }
        }) { (failure) -> Void in
            // your failure handle
              FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.cartView, category: FirAnalytics.Category.cartView, label: FirAnalytics.Label.cart_qty_update, action: FirAnalytics.Actions.qty_Uupdate, value: 0)
            cell.increaseButton.alpha = 1.0
            cell.decreaseButton.alpha = 1.0
            cell.contentView.isUserInteractionEnabled = true
            self.handleAPIError(failure: failure)
        }
    }
}
