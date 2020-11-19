//
//  GetChatDetails.swift
//  Brand
//
//  Created by Apple on 15/10/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import Foundation
final class GetChatDetails
{
    static let sharedInstance = GetChatDetails()
   //  static let sharedInstance = BrandProfileServices()
    var ChatDeatil : ChatDetails? = nil
    func callChatDetailData(value : String,showLoader loader: Bool, outhType:String,completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let getUrl = Network.APIEndPoints.chatDetail.rawValue
         let url = getUrl + value
        service.getAPIs(urlName: url, showLoader: loader, outhType: outhType, success: { (success) -> Void in
            if let value = success["status"]
            {
                if value == nil {
                    failBlock(success)
                    return
                }
                if value as! Bool
                {
                    let result = success["response"] as? NSDictionary
                    // let profileDetal = result!["profile_details"] as? NSDictionary
                    self.ChatDeatil = nil
                    let value = ChatDetails(dictionary: result!)
                    self.ChatDeatil = value
                    aBlock (success as AnyObject)
                }
                else {
                    failBlock(success)
                }
            } else {
                failBlock(success)
            }
            // your successful handle
        }) { (failure) -> Void in
            // your failure handle
            failBlock(failBlock as AnyObject)
        }
    }
    
    func callWebserviceforsendMsg(parameters: [String: Any],outhType:String, isShowLoader: Bool, showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        if loader {
            // Show loader
        }
        let service = WebAPIServices()
      let getUrl = Network.APIEndPoints.chatsend.rawValue
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
    
    
    func uploadFileToServerAsDataForDoccument (fileData : Data?,fileName:String, fileType: String, forKey: String, showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
        let Url = Network.APIEndPoints.chatassests.rawValue
        service.uploadFileToServerAsData(fileData: fileData, fileName: fileName, fileType: fileType, forKey: forKey, apiName: Url, showLoader: true ,onCompletion: { (respone) in
            print(respone!)
            
            
            if (respone as! NSDictionary)["status"] as! Bool == true {
                aBlock (respone!)
            }
            //                let id = ((respone as! NSDictionary)["response"] as! NSDictionary)["resource_id"] as! Int
            //                self.array_UplaodedDocs.append(["id":id, "name":file_name])
            //                self.collection_Documents.reloadData()
            //            }else{
            //                SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelSomethingWrong"), btnTitle: self.str_OK, viewController: self, completionHandler: { (success) in
            //                })
            //            }
            //            REMOVE_LOADING_VIEW(view: self.view)
        }) { (failure) in
            failBlock(failBlock as AnyObject)
            
            //            print(error?.localizedDescription ?? "Unable to upload file to server")
            //            REMOVE_LOADING_VIEW(view: self.view)
        }
    }
    func callUploadPostMediaFileToServerAsFileURL(filePath : String,fileName:String, fileType: String, forKey: String, showLoader loader: Bool, completionBlockSuccess aBlock: @escaping ((AnyObject) -> Void), andFailureBlock failBlock: @escaping ((AnyObject) -> Void)) {
        let service = WebAPIServices()
         let Url = Network.APIEndPoints.chatassests.rawValue
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
    
}
