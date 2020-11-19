
import Foundation
import Alamofire

struct LoginServices {
    func callRegisterUserAPI (parameters: [String: Any], showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.signUp.rawValue
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
    
    func callGenerateOTPAPI (parameters: [String: Any], showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        //otp_request
        let service = WebAPIServices()
        let url = Network.APIEndPoints.login.rawValue
        service.postAPIs (urlName: url, andParams: parameters, showLoader: loader, outhType: "", success: { (success) -> Void in
            if let value = success["status"] {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool {
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
    func callVerifyOTPAPI (parameters: [String: Any], isLogin: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        var url = ""
        if isLogin == true {
            url = Network.APIEndPoints.loginAuthentication.rawValue
        }else {
            url = Network.APIEndPoints.signUpAuthentication.rawValue
        }
        service.postAPIs (urlName: url, andParams: parameters, showLoader: true, outhType: "", success: { (success) -> Void in
            if let value = success["status"] as? Bool {
                if value == true {
                    //user_info
                    let result = success as! NSDictionary
                    print(result)
                    if let response = result["response"] as? NSDictionary {
                        if let userInfo = response["user_info"] as? NSDictionary {
                            LoginServices.saveUserData(userInfo: userInfo)
                        }
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
    func callVerifySocialLoginRegisterAPi (parameters: [String: Any],isLogin: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        var url = ""
        if isLogin == true {
            url = Network.APIEndPoints.socialLogin.rawValue
        }else {
            url = Network.APIEndPoints.socialRegister.rawValue
        }
        service.postAPIs (urlName: url, andParams: parameters, showLoader: true, outhType: "", success: { (success) -> Void in
            if let value = success["status"] as? Bool {
                if value == true {
                    //user_info
                    let result = success as! NSDictionary
                    print(result)
                    if let response = result["response"] as? NSDictionary {
                        if let userInfo = response["user_info"] as? NSDictionary {
                            LoginServices.saveUserData(userInfo: userInfo)
                        }
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
    func callGetUserInterestsAPI(isSocialLogin: Bool, socialId: String, showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        var url = ""
        if isSocialLogin == true {
           url = Network.APIEndPoints.getUserInterests.rawValue + "/\(socialId)"
        }else {
           url = Network.APIEndPoints.getUserInterests.rawValue
        }
        service.getAPIs(urlName: url, showLoader: loader, outhType: "", success: { (success) -> Void in
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
    func callSetUserInterestsAPI (parameters: [String: Any], showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.createProfile.rawValue
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
    func callUploadUserProfileImageAPI(parameters: [String:Any], fileData : Data?,fileName:String, fileType: String, forKey: String, showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.addProfileImage.rawValue
        service.uploadFileToServerAsDataWithMultipleParameters(parameters: parameters, fileData: fileData, fileName: fileName, fileType: fileType, forKey: forKey, apiName: url, showLoader: loader, onCompletion: { (respone) in
            print(respone!)
            if (respone as! NSDictionary)["status"] as! Bool == true {
                aBlock (respone!)
            }
        }) { (failure) in
            failBlock(failBlock as AnyObject)
        }
    }
    func removeUserImageAPI (parameters: [String: Any], showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.removeProfileImage.rawValue
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
    func callUpdateUserInterestsAPI (parameters: [String: Any], showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let url = Network.APIEndPoints.updateUserInterests.rawValue
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
    
    //MARK:- SAVE USER DATA
    static func saveUserData(userInfo: NSDictionary) {
        print(userInfo)
        let access_token = userInfo["access_token"] as? String ?? ""
        let has_username = userInfo["has_username"] as? Bool ?? false
        let is_brand = false//userInfo["is_brand"] as? Bool ?? false
        let email = userInfo["email"] as? String ?? ""
        let fullname = userInfo["fullname"] as? String ?? ""
        let username = userInfo["username"] as? String ?? ""
        var registered_mobile = String()
        if  let value = userInfo["mobile_no"] as? Int {
            registered_mobile = String(value)
        }else if  let value = userInfo["mobile_no"] as? NSNumber {
            registered_mobile = value.stringValue
        }else {
            registered_mobile = userInfo["mobile_no"] as? String ?? ""
        }
        var registered_mobile_area_code = String()
        if  let value = userInfo["registered_mobile_area_code"] as? Int {
            registered_mobile_area_code = String(value)
        }else if  let value = userInfo["registered_mobile_area_code"] as? NSNumber {
            registered_mobile_area_code = value.stringValue
        }else {
            registered_mobile_area_code = userInfo["registered_mobile_area_code"] as? String ?? ""
        }
        var id = 0
        if let _ = userInfo["id"] {
            if  let value = userInfo["id"] as? Int {
                id = value
            }else {
                id = Int(userInfo["id"] as? String == "" ? "0" : userInfo["id"] as! String)!
            }
        }
        let profile_image = userInfo["profile_image"] as? String ?? ""
        
        var profile_status = ""
        if let val = userInfo["profile_status"] {
            let status = val as? String ?? ""
            let decoderString = status.utf8DecodedString()
            profile_status = decoderString
        }
        var gender = 0
        if let val = userInfo["gender"] {
            //gender = val as? Int ?? 0
            if  let value = val as? Int {
                gender = value
            }else if  let value = val as? NSNumber {
                gender = value.intValue
            }else {
                gender = Int((val as? String) == "" ? "0" : val as! String)!
            }
        }
        
        var unreadmessages = 0
        if let val = userInfo["unreadmessages"] {
            //gender = val as? Int ?? 0
            if  let value = val as? Int {
                unreadmessages = value
            }else if  let value = val as? NSNumber {
                unreadmessages = value.intValue
            }else {
                unreadmessages = Int((val as? String) == "" ? "0" : val as! String)!
            }
        }
        
        var dob = ""
        if let val = userInfo["dob"] {
            dob = val as? String ?? ""
        }
        var level = "0"
        if let val = userInfo["level"] {
            if  let value = val as? Int {
                level = String(value)
            }else if  let value = val as? NSNumber {
                level = value.stringValue
            }else {
                level = val as? String ?? "0"
            }
        }
        
        var followers = "0"
        if let val = userInfo["followers"] {
            if  let value = val as? Int {
                followers = String(value)
            }else if  let value = val as? NSNumber {
                followers = value.stringValue
            }else {
                followers = val as? String ?? "0"
            }
        }
        
        var followings = "0"
        if let val = userInfo["followings"] {
            if  let value = val as? Int {
                followings = String(value)
            }else if  let value = val as? NSNumber {
                followings = value.stringValue
            }else {
                followings = val as? String ?? "0"
            }
        }
        
        var posts = "0"
        if let val = userInfo["posts"] {
            if  let value = val as? Int {
                posts = String(value)
            }else if  let value = val as? NSNumber {
                posts = value.stringValue
            }else {
                posts = val as? String ?? "0"
            }
        }
        var social_id = ""
        if let val = userInfo["social_id"] {
            social_id = val as? String ?? ""
        }
        
        var cart = 0
        if let val = userInfo["cart"] {
            if  let value = val as? Int {
                cart = value
            }else if  let value = val as? NSNumber {
                cart = Int(truncating: value)
            }else {
                cart = val as? Int ?? 0
            }
        }
        
      

        let userAccount = Login(email: email, fullname: fullname, id: id, registered_mobile: registered_mobile, registered_mobile_area_code: registered_mobile_area_code, access_token: access_token, username: username, has_username: has_username, is_brand: is_brand, profile_status: profile_status, gender: gender, dob: dob, profile_image: profile_image, level: level, followers: followers, followings: followings, posts: posts, unreadmessages: unreadmessages, social_id: social_id, total_cart_items: cart)
        
        let saved = userAccount.saveToKeychain()
        print("Is user info saved: \(saved)")
    }
}

