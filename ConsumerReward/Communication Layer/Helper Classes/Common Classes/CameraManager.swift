//  Created by Navpreet on 05/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import Foundation
import UIKit

final class CameraManager {
    static func getImageData_Name_MimeType(image: UIImage, viewController: UIViewController, imageName: String) -> (imageData: Data, fileName: String, mimeType: String) {
        var fileName = imageName
        if imageName == "" {
            let dateStr = Date.CONVERT_DATE_TO_STRING(formatter: "dd_MM_yy_hh_mm_ss", date: Date())
            fileName = String(format:"Image_\(dateStr).jpg")
        }
        let imageData = image.jpegData(compressionQuality: 0.5)
        //*********File Size************
        let fileSize : Double = Double(imageData!.count)
        let size = (fileSize/1000.0)/1000.0
        if size > FILE_SIZE {
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "lableFileSizeError"), btnTitle: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelOk"), viewController: viewController, completionHandler: { (success) in
                return
            })
        }
        return(imageData!, fileName, "image/jpg")
    }
}
