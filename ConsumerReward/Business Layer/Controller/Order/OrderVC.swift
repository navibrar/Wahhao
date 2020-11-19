//
//  OrderVC.swift
//  ConsumerReward
//
//  Created by apple on 14/12/18.
//  Copyright © 2018 Sanjeev Thapar. All rights reserved.
//

import UIKit

class OrderVC: UIViewController {

    @IBOutlet weak var orderTable : UITableView!
     let cellReuseIdentifier = "OrderCell"
     var array_Orders = [Orders]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initalsetup()
        // Do any additional setup after loading the view.
    }
    
    @objc func initalsetup(){
        self.title = "My Orders".uppercased()
        
        let dict1 : NSDictionary = ["id": "1","image": "followers-1", "Product_Name": "First Product", "Sold_By":"New Company","Status":"Pending","Delivery_Date":"Feb,2 2018"]
        
        let dict2 : NSDictionary = ["id": "2","image": "followers-4", "Product_Name": "Second Product", "Sold_By":"New Company_2","Status":"Delivered","Delivery_Date":"jan,18 2018"]
        
        let dict3 : NSDictionary = ["id": "3","image": "followers-2", "Product_Name": "Third Product", "Sold_By":"New Company_3","Status":"Confirmed","Delivery_Date":"Mar,22 2018"]
        
        let dict4 : NSDictionary = ["id": "4","image": "followers-6", "Product_Name": "Fourth Product", "Sold_By":"New Company_4","Status":"preparing order","Delivery_Date":"Apr,16 2018"]
        
        let dict5 : NSDictionary = ["id": "5","image": "followers-9", "Product_Name": "Fifth Product", "Sold_By":"New Company_5","Status":"Shipped","Delivery_Date":"jun,15 2018"]
        
        array_Orders.append(Orders(dictionary: dict1))
        array_Orders.append(Orders(dictionary: dict2))
        array_Orders.append(Orders(dictionary: dict3))
        array_Orders.append(Orders(dictionary: dict4))
        array_Orders.append(Orders(dictionary: dict5))
        
        
        self.orderTable.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension OrderVC : UITableViewDataSource ,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! OrderCell
//        let itemName = self.namesList[indexPath.row].uppercased()
//        let itemImage = self.imagesList[indexPath.row]
//        cell.setValueForCell(name : itemName ,itemImage:itemImage)
//        cell.notificationIconImageView.isHidden = true
//        if indexPath.row == 0
//        {
//            cell.notificationIconImageView.isHidden = false
//        }
//        cell.accessoryType = .disclosureIndicator
        return cell
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 3
//        {
//            self.moveToShareView()
//        }
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 55
//    }
    
}
