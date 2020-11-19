//
//  OrderVC.swift
//  ConsumerReward
//
//  Created by apple on 14/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import UIKit

class OrderVC: UIViewController {

    @IBOutlet weak var orderTable : UITableView!
     let cellReuseIdentifier = "OrderCell"
     var array_Orders = [Order]()
    var Orders_Info = [Order]()
    let store = OrderInfoService.sharedInstance
    var getindex = Int()
    var isPresented: Bool = false
    
    @IBOutlet weak var no_order : UILabel!
     let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initalsetup()
        // Do any additional setup after loading the view.
        FirAnalytics.trackPageView(withScreen: FirAnalytics.Screen.orderhistory)
    }
    
    @objc func initalsetup(){
        self.title = "My Orders".uppercased()
        no_order.text = "No Order available".uppercased()
        self.no_order.isHidden = true
        self.fetchOrderList()
        
        if #available(iOS 10, *) {
            orderTable.refreshControl = refreshControl
        } else {
            orderTable.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(self.fetchOrderList), for: .valueChanged)
        refreshControl.tintColor = UIColor.clear
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if self.refreshControl.isRefreshing == true {
            self.refreshControl.endRefreshing()
        }
        self.view.endEditing(true)
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        if self.isPresented == true {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "OrderDetailsVC") {
                if let destinationVC = segue.destination as? OrderDetailsVC {
                     FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.orderhistory, category: FirAnalytics.Category.orderhistory, label: FirAnalytics.Label.order_history_product_tapped, action: FirAnalytics.Actions.order_history_page, value: 1)
                    let order_record = self.Orders_Info[getindex]
                    destinationVC.orders_info = order_record
            }
        }
    }
}

extension OrderVC : UITableViewDataSource ,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Orders_Info.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! OrderCell
       cell.configureCell(item: Orders_Info[indexPath.row])
     cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getindex = indexPath.row
        self.performSegue(withIdentifier: "OrderDetailsVC", sender: self)
    }
}
extension OrderVC {
    @objc func fetchOrderList() {
        store.fetchOrderlistInfo(showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
              FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.orderhistory, category: FirAnalytics.Category.orderhistory, label: FirAnalytics.Label.order_history_page_load, action: FirAnalytics.Actions.order_history_page, value: 1)
            self.Orders_Info.removeAll()
            if let _ = success as? [String: Any] {
                if self.refreshControl.isRefreshing == true {
                    self.refreshControl.endRefreshing()
                }
                print(success)
                print("success")
                self.Orders_Info = self.store.orders
                if self.Orders_Info.count > 0 {
                self.no_order.isHidden = true
                self.orderTable.reloadData()
                } else {
                    self.no_order.isHidden = false
                    self.orderTable.isHidden = true
                }
            }
        }) { (failure) -> Void in
            
        FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.orderhistory, category: FirAnalytics.Category.orderhistory, label: FirAnalytics.Label.order_history_page_load, action: FirAnalytics.Actions.order_history_page, value: 0)
            
            if self.refreshControl.isRefreshing == true {
                self.refreshControl.endRefreshing()
            }
            self.Orders_Info.removeAll()
            self.orderTable.reloadData()
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
}
