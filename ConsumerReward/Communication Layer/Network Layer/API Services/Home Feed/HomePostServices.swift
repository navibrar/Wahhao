//
//  HomePostServices.swift
//  Consumer
//
//  Created by apple on 5/5/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation
final class HomePostServices {
    
    static let sharedInstance = HomePostServices()
    fileprivate init() {}
    var homePostModelArrays: [HomePost] = []
    var userHomePost: UserHomePost? = nil
    var all_categories_list: [Category] = []
    var total_feeds : Int = 0

    func fetchListing(showLoader loader: Bool,value:String, page: Int,rpp : Int, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.feed.rawValue + "/" + value + "?page=\(page)&rpp=" + "\(rpp)"
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            self.homePostModelArrays.removeAll()
            self.all_categories_list.removeAll()
            self.userHomePost = nil
            if let value = success["status"] as? Bool {
                print(value )
                if value
                {
                    if let result = success["response"] as? NSDictionary
                    {
                        if let data = result["categories"] as? [NSDictionary]
                        {
                            for dict in data {
                                let value = Category(dictionary: dict)
                                self.all_categories_list.append(value)
                            }
                        }
                        if let subcategoriesData = result["subcategories"] as? NSDictionary
                        {
                            if let data = subcategoriesData["feeds"] as? [NSDictionary]
                            {
                                for dict in data {
                                    let value = HomePost(dictionary: dict)
                                    self.homePostModelArrays.append(value)
                                }
                            }
                            if let total_feeds_val = subcategoriesData["total_feeds"]
                            {
                                self.total_feeds = total_feeds_val as? Int ?? 0
                            }
                            else
                            {
                                self.total_feeds = 0
                            }

                        }
                        if let dict = result["user"] as? NSDictionary
                        {
                            let value = UserHomePost(dictionary: dict)
                            self.userHomePost = value
                        }
                    }
                    aBlock (success as AnyObject)
                }
                else {
                    failBlock(success)
                }
            }
            else {
                failBlock(success)
            }
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            self.homePostModelArrays.removeAll()
            self.all_categories_list.removeAll()
            self.userHomePost = nil
            failBlock(failBlock as AnyObject)
        }
    }
    
    //MARK:===========Inventory detail Of Product ==============
    func fetchProductInventoryDetailAPI(showLoader loader: Bool,value:String, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.inventoryDetail.rawValue + "/" + value
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            if let value = success["status"] as? Bool {
                print(value )
                if value
                {
                    aBlock (success as AnyObject)
                }
                else {
                    failBlock(success)
                }
            }
            else {
                failBlock(success)
            }
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            failBlock(failBlock as AnyObject)
        }
    }
    
    //MARK:===========View Count================
    func viewCountService(parameters: [String: Any], showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        if loader {
            // Show loader
        }
        let service = WebAPIServices()
        let url = Network.APIEndPoints.postView.rawValue
        service.postAPIs (urlName: url, andParams: parameters, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            if let value = success["status"] as? Bool {
                print(value)
                if value == true {
                    aBlock (success)
                }else{
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
    
    //MARK:===========LIKE UNLIKE POST================
    func callLikeUnLikePostAPI(parameters: [String: Any], showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        if loader {
            // Show loader
        }
        let service = WebAPIServices()
        let url = Network.APIEndPoints.postLike.rawValue
        service.postAPIs (urlName: url, andParams: parameters, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            if let value = success["status"] as? Bool {
                print(value)
                if value == true {
                    aBlock (success)
                }else{
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
    
    func fetchMenuItemsDetailsAPI(showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.userMenu.rawValue
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
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            failBlock(failBlock as AnyObject)
        }
    }
    //MARK:- Post Detail
    
    func callFetchPostDetailAPI(showLoader loader: Bool,postId:String, isReviewPost: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let isReview = isReviewPost == true ? 1 : 0
        let url = Network.APIEndPoints.postDetail.rawValue + "/" + postId + "/" + "\(isReview)"
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            self.homePostModelArrays.removeAll()
            self.all_categories_list.removeAll()
            self.userHomePost = nil
            if let value = success["status"] as? Bool {
                if value {
                    aBlock (success as AnyObject)
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

