//
//  CartServices.swift
//  Consumer
//
//  Created by apple on 5/15/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation

final class CartServices {
    
    static let sharedInstance = CartServices()
    fileprivate init() {}
    var list: [Cart] = []

    //FETCH API TO BAG ITEMS
    func fetchListing(showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.cart.rawValue
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            self.list.removeAll()
            if let value = success["status"] as? Bool {
                print(value )
                if value
                {
                    if let result = success["response"] as? NSDictionary
                    {
                        if let data = result["cart"] as? [NSDictionary]
                        {
                            for dict in data {
                                let value = Cart(dictionary: dict)
                                self.list.append(value)
                            }
                        }
                        if let countValue = result["cart_items_count"] as? Int
                        {
                            let count = countValue
                            _ = Network.currentAccount?.updateTotalItemCount(count : count)
                            NOTIFICATIONCENTER.post(name: Notification.Name("UpdateCartCount"), object: nil)
                        }

                    }
                    aBlock (success as AnyObject)
                }
                else {
                    self.list.removeAll()
                    failBlock(success)
                }
            }
            else {
                self.list.removeAll()
                failBlock(success)
            }
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            self.list.removeAll()
            failBlock(failBlock as AnyObject)
        }
    }
    
    //DELETE FROM CART
    func callWebserviceToDeleteItem ( parameters: [String: Any], showLoader loader: Bool, outhType: String,  completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.cartDelete.rawValue
        
        service.deleteAPI (urlName: url, andParams: parameters, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            if let value = success["status"] as? Bool {
                print(value)
                if value {
                    if (value)
                    {
                        if let result = success["response"] as? NSDictionary
                        {
                            self.list.removeAll()
                            if let data = result["cart"] as? [NSDictionary]
                            {
                                for dict in data {
                                    let value = Cart(dictionary: dict)
                                    self.list.append(value)
                                }
                            }
                        }
                        aBlock (success as AnyObject)
                    }
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
    //ADD TO CART
    func callWebserviceAddToCart ( parameters: [String: Any], showLoader loader: Bool, outhType: String,  completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.cartAdded.rawValue
        
        service.postAPIs (urlName: url, andParams: parameters, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            if let value = success["status"] as? Bool {
                print(value)
                if value {
                    if (value) {
                        if let result = success["response"] as? NSDictionary
                        {
                            self.list.removeAll()
                            if let data = result["cart"] as? [NSDictionary]
                            {
                                for dict in data {
                                    let value = Cart(dictionary: dict)
                                    self.list.append(value)
                                }
                            }
                        }
                        aBlock (success as AnyObject)
                    }else {
                      failBlock(success)
                    }
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

