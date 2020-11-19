//
//  CartServices.swift
//  Consumer
//
//  Created by apple on 5/15/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation

final class ShopMoreServices {
    
    static let sharedInstance = ShopMoreServices()
    fileprivate init() {}
    var all_categories_list: [Category] = []
    var shopMoreArray = [ShopMore]()
    var subcategoriesPostsArray = [ShopMore]()
    var feeds : [HomePost] = []
    //FETCH API TO BAG ITEMS
    func fetchListing(showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.shop_more_forme.rawValue + "\(Constants.RPP_DEFAULT)"
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            self.all_categories_list.removeAll()
            self.shopMoreArray.removeAll()
            if let value = success["status"] as? Bool {
                print(value )
                if value
                {
                    if let result = success["response"] as? NSDictionary
                    {
                        if let data = result["all_categories"] as? [NSDictionary]
                        {
                            for dict in data {
                                let value = Category(dictionary: dict)
                                self.all_categories_list.append(value)
                            }
                        }
                        if let data = result["subcategories"] as? [NSDictionary]
                        {
                            for dict in data {
                                let value = ShopMore(dictionary: dict)
                                if value.feeds.count > 0
                                {
                                    self.shopMoreArray.append(value)
                                }
                            }
                        }
                    }
                    aBlock (success as AnyObject)
                }
                else {
                    self.all_categories_list.removeAll()
                    self.shopMoreArray.removeAll()
                    failBlock(success)
                }
            }
            else {
                self.all_categories_list.removeAll()
                self.shopMoreArray.removeAll()
                failBlock(success)
            }
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            self.all_categories_list.removeAll()
            self.shopMoreArray.removeAll()
            failBlock(failBlock as AnyObject)
        }
    }
    
    func fetchCategoryListing(value:String,rpp:Int,showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.shop_more_category.rawValue + "/" + value + "?rpp=" + "\(rpp)"
        
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            self.shopMoreArray.removeAll()
            if let value = success["status"] as? Bool {
                print(value )
                if value
                {
                    if let result = success["response"] as? NSDictionary
                    {
                        if let data = result["subcategories"] as? [NSDictionary]
                        {
                            for dict in data {
                                let value = ShopMore(dictionary: dict)
                                self.shopMoreArray.append(value)
                            }
                        }
                    }
                    aBlock (success as AnyObject)
                }
                else {
                    self.shopMoreArray.removeAll()
                    failBlock(success)
                }
            }
            else {
                self.shopMoreArray.removeAll()
                failBlock(success)
            }
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            self.shopMoreArray.removeAll()
            failBlock(failBlock as AnyObject)
        }
    }
    
    func fetchSubcategoryListing(value:String,page :Int,rpp:Int,showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.shop_more_subcategory.rawValue + "/\(value)?page=\(page)&rpp=\(rpp)"
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            self.subcategoriesPostsArray.removeAll()
            if let value = success["status"] as? Bool {
                print(value )
                if value
                {
                    if let result = success["response"] as? NSDictionary
                    {
                        if let data = result["subcategories"] as? [NSDictionary]
                        {
                            for dict in data {
                                let value = ShopMore(dictionary: dict)
                                self.subcategoriesPostsArray.append(value)
                            }
                        }
                        else{
                            let value = ShopMore(dictionary: result)
                            self.subcategoriesPostsArray.append(value)
                        }
                    }
                    aBlock (success as AnyObject)
                }
                else {
                    self.subcategoriesPostsArray.removeAll()
                    failBlock(success)
                }
            }
            else {
                self.subcategoriesPostsArray.removeAll()
                failBlock(success)
            }
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            self.subcategoriesPostsArray.removeAll()
            failBlock(failBlock as AnyObject)
        }
    }
    
    func fetchSubcategoryForYouTab(value:String,page :Int,rpp:Int,showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        var url = String()
        
        if value.caseInsensitiveCompare("Following") == .orderedSame {
            url = Network.APIEndPoints.shop_more_follow.rawValue + "?page=\(page)&rpp=" + "\(rpp)"
        } else if(value.caseInsensitiveCompare("on Sale") == .orderedSame){
            url = Network.APIEndPoints.shop_more_sale.rawValue + "?page=\(page)&rpp=" + "\(rpp)"
        } else if(value.caseInsensitiveCompare("$10 & Below") == .orderedSame){
            url = Network.APIEndPoints.shop_more_underTen.rawValue + "?page=\(page)&rpp=" + "\(rpp)"
        } else if(value.caseInsensitiveCompare("Video Reviews") == .orderedSame){
            url = Network.APIEndPoints.shop_more_reviews.rawValue + "?page=\(page)&rpp=" + "\(rpp)"
        }
        
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            self.subcategoriesPostsArray.removeAll()
            
            if let result = success["response"] as? NSDictionary
            {
                let value = ShopMore(dictionary: result)
                self.subcategoriesPostsArray.append(value)
            }
             aBlock (success as AnyObject)
            
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            self.subcategoriesPostsArray.removeAll()
            failBlock(failBlock as AnyObject)
        }
    }
}

