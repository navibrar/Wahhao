//
//  OrderInfoService.swift
//  ConsumerReward
//
//  Created by apple on 02/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.
//

import Foundation

final class OrderInfoService {
    
    static let sharedInstance = OrderInfoService()
    var orders = [Order]()
    var order_Track = [OrderTrack]()
    var orders_details : OrderDetail? = nil
    var track_order_id = String()
    
    
    func fetchOrderlistInfo(showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.OrderHistory.rawValue
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            self.orders.removeAll()
            if let value = success["status"] as? Bool {
                print(value )
                if value {
                    if let result = success["response"] as? NSDictionary {
                        if let data = result["orders"] as? [NSDictionary]
                        {
                            for dict in data {
                                let value = Order(dictionary: dict)
                                self.orders.append(value)
                            }
                        }
                        else{
                            let value = Order(dictionary: result)
                            self.orders.append(value)
                        }
                    }
                    aBlock (success as AnyObject)
                }else {
                     self.orders.removeAll()
                    failBlock(success)
                }
            }else {
                self.orders.removeAll()
                failBlock(success)
            }
        }) { (failure) -> Void in
            // your failure handle
           self.orders.removeAll()
            failBlock(failBlock as AnyObject)
        }
    }
    
    
    
    func fetchOrderlistlatestInfo(showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.consumerReviewOrder.rawValue
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            self.orders.removeAll()
            if let value = success["status"] as? Bool {
                print(value )
                if value {
                    if let result = success["response"] as? NSDictionary {
                        if let data = result["orders"] as? [NSDictionary]
                        {
                            for dict in data {
                                let value = Order(dictionary: dict)
                                self.orders.append(value)
                            }
                        }
                        else{
                            let value = Order(dictionary: result)
                            self.orders.append(value)
                        }
                    }
                    aBlock (success as AnyObject)
                }else {
                    self.orders.removeAll()
                    failBlock(success)
                }
            }else {
                self.orders.removeAll()
                failBlock(success)
            }
        }) { (failure) -> Void in
            // your failure handle
            self.orders.removeAll()
            failBlock(failBlock as AnyObject)
        }
    }
    
    
    func fetchOrderTrackInfo(orderId : String,ProductId : String,showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.OrderTrack.rawValue + "/" + orderId + "/" + ProductId
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            self.order_Track.removeAll()
            if let value = success["status"] as? Bool {
                print(value )
                if value {
                    if let result = success["response"] as? NSDictionary {
                        if let data = result["tracking_status"] as? [NSDictionary]
                        {
                            for dict in data {
                                let value = OrderTrack(dictionary: dict)
                                self.order_Track.append(value)
                            }
                            if let value1  = result["tracking_id"] {
                            self.track_order_id = "\(String(describing: value1))"
                            }else{
                                self.track_order_id = ""
                            }
                        }
                     }
                    aBlock (success as AnyObject)
                }else {
                    self.order_Track.removeAll()
                    failBlock(success)
                }
            }else {
                self.order_Track.removeAll()
                failBlock(success)
            }
        }) { (failure) -> Void in
            // your failure handle
            self.orders.removeAll()
            failBlock(failBlock as AnyObject)
        }
    }
    
    
    func fetchOrderDetailInfo(orderId : String,variant_id : String,showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.OrderDetail.rawValue + "/" + orderId + "/" + variant_id
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            if let value = success["status"] as? Bool {
                print(value )
                if value {
                    if let result = success["response"] as? NSDictionary {
                        if let data = result["orders"] as? NSDictionary
                        {
                            let value = OrderDetail(dictionary: data)
                            self.orders_details = value
                            print("get response order detail",data)
                        }
                    }
                    aBlock (success as AnyObject)
                }else {
                    failBlock(success)
                }
            }else {
                failBlock(success)
            }
        }) { (failure) -> Void in
            // your failure handle
            failBlock(failBlock as AnyObject)
        }
    }
    
    func callGetReorderItemInventoryStatus(orderId : String, variantId: String, showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.reorder.rawValue + "/" + orderId + "/" + variantId
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            if let value = success["status"] as? Bool {
                print(value )
                if value {
                    aBlock (success as AnyObject)
                }else {
                    failBlock(success)
                }
            }else {
                failBlock(success)
            }
        }) { (failure) -> Void in
            // your failure handle
            failBlock(failBlock as AnyObject)
        }
    }
    
    
    
    func callUploadPostMediaFileToServerAsFileURL(filePath : String,fileName:String, fileType: String, forKey: String, showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let Url = Network.APIEndPoints.addImageReviews.rawValue
        service.callUploadFileToServerAsFileURL(filePath: filePath, fileName: fileName, fileType: fileType, forKey: forKey, apiName: Url, showLoader: loader, onCompletion: { (respone) in
            print(respone!)
            if (respone as! NSDictionary)["status"] as! Bool == true {
                aBlock (respone!)
            }
            else  if (respone as! NSDictionary)["status"] as! Bool == false {
                aBlock (respone!)
            }
        }) { (failure) in
            failBlock(failBlock as AnyObject)
        }
    }
    
    
    func callWebserviceforaddReview(parameters: [String: Any],outhType:String, isShowLoader: Bool, showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        if loader {
            // Show loader
        }
        let service = WebAPIServices()
        let getUrl = Network.APIEndPoints.addReviews.rawValue
        service.postAPIs (urlName: getUrl, andParams: parameters, showLoader: true, outhType: outhType, success: { (success) -> Void in
            if let value = success["status"]{
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool{
                    aBlock (success)
                }else {
                    failBlock(success)
                }
            }else {
                failBlock(success)
            }
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            failBlock(failBlock as AnyObject)
        }
    }
    
    
}
