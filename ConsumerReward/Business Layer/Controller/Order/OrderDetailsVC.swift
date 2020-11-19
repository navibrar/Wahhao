//  Created by apple on 14/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import UIKit

class OrderDetailsVC: UIViewController {
    @IBOutlet weak var order_Details_Table : UITableView!
    let store = OrderInfoService.sharedInstance
    var orders_details : OrderDetail? = nil
    var orders_info : Order? = nil   // for get order info from list
    var iSCommingFromNotification = Bool()
    var order_id = ""
    var variant_id = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ORDER DETAILS".uppercased()
        order_Details_Table.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        FirAnalytics.trackPageView(withScreen: FirAnalytics.Screen.orderdetails)
    }
    override func viewWillAppear(_ animated: Bool) {
        if !self.iSCommingFromNotification {
            order_id = orders_info?.order_id ?? ""
            variant_id = orders_info?.variant_id ?? ""
        }
        self.fetchOrderDetail()
    }
    @objc func visualSetup() {
        self.order_Details_Table.reloadData()
    }
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
       self.navigationController?.popViewController(animated: true)
    }
    @IBAction func track_Button_Tapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "OrderTrackVC", sender: self)
    }
    @IBAction func video_review_Button_Tapped(_ sender: UIButton) {
        FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.orderdetails, category: FirAnalytics.Category.addvideoreview, label: FirAnalytics.Label.orederdetails_addvideoreview_tapped, action: FirAnalytics.Actions.addvideoreview_tapped, value: 1)
        let storyboard = UIStoryboard(name: "Reviews", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddVideoReviewVC") as! AddVideoReviewVC
        vc.orders_details  = orders_details
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "OrderTrackVC") {
            if let destinationVC = segue.destination as? OrderTrackVC {
                destinationVC.orders_info = orders_info
            }
        }
    }

   @IBAction func moveToChat(_ sender: UIButton) {
    let storyboard = UIStoryboard(name: "ProjectStoryboard", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
    self.present(vc, animated: true, completion: nil)
    }
    
   @IBAction func reOrder_Action(_ sender: UIButton) {
    self.callFetchreorderItemDetail(orderId: orders_details?.order_id ?? "", variantId: orders_details?.purchase_details.variant_id ?? "")
    }
    //Done by: Sanjeev Thapar
    func reorderSelectedItem(inventoryDetails: NSDictionary) {
        var availableQty: Int = 0
        var orderedQty: Int = 0
        var productStatus: Int = 0
        //Initialization
        //1
        if  let value = inventoryDetails["available_qty"] as? Int {
            availableQty = value
        }else {
            availableQty = Int(inventoryDetails["available_qty"] as! String == "" ? "0" : inventoryDetails["available_qty"] as! String)!
        }
        //2
        if  let value = inventoryDetails["ordered_qty"] as? Int {
            orderedQty = value
        }else {
            orderedQty = Int(inventoryDetails["ordered_qty"] as! String == "" ? "0" : inventoryDetails["ordered_qty"] as! String)!
        }
        //3
        if  let value = inventoryDetails["status"] as? Int {
            productStatus = value
        }else {
            productStatus = Int(inventoryDetails["status"] as! String == "" ? "0" : inventoryDetails["status"] as! String)!
        }
        //Validations
        //1
        if productStatus != 2 {
           self.showToastMessage(message: "Product is not available")
            return
        }
        //2
        if availableQty <= 0 {
            self.showToastMessage(message: "Product is out of stock")
            return
        }else if orderedQty > availableQty {
           orderedQty = availableQty
        }
        var itemsToBuy: [Cart?] = []
        var cartProduct: Cart? = Cart(dictionary: ["id":0])

        //let itemDetails: NSDictionary = ["product_id":inventoryDetails["product_id"] ?? "0", "variant_id":inventoryDetails["variant_id"] ?? "0", "qtyCount": availableQty, "qty": orderedQty, "name": orders_details?.purchase_details.product_name ?? "", "price": orders_details?.purchase_details.final_price ?? "", "final_price": orders_details?.purchase_details.final_price ?? "", "productImage": orders_details?.purchase_details.image.Thumbnail ?? "", "status": productStatus, "sellerName": orders_details?.purchase_details.seller_name ?? ""]
        let itemDetails: NSDictionary = ["name": orders_details?.purchase_details.product_name ?? "", "product_id":inventoryDetails["product_id"] ?? "0", "variant_id":inventoryDetails["variant_id"] ?? "0", "status": productStatus, "qtyCount": availableQty, "qty": "\(orderedQty)"]
        var product = Product(dictionary: itemDetails)
        product.qty = "\(availableQty)"
        product.qtyCount = availableQty
        product.sellerName = orders_details?.purchase_details.seller_name ?? ""
        product.price = inventoryDetails["price"] as? String ?? "0"
        product.final_price = inventoryDetails["customer_final_price"] as? String ?? "0"
        product.productImage = orders_details?.purchase_details.image.Thumbnail ?? ""
        
        cartProduct?.product = product
        cartProduct?.quantity = "\(orderedQty)"
        cartProduct?.quantityCount = orderedQty
        itemsToBuy.append(cartProduct)
        
        let dict: NSDictionary = ["array_ItemsToBuy": itemsToBuy, "classWhereProductIsAdded": String(describing: OrderDetailsVC.self)]
        var preferences = CheckoutProtocolModel(dictionary: dict)
        preferences.isClearCart = false
        preferences.review_id = ""
        self.moveToCheckoutScreen(checkoutPreferences: preferences)
    }
}

extension OrderDetailsVC : UITableViewDataSource ,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if orders_details != nil{
            return 7
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = Int()
        rowCount = 0

        if section == 0 {
            if orders_details != nil{
                rowCount = 1
            }
        }
        else if section == 1 {
            if orders_details != nil{
                if orders_details?.purchase_details != nil{
                    rowCount = 1
                }
            }
        }
        else  if section == 2 {
            if orders_details != nil{
                if orders_details?.rating_info != nil{
                    rowCount = 1
                }
            }
        }
        else  if section == 3 {
            if orders_details != nil{
                rowCount = (orders_details?.other_items.count)!
            }
        }
        else  if section == 4 {
            if orders_details != nil{
                if orders_details?.payment_info != nil{
                    rowCount = 1
                }
            }
        }
        else  if section == 5 {
            if orders_details != nil{
                rowCount = 1
            }
        }
        else  if section == 6 {
            rowCount = 1
        }
    return rowCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var superCell = UITableViewCell()
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailInfo") as! OrderDetailInfo
            cell.configureCell(item: orders_details!)
            cell.selectionStyle = .none
            superCell = cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPurchaseItemsCell") as! OrderPurchaseItemsCell
            cell.configureCell(item: (orders_details?.purchase_details)!)
            cell.selectionStyle = .none
            cell.track_Btn.addTarget(self, action: #selector(self.track_Button_Tapped(_:)), for: .touchUpInside)
            superCell = cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderRatingCell") as! OrderRatingCell
            cell.configureCell(item: (orders_details?.purchase_details.rating)!)
            if (orders_details?.purchase_details.rating) != "0.0000" && self.orders_details?.is_video_review == true {
                cell.starViewConstraint.constant = cell.frame.size.width/2 - 90

            }
            
            
           
//            let tap = UITapGestureRecognizer(target: self, action: #selector(self.uploadFinalReview))
//            tap.delegate = (self as! UIGestureRecognizerDelegate)
//            cell.star_View.addGestureRecognizer(tap)
            if self.orders_details?.is_video_review == true {
                cell.Video_Review_Btn.isHidden = true
                cell.cashback_lbl.isHidden = true
                cell.video_Review_lbl.isHidden = true
            } else {
                cell.Video_Review_Btn.isHidden = false
                cell.cashback_lbl.isHidden = false
                cell.video_Review_lbl.isHidden = false
            }
            
            if Int((orders_info?.order_Status_id)!)! <= 4 {
                cell.Video_Review_Btn.isHidden = true
            }
            cell.selectionStyle = .none
            superCell = cell
        }
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderRelatedItemCell") as! OrderRelatedItemCell
            cell.configureCell(item: (orders_details?.other_items[indexPath.row])!)
            cell.selectionStyle = .none
            print((orders_details?.other_items.count)! - 1)
            print(indexPath.row)
            if orders_details?.other_items.count == 1 {
                   cell.backView.roundCorners([.topLeft, .topRight, .bottomLeft , .bottomRight], radius: 6.0)
                
            }
            else if (orders_details?.other_items.count)! > 1 {
                if  indexPath .row == 0 {
                     cell.backView.topRoundCornners(radius: 6.0)
                }
                   
                else if indexPath.row == ((orders_details?.other_items.count)! - 1)   {
                    cell.backView.bottomRoundCornners(radius: 6.0)
                }
                
                
            }
        
         
            superCell = cell
        }
        else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentInfoCell") as! PaymentInfoCell
            cell.configureCell(item: (orders_details?.payment_info)!)
            cell.selectionStyle = .none
            superCell = cell
        }
        else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryTotalCell") as! OrderSummaryTotalCell
            cell.configureCell(item: orders_details!)
            cell.selectionStyle = .none
            superCell = cell
        }
        else if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderActionCell") as! OrderActionCell
            cell.selectionStyle = .none
            cell.btn_Reorder.addTarget(self, action: #selector(reOrder_Action), for: .touchUpInside)
            
            if Int((orders_info?.order_Status_id)!)! >= 5{
                cell.btn_Return.isHidden = false
                cell.btn_Return_height_constraint.constant = 50
                 cell.btn_Return.addTarget(self, action: #selector(moveToChat), for: .touchUpInside)
                cell.btn_Return.isUserInteractionEnabled = false
            } else {
                cell.btn_Return.isHidden = true
                cell.btn_Return_height_constraint.constant = 0
            }
            superCell = cell
        }
        return superCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        if indexPath.section == 0 {
           height = 87
            
        } else if indexPath.section == 1 {
            height =  155
        } else if indexPath.section == 2 {
            if Int((orders_info?.order_Status_id)!)! <= 4 {
                 height =  0
            } else {
            height =  53
            }
            
        } else if indexPath.section == 3 {
            if (orders_details?.other_items.count)! > 0
            {
                height =  130
            }
            else{
                 height = 0
            }
        } else if indexPath.section == 4 {
            height =  176
        }  else if indexPath.section == 5 {
            height =  158
        }  else if indexPath.section == 6 {
              if Int((orders_info?.order_Status_id)!)! >= 5{
                height =  130
            }
            else{
                height =  75
            }
        }
        return height
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var superHeader = UIView()
        if section == 1 {

            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))

            let label = UILabel()
            label.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: 50)
            label.text = "purchase details".uppercased()
            label.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: 13)! // my custom font
            label.textColor = UIColor.white // my custom colour
            label.textAlignment = .center
            headerView.addSubview(label)
            superHeader = headerView
        } else if section == 3 {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            let label = UILabel()
            label.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: 50)
            if (orders_details?.other_items.count)! > 0
            {
                label.text = "Other Items In this order".uppercased()
            }
            else{
                label.text = ""
            }
            label.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: 13)! // my custom font
            label.textColor = UIColor.white // my custom colour
            label.textAlignment = .center
            headerView.addSubview(label)
            superHeader = headerView
        } else if section == 4 {
            
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            
            let label = UILabel()
            label.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: 50)
            label.text = "payment information".uppercased()
            label.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: 13)! // my custom font
            label.textColor = UIColor.white // my custom colour
            label.textAlignment = .center
            headerView.addSubview(label)
            superHeader = headerView
        }  else if section == 5 {
            
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            
            let label = UILabel()
            label.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: 50)
            label.text = "Order Summary".uppercased()
            label.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: 13)! // my custom font
            label.textColor = UIColor.white // my custom colour
            label.textAlignment = .center
            headerView.addSubview(label)
            superHeader = headerView
        }
        return superHeader
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var headerHeight = CGFloat()
        if section == 1 {
            headerHeight = 50
        }
        else if section == 2 {
            headerHeight = 0
        }
        else if section == 3 {
            if (orders_details?.other_items.count)! > 0 {
                headerHeight = 50 }
            else{
                headerHeight = 0
            }
        } else if section == 4 {
            headerHeight = 50
        } else if section == 5 {
            headerHeight = 50
        }
        else if section == 6 {
            headerHeight = 10
        }
        return headerHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3
        {
            let selectedProduct = self.orders_details?.other_items[indexPath.row]
            variant_id = selectedProduct?.variant_id ?? ""
//            order_id = selectedProduct?.order_id ?? ""
            self.fetchOrderDetail()
        }
    }
}
extension OrderDetailsVC {
    @objc func fetchOrderDetail() {
                store.fetchOrderDetailInfo(orderId: order_id, variant_id: variant_id,showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
         //   self.Orders_Info.removeAll()
            if let _ = success as? [String: Any] {
                print(success)
                print("success")
                self.orders_details = self.store.orders_details
                self.visualSetup()
            }
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    
    @objc func uploadFinalReview() {
        let indexPath = IndexPath(row: 2, section: 0)
        var getrating = Double()
        if let cell = order_Details_Table.cellForRow(at: indexPath) as? OrderRatingCell
        {
            getrating = cell.star_View.rating
        }
        // let indexPathItem = order_Details_Table.ce
        var get_product_id = String()
        get_product_id = (self.orders_details?.purchase_details.product_id)!
        let parameters:  [String: Any] = [
            "resource_id": "",
            "product_id": get_product_id,
            "review": "Good Product",
            "rating": getrating,
            ]
        print("parm get.......",parameters)

        store.callWebserviceforaddReview(parameters: parameters, outhType: "", isShowLoader: true,showLoader: true, completionBlockSuccess: { (success) -> Void in
            print("Success")
            if let value = success["message"] {
                AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: ((value as? String)!), btnTitle: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelOk"), viewController: self) { (success)
                    in
                    self.fetchOrderDetail()
                }
            }
        }) { (failure) -> Void in
            self.handleAPIError(failure: failure)
        }
    }
    @objc func callFetchreorderItemDetail(orderId:String, variantId: String) {
        store.callGetReorderItemInventoryStatus(orderId: orderId, variantId: variant_id, showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
             FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.orderdetails, category: FirAnalytics.Category.orderdetails, label: FirAnalytics.Label.orederdetails_reorder_tapped, action: FirAnalytics.Actions.reorder_tapped, value: 1)
            if let _ = success as? [String: Any] {
                if let result = success as? [String: Any] {
                    if let response = result["response"] as? [String: Any] {
                        if let orderStatus = response["order_status"] as? NSDictionary {
                            self.reorderSelectedItem(inventoryDetails: orderStatus)
                        }
                    }
                }
            }
        }) { (failure) -> Void in
            // your failure handle
             FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.orderdetails, category: FirAnalytics.Category.orderdetails, label: FirAnalytics.Label.orederdetails_reorder_tapped, action: FirAnalytics.Actions.reorder_tapped, value: 0)
            self.handleAPIError(failure: failure)
        }
    }
}
