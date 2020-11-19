//  Created by Navpreet on 13/08/18.
//  Copyright © 2018 wahhao. All rights reserved.

import Foundation
import UIKit

struct DeviceType {
    func USER_INTERFACE_IDIOM_PHONE() -> Bool {
        var UserInterfaceIdiomPhone : Bool!
        if UIDevice.current.userInterfaceIdiom == .phone{
            UserInterfaceIdiomPhone = true
        }else{
            UserInterfaceIdiomPhone = false
        }
        return UserInterfaceIdiomPhone
    }
}
extension UIDevice {
    enum ScreenType: String {
        case iPhone4
        case iPhone5E
        case iPhone8
        case iPhone8Plus
        case iPhoneX
        case iPhoneXSMax
        case iPhoneXR
        case iPadRetina
        case iPadPro
        case unknown
    }
    var SCREEN_TYPE: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5E
        case 1334:
            return .iPhone8
        case 2208, 1920:
            return .iPhone8Plus
        case 2436:
            return .iPhoneX
        case 2688:
            return .iPhoneXSMax
        case 1792:
            return .iPhoneXR
        case 1536:
            return .iPadRetina
        case 2048:
            return .iPadPro
        default:
            return .unknown
        }
    }
}
