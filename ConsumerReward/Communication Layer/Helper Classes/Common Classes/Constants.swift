//  Created by NVISH on 01/05/18.
//  Copyright © 2018 wahhao. All rights reserved.

import Foundation

let NOTIFICATIONCENTER = NotificationCenter.default
let FILE_SIZE : Double = 10.0

//MARK:- KEYBOARD REGEX
let NUMERIC  = "0123456789"
let USERNAME_EMAIL_PHONE = "_.0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@"
let USERNAME = "_.0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
let ALPHA_NUMERIC = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
let ALPHA_NUMERIC_WITH_SPACE = " 0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
let ALPHA_NUMERIC_WITH_POINT = ".0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
let ALPHA_NUMERIC_CODE = " -.0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
let ALPHA_NUMERIC_WITH_POINT_SPACE = " .0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
let CHARACTERS = "0123456789. :-_@abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
let PASSWORD_COMPLEXITY = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$"
//*********************

internal struct Constants {
    static let SECRET_KEY: String = "9ae2d1fb9e58fcf7a2dd7fecacdb24d6be9580f21afa9d62f9f00c723a827048"
    //MARK:- FONTS
    static let LIGHT_FONT: String = "Montserrat-Light"
    static let REGULAR_FONT: String = "Montserrat-Regular"
    static let SEMI_BOLD_FONT: String = "Montserrat-SemiBold"
    static let BOLD_FONT: String = "Montserrat-Bold"
    static let MEDIUM_FONT: String = "Montserrat-Medium"
    static let ITALIC_FONT: String = "Montserrat-Italic"
    
    // MARK:- Country Code
     static let AREA_CODE: String = "1"

    // MARK:- feed count by defaut
    static let RPP_DEFAULT: Int = 20
    
    // MARK:- home feed count by defaut
    static let RPP_HOME_DEFAULT: Int = 20

    // MARK:- dummy Images Name
    static let PRODUCT_DUMMY_IMAGE: String = "product-dummy-image"
    static let USER_DUMMY_IMAGE: String = "user-dummy-image"
    static let BACKGROUND_THEME_DUMMY_IMAGE: String = "bg_theme"


}
