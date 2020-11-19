//  Created by Navpreet on 14/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import Foundation
import UIKit

extension UIViewController {
    func handleAPIError(failure: AnyObject) {
        print("Failure: \(failure)")
        if let error = failure["message"] as? String {
            self.showAlertWithMessage(title: "", message: error)
        }else{
            self.showAlertWithMessage(title: "", message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelSomethingWrong"))
            return
        }
    }
    func showAlertWithMessage(title: String, message:String) {
        AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: title, message: message, btnTitle: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelOk"), viewController: self) { (success)
            in
        }
    }
}
