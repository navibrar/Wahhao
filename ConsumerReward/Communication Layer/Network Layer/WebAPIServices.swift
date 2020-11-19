    //  Created by administrator on 11/01/18.
    //  Copyright © 2018 Nvish. All rights reserved.
    
    import Foundation
    import Alamofire
    import SVProgressHUD
    //import CryptoSwift
    
    typealias jsonData = [String: Any]
    
    struct WebAPIServices {
        
        func postAPIs(urlName: String, andParams parameters: [String: Any], showLoader loader: Bool, outhType:String, success successBlock: @escaping ((AnyObject) -> Void), failure failureBlock: ((AnyObject) -> Void)) {
            if (Reachability()?.isReachable)! == false {
                let error = ["message": ConfigurationManager.Network.weakInternetConnection, "status": 0] as [String : Any]
                successBlock(error as AnyObject)
                return
            }
            if loader {
                showActivityIndicator()
            }
            let url = Network.baseURL + urlName
            let userAccount = Network.currentAccount
            var header = Network.appHeader
            if outhType.caseInsensitiveCompare("Bearer") == .orderedSame {
                if userAccount != nil{
                    header = ["Content-Type":"application/json","Authorization":"Bearer \((userAccount?.access_token)!) "]
                    print(header)
                }
            }else if outhType.caseInsensitiveCompare("OAuth") == .orderedSame {
                /*let magentoAuthRequest = MagentoOAuth()
                let urlString = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                magentoAuthRequest.apiUrl = urlString!
                magentoAuthRequest.generateSignature(apiType: "Post") { (auth) in
                    //print(auth)
                    header = ["Content-Type":"application/json","Authorization":auth]
                }*/
            }else {
                if userAccount != nil{
                    header = ["Accept":"application/json", "Authorization":(userAccount?.access_token)!, "Content-Type":"application/json", "device":"ios", "lang":"en"]
                }
                print(header)
            }
            let urlString = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            print("URL: \(urlString ?? "No url")")
            print("Parameters: \(parameters)")
            print("Access Token: \(userAccount?.access_token ?? "No access token")")
            Alamofire.request(urlString!, method: .post, parameters: parameters,
                              encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                                print(response)
                                hideActivityIndicator()
                                switch response.result {
                                case .failure(let error):
                                    successBlock(error as AnyObject)
                                    break
                                case .success(_) :
                                    do{
                                        let dictionary = try JSONSerialization.jsonObject(with:response.data!, options:JSONSerialization.ReadingOptions.allowFragments)
                                        //completion(dictionary as! jsonData,err!)
                                        if let code = (dictionary as! jsonData)["code"] {
                                            if (code as? Int) == 303 {
                                                print( code as! Int)
                                                handleInvalidAccessToken()
                                            }else {
                                                successBlock(dictionary as! jsonData as AnyObject)
                                            }
                                        }else {
                                            successBlock(dictionary as! jsonData as AnyObject)
                                        }
                                    }catch{
                                    }
                                    break
                                }
            }
        }
        
        func updateAPIs(urlName: String, showLoader loader: Bool, outhType:String, success successBlock: @escaping ((AnyObject) -> Void), failure failureBlock: ((AnyObject) -> Void)) {
            if (Reachability()?.isReachable)! == false {
                let error = ["message": ConfigurationManager.Network.weakInternetConnection, "status": 0] as [String : Any]
                successBlock(error as AnyObject)
                return
            }
            if loader {
                showActivityIndicator()
            }
            let url = Network.baseURL + urlName
            let userAccount = Network.currentAccount
            var header = Network.appHeader
            if outhType.caseInsensitiveCompare("Bearer") == .orderedSame {
                if userAccount != nil{
                    header = ["Content-Type":"application/json","Authorization":"Bearer \((userAccount?.access_token)!) "]
                    print(header)
                }
            }else if outhType.caseInsensitiveCompare("OAuth") == .orderedSame {
                /*let magentoAuthRequest = MagentoOAuth()
                 let urlString = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                 magentoAuthRequest.apiUrl = urlString!
                 magentoAuthRequest.generateSignature(apiType: "Post") { (auth) in
                 //print(auth)
                 header = ["Content-Type":"application/json","Authorization":auth]
                 }*/
            }else {
                if userAccount != nil{
                    header = ["Accept":"application/json", "Authorization":(userAccount?.access_token)!, "Content-Type":"application/json", "device":"ios", "lang":"en"]
                }
                print(header)
            }
            let urlString = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            print("URL: \(urlString ?? "No url")")
            print("Access Token: \(userAccount?.access_token ?? "No access token")")
            Alamofire.request(urlString!, method: .post, parameters: nil,
                              encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                                print(response)
                                hideActivityIndicator()
                                switch response.result {
                                case .failure(let error):
                                    successBlock(error as AnyObject)
                                    break
                                case .success(_) :
                                    do{
                                        let dictionary = try JSONSerialization.jsonObject(with:response.data!, options:JSONSerialization.ReadingOptions.allowFragments)
                                        //completion(dictionary as! jsonData,err!)
                                        if let code = (dictionary as! jsonData)["code"] {
                                            if (code as? Int) == 303 {
                                                print( code as! Int)
                                                handleInvalidAccessToken()
                                            }else {
                                                successBlock(dictionary as! jsonData as AnyObject)
                                            }
                                        }else {
                                            successBlock(dictionary as! jsonData as AnyObject)
                                        }
                                    }catch{
                                    }
                                    break
                                }
            }
        }
        
        func deleteAPI(urlName: String, andParams parameters:[String:Any], showLoader loader: Bool, outhType:String, success successBlock: @escaping ((AnyObject) -> Void), failure failureBlock: ((AnyObject) -> Void)) {
            if (Reachability()?.isReachable)! == false {
                let error = ["message": ConfigurationManager.Network.weakInternetConnection, "status": 0] as [String : Any]
                successBlock(error as AnyObject)
                return
            }
            if loader {
                showActivityIndicator()
            }
            let url = Network.baseURL + urlName
            let userAccount = Network.currentAccount
            var header = Network.appHeader
            if outhType.caseInsensitiveCompare("Bearer") == .orderedSame {
                if userAccount != nil{
                    header = ["Content-Type":"application/json","Authorization":"Bearer \((userAccount?.access_token)!) "]
                    print(header)
                }
            }else if outhType.caseInsensitiveCompare("OAuth") == .orderedSame {
                /*let magentoAuthRequest = MagentoOAuth()
                 let urlString = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                 magentoAuthRequest.apiUrl = urlString!
                 magentoAuthRequest.generateSignature(apiType: "Post") { (auth) in
                 //print(auth)
                 header = ["Content-Type":"application/json","Authorization":auth]
                 }*/
            }else {
                if userAccount != nil{
                    header = ["Accept":"application/json", "Authorization":(userAccount?.access_token)!, "Content-Type":"application/json", "device":"ios", "lang":"en"]
                }
                print(header)
            }

            let urlString = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            print("URL: \(urlString ?? "No url")")
            print("Access Token: \(userAccount?.access_token ?? "No access token")")
            print("parameters: ",parameters)

            Alamofire.request(urlString!, method: .delete, parameters: parameters,
                              encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                                print(response)
                                hideActivityIndicator()
                                switch response.result {
                                case .failure(let error):
                                    successBlock(error as AnyObject)
                                    break
                                case .success(_) :
                                    do{
                                        let dictionary = try JSONSerialization.jsonObject(with:response.data!, options:JSONSerialization.ReadingOptions.allowFragments)
                                        //completion(dictionary as! jsonData,err!)
                                        if let code = (dictionary as! jsonData)["code"] {
                                            if (code as? Int) == 303 {
                                                print( code as! Int)
                                                handleInvalidAccessToken()
                                            }else {
                                                successBlock(dictionary as! jsonData as AnyObject)
                                            }
                                        }else {
                                            successBlock(dictionary as! jsonData as AnyObject)
                                        }
                                    }catch{
                                    }
                                    break
                                }
            }
        }
        
        func getAPIs(urlName: String, showLoader loader: Bool, outhType:String, success successBlock: @escaping ((AnyObject) -> Void), failure failureBlock: ((AnyObject) -> Void)) {
            if (Reachability()?.isReachable)! == false {
                let error = ["message": ConfigurationManager.Network.weakInternetConnection, "status": 0] as [String : Any]
                successBlock(error as AnyObject)
                return
            }
            if loader {
                showActivityIndicator()
            }
            let url = Network.baseURL + urlName
            let userAccount = Network.currentAccount
            var header = Network.appHeader
            if outhType.caseInsensitiveCompare("Bearer") == .orderedSame {
                if userAccount != nil{
                    header = ["Content-Type":"application/json","Authorization":"Bearer \((userAccount?.access_token)!) "]
                }
            }else if outhType.caseInsensitiveCompare("OAuth") == .orderedSame {
                /*let magentoAuthRequest = MagentoOAuth()
                let urlString = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                magentoAuthRequest.apiUrl = urlString!
                magentoAuthRequest.generateSignature(apiType: "Get") { (auth) in
                    //print(auth)
                    header = ["Content-Type":"application/json","Authorization":auth]
                }*/
            }else {
                if userAccount != nil{
                    header = ["Accept":"application/json", "Authorization":(userAccount?.access_token)!, "Content-Type":"application/json", "device":"ios", "lang":"en"]
                }
                print(header)
            }
            let urlString = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            print("URL: \(urlString ?? "No url")")
            print("Access Token: \(userAccount?.access_token ?? "No access token")")
            Alamofire.request(urlString!, method: .get,
                              encoding: JSONEncoding.default, headers:header).responseJSON { (response) in
                                print(response)
                                hideActivityIndicator()
                                switch response.result {
                                case .failure(let error):
                                    successBlock(error as AnyObject)
                                    break
                                case .success(_) :
                                    do{
                                        let dictionary = try JSONSerialization.jsonObject(with:response.data!, options:JSONSerialization.ReadingOptions.allowFragments)
                                        //completion(dictionary as! jsonData,err!)
                                        if let code = (dictionary as! jsonData)["code"] {
                                            if (code as? Int) == 303 {
                                                print( code as! Int)
                                                handleInvalidAccessToken()
                                            }else {
                                                successBlock(dictionary as! jsonData as AnyObject)
                                            }
                                        }else {
                                            successBlock(dictionary as! jsonData as AnyObject)
                                        }
                                    } catch {
                                    }
                                    break
                                }
            }
        }
        
        func putAPIs(urlName: String, showLoader loader: Bool, outhType:String, success successBlock: @escaping ((AnyObject) -> Void), failure failureBlock: ((AnyObject) -> Void)) {
            if (Reachability()?.isReachable)! == false {
                let error = ["message": ConfigurationManager.Network.weakInternetConnection, "status": 0] as [String : Any]
                successBlock(error as AnyObject)
                return
            }
            if loader {
                showActivityIndicator()
            }
            let url = Network.baseURL + urlName
            let userAccount = Network.currentAccount
            var header = Network.appHeader
            if outhType.caseInsensitiveCompare("Bearer") == .orderedSame {
                if userAccount != nil{
                    header = ["Content-Type":"application/json","Authorization":"Bearer \((userAccount?.access_token)!) "]
                }
            }else if outhType.caseInsensitiveCompare("OAuth") == .orderedSame {
                /*let magentoAuthRequest = MagentoOAuth()
                let urlString = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                magentoAuthRequest.apiUrl = urlString!
                magentoAuthRequest.generateSignature(apiType: "Put") { (auth) in
                    //print(auth)
                    header = ["Content-Type":"application/json","Authorization":auth]
                }*/
            }else {
                if userAccount != nil{
                    header = ["Accept":"application/json", "Authorization":(userAccount?.access_token)!, "Content-Type":"application/json", "device":"ios", "lang":"en"]
                }
                print(header)
            }
            let urlString = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            print("URL: \(urlString ?? "No url")")
            print("Access Token: \(userAccount?.access_token ?? "No access token")")
            Alamofire.request(urlString!, method: .put,
                              encoding: JSONEncoding.default, headers:header).responseJSON { (response) in
                                print(response)
                                hideActivityIndicator()
                                switch response.result {
                                case .failure(let error):
                                    successBlock(error as AnyObject)
                                    break
                                case .success(_) :
                                    do{
                                        let dictionary = try JSONSerialization.jsonObject(with:response.data!, options:JSONSerialization.ReadingOptions.allowFragments)
                                        //completion(dictionary as! jsonData,err!)
                                        if let code = (dictionary as! jsonData)["code"] {
                                            if (code as? Int) == 303 {
                                                print( code as! Int)
                                                handleInvalidAccessToken()
                                            }else {
                                                successBlock(dictionary as! jsonData as AnyObject)
                                            }
                                        }else {
                                            successBlock(dictionary as! jsonData as AnyObject)
                                        }
                                    }catch{
                                    }
                                    break
                                }
            }
        }
        
        func putAPIs(urlString: String, showLoader loader: Bool, parameters: [String:Any], outhType:String, success successBlock: @escaping ((AnyObject) -> Void), failure failureBlock: ((AnyObject) -> Void)) {
            if (Reachability()?.isReachable)! == false {
                let error = ["message": ConfigurationManager.Network.weakInternetConnection, "status": 0] as [String : Any]
                successBlock(error as AnyObject)
                return
            }
            if loader {
                showActivityIndicator()
            }
            let url = Network.baseURL + urlString
            let userAccount = Network.currentAccount
            var header = Network.appHeader
            if outhType.caseInsensitiveCompare("Bearer") == .orderedSame {
                if userAccount != nil{
                    header = ["Content-Type":"application/json","Authorization":"Bearer \((userAccount?.access_token)!) "]
                }
            }else if outhType.caseInsensitiveCompare("OAuth") == .orderedSame {
                /*let magentoAuthRequest = MagentoOAuth()
                let urlString = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                magentoAuthRequest.apiUrl = urlString!
                magentoAuthRequest.generateSignature(apiType: "Put") { (auth) in
                    //print(auth)
                    header = ["Content-Type":"application/json","Authorization":auth]
                }*/
            }else {
                if userAccount != nil{
                    header = ["Accept":"application/json", "Authorization":(userAccount?.access_token)!, "Content-Type":"application/json", "device":"ios", "lang":"en"]
                }
                print(header)
            }
            let urlString = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            
            print("URL: \(urlString ?? "No url")")
            print("Parameters: \(parameters)")
            print("Access Token: \(userAccount?.access_token ?? "No access token")")
            Alamofire.request(urlString!, method: .put, parameters: parameters,
                              encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                                print(response)
                                hideActivityIndicator()
                                switch response.result {
                                case .failure(let error):
                                    successBlock(error as AnyObject)
                                    break
                                case .success(_) :
                                    do{
                                        let dictionary = try JSONSerialization.jsonObject(with:response.data!, options:JSONSerialization.ReadingOptions.allowFragments)
                                        //completion(dictionary as! jsonData,err!)
                                        if let code = (dictionary as! jsonData)["code"] {
                                            if (code as? Int) == 303 {
                                                print( code as! Int)
                                                handleInvalidAccessToken()
                                            }else {
                                                successBlock(dictionary as! jsonData as AnyObject)
                                            }
                                        }else {
                                            successBlock(dictionary as! jsonData as AnyObject)
                                        }
                                    }catch{
                                    }
                                    break
                                }
            }
        }
        
        func uploadFileToServerAsData(fileData: Data?, fileName:String, fileType: String, forKey: String, apiName:String, showLoader loader: Bool, onCompletion: ((AnyObject?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
            if (Reachability()?.isReachable)! == false {
                let error = ["message": ConfigurationManager.Network.weakInternetConnection, "status": 0] as [String : Any]
                onError?(error as? Error)
                return
            }
            if loader {
                showActivityIndicator()
            }
            let serverURL = Network.baseURL + apiName
            let userAccount = Network.currentAccount
            let headers: HTTPHeaders = [
                "Authorization":(userAccount?.access_token)!,
                "Content-Type": "application/json",
                "lang":"en",
                "device":"ios"
            ]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(fileData!, withName: forKey, fileName: fileName, mimeType: fileType)
            }, usingThreshold: UInt64.init(), to: serverURL, method: .post, headers: headers) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress :\(Progress.fractionCompleted)")
                    })
                    upload.responseString(completionHandler: { (response) in
                        print(response)
                    })
                    upload.responseJSON { response in
                        print("Succesfully uploaded")
                        hideActivityIndicator()
                        print(response)
                        
                        if let JSON = response.result.value {
                            print(JSON)
                            let responseObj = response.value as! NSDictionary
                            onCompletion?(responseObj)
                        }
                        if let err = response.error{
                            onError?(err)
                            return
                        }
                    }
                case .failure(let error):
                    hideActivityIndicator()
                    print("Error in upload: \(error.localizedDescription)")
                    onError?(error)
                }
            }
        }
        
        func uploadFileToServerAsDataWithMultipleParameters(parameters:[String:Any], fileData: Data?, fileName:String, fileType: String, forKey: String, apiName:String, showLoader loader: Bool, onCompletion: ((AnyObject?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
            if (Reachability()?.isReachable)! == false {
                let error = ["message": ConfigurationManager.Network.weakInternetConnection, "status": 0] as [String : Any]
                onError?(error as? Error)
                return
            }
            if loader {
                showActivityIndicator()
            }
            let serverURL = Network.baseURL + apiName
            let userAccount = Network.currentAccount
            let headers: HTTPHeaders = [
                "Authorization":(userAccount?.access_token)!/*,
                 "Content-type": "multipart/encrypted"
                //multipart/encrypted
                //multipart/form-data*/
            ]
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(fileData!, withName: forKey, fileName: fileName, mimeType: fileType)
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }, usingThreshold: UInt64.init(), to: serverURL, method: .post, headers: headers) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress :\(Progress.fractionCompleted)")
                    })
                    upload.responseString(completionHandler: { (response) in
                        print(response)
                    })
                    upload.responseJSON { response in
                        print("Succesfully uploaded")
                        hideActivityIndicator()
                        print(response)
                        
                        if let JSON = response.result.value {
                            print(JSON)
                            let responseObj = response.value as! NSDictionary
                            onCompletion?(responseObj)
                        }
                        if let err = response.error{
                            onError?(err)
                            return
                        }
                    }
                case .failure(let error):
                    hideActivityIndicator()
                    print("Error in upload: \(error.localizedDescription)")
                    onError?(error)
                }
            }
        }
        
        func callUploadFileToServerAsFileURL(filePath: String,fileName:String,fileType: String, forKey: String, apiName:String,showLoader loader: Bool, onCompletion: ((AnyObject?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil) {
            if (Reachability()?.isReachable)! == false {
                let error = ["message": ConfigurationManager.Network.weakInternetConnection, "status": 0] as [String : Any]
                onError?(error as? Error)
                return
            }
            let serverURL = Network.baseURL + apiName
            let account = Network.currentAccount
            if loader {
                showActivityIndicator()
            }
            let headers: HTTPHeaders = [
                /*  "Country-code": getCountryinfo,
                 "Authorization":(account?.access_token)!,
                 "Content-type": "multipart/form-data"
                 "Auth-Identifier":(account?.access_token)!*/
                "Authorization":(account?.access_token)!,
                "Content-Type": "application/json",
                "lang":"en",
                "device":"ios"
            ]
            let fileURL = URL(fileURLWithPath: filePath)
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(fileURL, withName: forKey, fileName: fileName, mimeType: fileType)
            }, usingThreshold: UInt64.init(), to: serverURL, method: .post, headers: headers) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress :\(Progress.fractionCompleted)")
                    })
                    upload.responseString(completionHandler: { (response) in
                        print(response)
                    })
                    upload.responseJSON { response in
                        print("Succesfully uploaded")
                        hideActivityIndicator()
                        print(response)
                        
                        if let JSON = response.result.value {
                            print(JSON)
                            let responseObj = response.value as! NSDictionary
                            onCompletion?(responseObj)
                        }
                        if let err = response.error{
                            onError?(err)
                            return
                        }
                    }
                case .failure(let error):
                    hideActivityIndicator()
                    print("Error in upload: \(error.localizedDescription)")
                    onError?(error)
                }
            }
        }
    }
    
    
    /*func showActivityIndicator() {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)        //HUD Color
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)    //Background Color
        //SVProgressHUD.setForegroundColor(UIColor.color(.appThemeColor))           //Ring Color
        SVProgressHUD.setForegroundColor(UIColor.color(.blueSelectedColor))
        SVProgressHUD.show()
        /*SVProgressHUD.setDefaultMaskType(.clear)
         SVProgressHUD.show()*/
    }
    func hideActivityIndicator() {
        SVProgressHUD.dismiss()
    }*/
    func showActivityIndicator() {
        DispatchQueue.main.async {
            let application = UIApplication.shared
            let controller = application.topViewController
            //print(controller!)
            let loader = WahhaoLoader.sharedInstance
            loader.showWahhaoLoader(controller: controller!)
        }
    }
    func hideActivityIndicator() {
        let loader = WahhaoLoader.sharedInstance
        loader.hideWahhaoLoader()
    }
    
    func handleInvalidAccessToken() {
        /*_ = KeychainWrapper.standard.removeAllKeys()
        let appDel = UIApplication.shared.delegate as? AppDelegate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        let navController = UINavigationController(rootViewController: vc)
        appDel?.window?.rootViewController = navController*/
    }
    
    extension UIApplication{
        var topViewController: UIViewController?{
            if keyWindow?.rootViewController == nil{
                return keyWindow?.rootViewController
            }
            var pointedViewController = keyWindow?.rootViewController
            
            while  pointedViewController?.presentedViewController != nil {
                switch pointedViewController?.presentedViewController {
                case let navagationController as UINavigationController:
                    pointedViewController = navagationController.viewControllers.last
                case let tabBarController as UITabBarController:
                    pointedViewController = tabBarController.selectedViewController
                default:
                    pointedViewController = pointedViewController?.presentedViewController
                }
            }
            return pointedViewController
            
        }
    }
