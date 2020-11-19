//  Created by Navpreet on 23/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import Foundation
import UIKit

struct AlertController {
    enum AlertTitle: String {
        case delete = "Delete"
        case error = "Error"
        case alert = "Alert"
        case success = "Success"
        case weakInternet = "Weak Internet Connectivity"
        case connectionFailure = "Internet connection is weak or not available. Please try again later."
        case apiFailure = "Unable to process your request due to some server error. Please try again later."
    }
    
    enum AlertTitleChina: String {
        case delete = "删除"
        case error = "错误"
        case alert = "警报"
        case success = "成功"
        case weakInternet = "互联网连接不畅"
        case connectionFailure = "互联网连接很弱或无法使用。请稍后再试。"
        case apiFailure = "由于某些服务器错误，无法处理您的请求。请稍后再试。"
    }

    //MARK:- ALERT CONTROLLER METHODS
    static func SHOW_ALERT_CONTROLLER_SINGLE_BUTTON_RED_COLOR(alertTitle:String, message:String, btnTitle:String, viewController:UIViewController, completionHandler:@escaping (Bool) -> ()) {
        let alert = ALERT_CONTROLLER(title: alertTitle, message: message)
        let cancelAction = ALERT_CONTROLLER_CANCEL_ACTION_RED_COLOR(title: btnTitle) { (success) in
            completionHandler(true)
        }
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    static func SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle:String, message:String, btnTitle:String, viewController:UIViewController, completionHandler:@escaping (Bool) -> ()) {
        let alert = ALERT_CONTROLLER(title: alertTitle, message: message)
        let cancelAction = ALERT_CONTROLLER_CANCEL_ACTION(title: btnTitle) { (success) in
            completionHandler(true)
        }
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func SHOW_ALERT_CONTROLLER_DOUBLE_BUTTON(alertTitle:String, message:String, btnTitle1:String, btnTitle2:String,viewController:UIViewController,  completionHandler:@escaping (String) -> ()) {
        let alert = ALERT_CONTROLLER(title: alertTitle, message: message)
        let cancelAction = ALERT_CONTROLLER_CANCEL_ACTION(title: btnTitle1) { (success) in
            completionHandler("Button1")
        }
        alert.addAction(cancelAction)
        
        let okAction = ALERT_CONTROLLER_OK_ACTION(title: btnTitle2) { (success) in
            completionHandler("Button2")
        }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func SHOW_ALERT_CONTROLLER_TRIPPLE_BUTTON(alertTitle:String, message:String, btnTitle1:String, btnTitle2:String, btnTitle3:String,viewController:UIViewController,  completionHandler:@escaping (String) -> ())
    {
        let alert = ALERT_CONTROLLER(title: alertTitle, message: message)
        let cancelAction = ALERT_CONTROLLER_CANCEL_ACTION(title: btnTitle1) { (success) in
            completionHandler("Button1")
        }
        alert.addAction(cancelAction)
        
        let okAction = ALERT_CONTROLLER_OK_ACTION(title: btnTitle2) { (success) in
            completionHandler("Button2")
        }
        alert.addAction(okAction)
        let thirdAction = ALERT_CONTROLLER_OK_ACTION(title: btnTitle3) { (success) in
            completionHandler("Button3")
        }
        alert.addAction(thirdAction)
        
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func ALERT_CONTROLLER(title: String, message : String) -> UIAlertController {
        //title == "" ? nil : title
        return  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    }
    
    static func ALERT_CONTROLLER_CANCEL_ACTION(title:String, completionHandler:@escaping (Bool) -> ()) -> UIAlertAction {
        return  UIAlertAction(title: title, style: UIAlertAction.Style.cancel, handler:{                                          UIAlertAction in
            completionHandler(true)
        })
    }
    static func ALERT_CONTROLLER_CANCEL_ACTION_RED_COLOR(title:String, completionHandler:@escaping (Bool) -> ()) -> UIAlertAction {
        return  UIAlertAction(title: title, style: UIAlertAction.Style.destructive, handler:{                                          UIAlertAction in
            completionHandler(true)
        })
    }
    
    static func ALERT_CONTROLLER_OK_ACTION(title:String, completionHandler:@escaping (Bool) -> ()) -> UIAlertAction {
        return  UIAlertAction(title: title, style: UIAlertAction.Style.default, handler:{                                          UIAlertAction in
            completionHandler(true)
        })
    }
    static func SHOW_AUTOHIDE_MESSAGE(controller: UIViewController, message: String, time: Double) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        controller.present(alert, animated: true, completion: nil)
        // Autohide
        let when = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
