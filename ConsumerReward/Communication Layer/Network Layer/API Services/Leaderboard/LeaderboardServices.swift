//  Created by Navpreet on 22/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import Foundation

final class LeaderboardServices {
    static let sharedInstance = LeaderboardServices()
    var array_TopDailyFans: [Leaderboard] = []
    var array_TopWeeklyFans: [Leaderboard] = []
    var array_TopMonthlyFans: [Leaderboard] = []
    var array_TopAllTimeFans: [Leaderboard] = []
    var array_TopCashbackPost: [HomePost] = []
    var array_MostLikedPost: [HomePost] = []
    var array_MostSoldProducts: [UnitsSold] = []
    
    func callGetLeaderboardFansAPI(type: String, count:Int = 0, showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        var url = ""
        if type.caseInsensitiveCompare(ReferralLeaderboardSegmentValues.daily) == .orderedSame {
            self.array_TopDailyFans.removeAll()
            url = Network.APIEndPoints.topDailyFans.rawValue
        }else if type.caseInsensitiveCompare(ReferralLeaderboardSegmentValues.weekly) == .orderedSame {
            self.array_TopWeeklyFans.removeAll()
            url = Network.APIEndPoints.topWeeklyFans.rawValue
        }else if type.caseInsensitiveCompare(ReferralLeaderboardSegmentValues.monthly) == .orderedSame {
            self.array_TopMonthlyFans.removeAll()
            url = Network.APIEndPoints.topMonthlyFans.rawValue
        }else if type.caseInsensitiveCompare(ReferralLeaderboardSegmentValues.allTime) == .orderedSame {
            self.array_TopAllTimeFans.removeAll()
            url = Network.APIEndPoints.topAllTimeFans.rawValue
        }
        if count > 0 {
            url = "\(url)/\(count)"//To get top n number of fans
        }
        service.getAPIs(urlName: url, showLoader: loader, outhType: "", success: { (success) -> Void in
            if let value = success["status"] {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool {
                    if let result = success["response"] as? NSDictionary {
                        if let data = result["referrals"] as? [NSDictionary] {
                            for dict in data {
                                let value = Leaderboard(dictionary: dict)
                                if type.caseInsensitiveCompare(ReferralLeaderboardSegmentValues.daily) == .orderedSame {
                                    self.array_TopDailyFans.append(value)
                                }else if type.caseInsensitiveCompare(ReferralLeaderboardSegmentValues.weekly) == .orderedSame {
                                    self.array_TopWeeklyFans.append(value)
                                }else if type.caseInsensitiveCompare(ReferralLeaderboardSegmentValues.monthly) == .orderedSame {
                                    self.array_TopMonthlyFans.append(value)
                                }else if type.caseInsensitiveCompare(ReferralLeaderboardSegmentValues.allTime) == .orderedSame {
                                    self.array_TopAllTimeFans.append(value)
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
    
    func callGetLeaderboardTopCashbackVideosAPI(showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        self.array_TopCashbackPost.removeAll()
        let url = Network.APIEndPoints.topVideos.rawValue
        service.getAPIs(urlName: url, showLoader: loader, outhType: "", success: { (success) -> Void in
            if let value = success["status"] {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool {
                    if let result = success["response"] as? NSDictionary {
                        if let data = result["top_videos"] as? [NSDictionary] {
                            for dict in data {
                                let value = HomePost(dictionary: dict)
                                self.array_TopCashbackPost.append(value)
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
    
    func callGetLeaderboardMostSoldProductAPI(showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        self.array_MostSoldProducts.removeAll()
        let url = Network.APIEndPoints.unitsSold.rawValue
        service.getAPIs(urlName: url, showLoader: loader, outhType: "", success: { (success) -> Void in
            if let value = success["status"] {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool {
                    if let result = success["response"] as? NSDictionary {
                        if let data = result["units_sold"] as? [NSDictionary] {
                            for dict in data {
                                let value = UnitsSold(dictionary: dict)
                                self.array_MostSoldProducts.append(value)
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
    
    func callGetLeaderboardMostLikedPostsAPI(showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        self.array_MostLikedPost.removeAll()
        let url = Network.APIEndPoints.mostLiked.rawValue
        service.getAPIs(urlName: url, showLoader: loader, outhType: "", success: { (success) -> Void in
            if let value = success["status"] {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool {
                    if let result = success["response"] as? NSDictionary {
                        if let data = result["most_liked"] as? [NSDictionary] {
                            for dict in data {
                                let value = HomePost(dictionary: dict)
                                self.array_MostLikedPost.append(value)
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
}
