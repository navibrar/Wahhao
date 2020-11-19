//  Created by Navpreet on 14/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import Foundation

final class CheckoutServices {
    static let sharedInstance = CheckoutServices()
    var array_ShippingAddress: [ShippingAddress] = []
    var array_CardDetails: [CardDetail] = []
    var array_States: [States] = []
    var array_Cities: [Cities] = []
    
    func callFetchShippingAddressAPI(showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.fetchShippingAddress.rawValue
        service.getAPIs(urlName: url, showLoader: loader, outhType: "", success: { (success) -> Void in
            if let value = success["status"] {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool {
                    if let result = success["response"] as? NSDictionary {
                        if let addressCount = result["count"] as? Int {
                            if addressCount > 0 {
                                if let data = result["address"] as? [NSDictionary] {
                                    for dict in data {
                                        let value = ShippingAddress(dictionary: dict)
                                        self.array_ShippingAddress.append(value)
                                    }
                                }
                            }
                        }
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
    func callAddEditShippingAddressAPI (isAddAddress: Bool, parameters: [String: Any], showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        var url = ""
        if isAddAddress == true {
            url = Network.APIEndPoints.addShippingAddress.rawValue
        }else {
            url = Network.APIEndPoints.updateShippingAddress.rawValue
        }
        service.postAPIs (urlName: url, andParams: parameters, showLoader: loader, outhType: "", success: { (success) -> Void in
            if let value = success["status"] {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool {
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
    
    func callDeleteShippingAddressAPI (addressId: Int, showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.deleteShippingAddress.rawValue + "\(addressId)"
        service.deleteAPI (urlName: url, andParams: [:], showLoader: loader, outhType: "", success: { (success) -> Void in
            if let value = success["status"] {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool {
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
    func callDeleteCardAPI (parameters: [String:Any], showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.deleteUserCard.rawValue
        service.deleteAPI (urlName: url, andParams: parameters, showLoader: loader, outhType: "", success: { (success) -> Void in
            if let value = success["status"] {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool {
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
    func callFetchStatesAPI(showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.states.rawValue
        service.getAPIs(urlName: url, showLoader: loader, outhType: "", success: { (success) -> Void in
            if let value = success["status"] {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool {
                    if let result = success["response"] as? NSDictionary {
                        if let data = result["states"] as? [NSDictionary] {
                            for dict in data {
                                let value = States(dictionary: dict)
                                self.array_States.append(value)
                            }
                        }
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
    
    func callPlaceOrderAPI (parameters: [String: Any], showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.placeOrder.rawValue
        service.postAPIs (urlName: url, andParams: parameters, showLoader: loader, outhType: "", success: { (success) -> Void in
            if let value = success["status"] {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool {
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
    
    func callSaveUserCardDetailsAPI (parameters: [String: Any], showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.savedUserCardInfo.rawValue
        service.postAPIs (urlName: url, andParams: parameters, showLoader: loader, outhType: "", success: { (success) -> Void in
            if let value = success["status"] {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool {
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
    func callfetchUserCardDetailsAPI(context: String, showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.fetchUserCardsInfo.rawValue + context
        service.getAPIs(urlName: url, showLoader: loader, outhType: "", success: { (success) -> Void in
            if let value = success["status"] {
                if value == nil {
                   failBlock(success)
                    return
                }
                if value as! Bool {
                    if let data = success["response"] as? [NSDictionary] {
                        for dict in data {
                            let value = CardDetail(dictionary: dict)
                            self.array_CardDetails.append(value)
                        }
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
    
    func removeUserStoredDataFromCheckout() {
        self.array_ShippingAddress.removeAll()
        self.array_CardDetails.removeAll()
        self.array_States.removeAll()
    }
}
