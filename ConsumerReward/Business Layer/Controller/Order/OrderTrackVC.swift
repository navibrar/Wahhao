//
//  OrderTrackVC.swift
//  ConsumerReward
//
//  Created by apple on 15/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import UIKit
import StepIndicator

class OrderTrackVC: UIViewController ,UIScrollViewDelegate {
     let store = OrderInfoService.sharedInstance
    var Orders_Track_Info = [OrderTrack]()
    var orders_info : Order? = nil
    @IBOutlet weak var back_button: UIBarButtonItem!
    @IBOutlet weak var main_Scroll_View: UIScrollView!
    @IBOutlet weak var customView :  UIView!
    @IBOutlet weak var constraint_customViewHeight: NSLayoutConstraint!
    var InnerView =  UIView()
    var order_status_lbl = UILabel()
    var order_date_lbl = UILabel()
    var order_pack_lbl = UILabel()
    var order_track_lbl = UILabel()
    var get_Y = Int()
    let stepIndicatorView = StepIndicatorView()
    var get_index = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TRACK SHIPMENT".uppercased()
        self.fetchTrackingDetail()
        // Do any additional setup after loading the view.
    }
    @objc func makeview() {
        self.main_Scroll_View.isHidden = false
        self.customView.isHidden = false
        constraint_customViewHeight.constant = 100
        main_Scroll_View.delegate = self
        customView.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.137254902, blue: 0.2549019608, alpha: 1)
        customView.layer.cornerRadius = 10
        customView.layer.masksToBounds = true
        
        main_Scroll_View.layer.cornerRadius = 10
        main_Scroll_View.layer.masksToBounds = true
        
        get_Y = 10
        for index in 0..<Orders_Track_Info.count {
            InnerView = UIView(frame: CGRect(x: 0, y: get_Y, width: Int(customView.frame.size.width), height: 130))
            InnerView.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.137254902, blue: 0.2549019608, alpha: 1)
            let getindex = Orders_Track_Info[index]
            print("get index",getindex)
            var getheight = CGFloat()
            DispatchQueue.main.async {
            getheight = self.heightForLabel(text: getindex.Status, font: UIFont(name: Constants.MEDIUM_FONT, size: 14)!, width: CGFloat(Int(self.InnerView.frame.size.width)-20))
            }
//            print("get Height",getheight)
//            order_track_lbl = UILabel(frame: CGRect(x: 16, y: 12.5, width: 12, height: 12))
//            order_track_lbl.backgroundColor = #colorLiteral(red: 0, green: 0.6166976094, blue: 1, alpha: 1)
//            order_track_lbl.layer.cornerRadius = order_track_lbl.frame.width/2
//            order_track_lbl.layer.masksToBounds = true
//            InnerView.addSubview(order_track_lbl)
            
            order_status_lbl = UILabel(frame: CGRect(x: 50, y: 10, width: Int(InnerView.frame.size.width)-20, height: Int(getheight)))
            order_status_lbl.numberOfLines = 0
            order_status_lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
            order_status_lbl.font = UIFont(name: Constants.MEDIUM_FONT, size: 14)!
            order_status_lbl.text = getindex.Status.uppercased()
            order_status_lbl.sizeToFit()
            order_status_lbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            InnerView.addSubview(order_status_lbl)
            
            var getheight_date = CGFloat()
            DispatchQueue.main.async {
            getheight_date = self.heightForLabel(text: getindex.Last_updated_date_time, font: UIFont(name: Constants.REGULAR_FONT, size: 11)!, width: CGFloat(Int(self.InnerView.frame.size.width)-20))
            }
            order_date_lbl = UILabel(frame: CGRect(x: 50, y: Int(order_status_lbl.frame.origin.y + order_status_lbl.frame.size.height + 3), width: Int(InnerView.frame.size.width)-20, height: Int(getheight_date)))
            order_date_lbl.numberOfLines = 0
            order_date_lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
            order_date_lbl.font = UIFont(name: Constants.REGULAR_FONT, size: 11)!
            order_date_lbl.text = self.makedataformat(text: getindex.Last_updated_date_time)
            order_date_lbl.sizeToFit()
            order_date_lbl.textColor = #colorLiteral(red: 0.7176470588, green: 0.7764705882, blue: 0.8784313725, alpha: 1)
            InnerView.addSubview(order_date_lbl)
            
            
            var getheight_pack = CGFloat()
            DispatchQueue.main.async {
            getheight_pack = self.heightForLabel(text: getindex.Last_updated_date_time, font: UIFont(name: Constants.LIGHT_FONT, size: 11)!, width: CGFloat(Int(self.InnerView.frame.size.width)-20))
            }
            
            order_pack_lbl = UILabel(frame: CGRect(x: 50, y: Int(order_date_lbl.frame.origin.y + order_status_lbl.frame.size.height + 3), width: Int(InnerView.frame.size.width)-30, height: Int(getheight_pack)))
            order_pack_lbl.numberOfLines = 0
            order_pack_lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
            order_pack_lbl.font = UIFont(name: Constants.LIGHT_FONT, size: 11)!
            order_pack_lbl.text = getindex.Comment.uppercased()
            order_pack_lbl.sizeToFit()
            order_pack_lbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            InnerView.addSubview(order_pack_lbl)
            var heightforlabel = Int()
            if index == Orders_Track_Info.count - 1 {
                heightforlabel = Int(order_pack_lbl.frame.origin.y + order_pack_lbl.frame.size.height + 8)
            } else {
            heightforlabel = Int(order_pack_lbl.frame.origin.y + order_pack_lbl.frame.size.height + 30)
            }
            get_Y = get_Y + heightforlabel
            customView.addSubview(InnerView)
            
        }
        
        constraint_customViewHeight.constant = CGFloat(get_Y + 15)
        self.make_view(getheight: get_Y)
         Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(self.changeVlaue), userInfo: nil, repeats: true)
      
        // Do any additional setup after loading the view.
    }
    func make_view(getheight:Int) {
        //  stepIndicatorView
        
        self.stepIndicatorView.frame = CGRect(x: 10, y: 24, width: 25, height: getheight-70)
        self.stepIndicatorView.numberOfSteps = Orders_Track_Info.count
        self.stepIndicatorView.currentStep = 0
        self.stepIndicatorView.displayNumbers = false
        //   self.stepIndicatorView.circleColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1)
        self.stepIndicatorView.circleColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 0)
        self.stepIndicatorView.circleTintColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1)
        self.stepIndicatorView.circleRadius = 6.5
        self.stepIndicatorView.circleStrokeWidth = 13
        self.stepIndicatorView.lineColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 0)
        self.stepIndicatorView.lineTintColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1)
        self.stepIndicatorView.lineMargin = 0
        self.stepIndicatorView.lineStrokeWidth = 1.5
        self.stepIndicatorView.direction = .topToBottom
        self.customView.addSubview(self.stepIndicatorView)
    }
    @objc func changeVlaue() {
        stepIndicatorView.currentStep = get_index
        get_index = get_index + 1
        // self.stepIndicatorView.circleColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1)
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    func makedataformat(text:String) -> String {
    let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let showDate = inputFormatter.date(from: text)
    inputFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
    let resultString = inputFormatter.string(from: showDate!)
    return resultString
}
    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
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
extension OrderTrackVC {
    @objc func fetchTrackingDetail() {
        let variant_id = (orders_info?.variant_id)!
        let order_id = (orders_info?.order_id)!
        
//        let order_id  = "1029"
//        let variant_id = "1036"

        
            store.fetchOrderTrackInfo(orderId: order_id, ProductId: variant_id,showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
                // your successful handle
                self.Orders_Track_Info.removeAll()
                if let _ = success as? [String: Any] {
                    print(success)
                    print("success")
                    self.Orders_Track_Info = self.store.order_Track
                    print("get track info",self.Orders_Track_Info)
                    if self.Orders_Track_Info.count > 0 {
                    self.makeview()
                    } else {
                        self.main_Scroll_View.isHidden = true
                        self.customView.isHidden = true
                    }
                }
            }) { (failure) -> Void in
                self.Orders_Track_Info.removeAll()
                self.main_Scroll_View.isHidden = true
                self.customView.isHidden = true
                // your failure handle
                self.handleAPIError(failure: failure)
            }
        }
       // fetchOrderId
}
