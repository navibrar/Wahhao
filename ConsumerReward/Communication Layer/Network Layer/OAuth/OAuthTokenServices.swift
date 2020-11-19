//  SignupServices.swift


import Foundation
import Alamofire

struct OAuthTokenServices{
    
    func callGetOAuthToken(parameters: [String: Any], showLoader loader: Bool, outhType:String, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        if loader {
            // Show loader
        }
        let service = WebAPIServices()
        let url = "oauth/token"
        service.postAPIs (urlName: url, andParams: parameters, showLoader: true, outhType: outhType, success: { (success) -> Void in
            if let value = success["success"] as? Bool {
                print(value)
                if value == true {
                    let result = success as! NSDictionary
                    if let userInfo = result as? [String: Any] {
                        print(userInfo)
                        KeychainWrapper.standard.set(userInfo["OAuthString"] as! String, forKey: "OAuthString")
                        KeychainWrapper.standard.set(userInfo["accessTokenSecret"] as! String, forKey: "accessTokenSecret")
                        KeychainWrapper.standard.set(userInfo["consumerSecret"] as! String, forKey: "consumerSecret")
                        
                        let oAuthData = userInfo["data"] as? [String: Any]
                        KeychainWrapper.standard.set(oAuthData!["oauth_consumer_key"] as! String, forKey: "oauth_consumer_key")
                        //KeychainWrapper.standard.set(oAuthData!["oauth_nonce"] as! String, forKey: "oauth_nonce")
                        KeychainWrapper.standard.set(oAuthData!["oauth_signature_method"] as! String, forKey: "oauth_signature_method")
                        //KeychainWrapper.standard.set(oAuthData!["oauth_timestamp"] as! String, forKey: "oauth_timestamp")
                        KeychainWrapper.standard.set(oAuthData!["oauth_token"] as! String, forKey: "oauth_token")
                        KeychainWrapper.standard.set(oAuthData!["oauth_version"] as! String, forKey: "oauth_version")
                    }
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
}

