//  Created by Apple on 13/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import Foundation

final class ProductInfoService {
    
    static let sharedInstance = ProductInfoService()
    fileprivate init() {}
    var productDetail: ProductDetail? = nil
    var reviewsList : [HomePost] = []

    func fetchProductInfo(value:String,showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.productInfo.rawValue + "/" + value
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            self.productDetail = nil
            if let value = success["status"] as? Bool {
                print(value )
                if value {
                    if let result = success["response"] as? NSDictionary {
                        let value = ProductDetail(dictionary: result)
                        self.productDetail = value
                    }
                    aBlock (success as AnyObject)
                }else {
                    self.productDetail = nil
                    failBlock(success)
                }
            }else {
                self.productDetail = nil
                failBlock(success)
            }
        }) { (failure) -> Void in
            // your failure handle
            self.productDetail = nil
            failBlock(failBlock as AnyObject)
        }
    }
    
    func callAddProductToWishListAPI (parameters: [String: Any], showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.addProductToWishlist.rawValue
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
    
    func callRemoveProductFromWishListAPI (parameters: [String: Any], showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.removeProductFromWishlist.rawValue
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
    
    //ALL REVIEWS LIST
    func fetchAllReviewsAPI(value:String,showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.productReviews.rawValue + "/" + value
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            self.reviewsList.removeAll()
            if let value = success["status"] as? Bool {
                print(value )
                if value {
                    if let result = success["response"] as? NSDictionary {
                        if let data = result["reviews"] as? [NSDictionary]
                        {
                            self.reviewsList.removeAll()
                            for dict in data {
                                let value = HomePost(dictionary: dict)
                                self.reviewsList.append(value)
                            }
                        }
                    }
                    aBlock (success as AnyObject)
                }else {
                    self.reviewsList.removeAll()
                    failBlock(success)
                }
            }else {
                self.reviewsList.removeAll()
                failBlock(success)
            }
        }) { (failure) -> Void in
            // your failure handle
            self.reviewsList.removeAll()
            failBlock(failBlock as AnyObject)
        }
    }

}
