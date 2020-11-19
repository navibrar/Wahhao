//  Created by Navpreet on 30/11/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import Foundation
import UIKit

final class ConfigurationManager {
    //MARK:- Privacy Permission Messages
    enum PrivacyPermissionMessage: String {
        case Image_Capture_Permission_Message = "This app is not authorized to use Camera. Please allow camera access."
        case Image_Picker_Permission_Message = "This app is not authorized to use photos. Please allow photo library access."
        case Video_Capture_Permission_Message = "This app is not authorized to use video Camera. Please allow camera access."
        case Video_Picker_Permission_Message = "This app is not authorized to use videos. Please allow video library access."
        case Microphone_Usage_Permission_Message = "This app is not authorized to use microphone. Please allow microphone access."
        case Media_Library_Usage_Permission_Message = "This app is not authorized to use media library. Please allow media library access."
        case Location_Usage_Permission_Message = "This app is not authorized to use your location. Please allow location access."
    }
    //MARK:- Internet Message
    enum Network {
        static let weakInternetConnection = "Internet connection is weak or not available. Please try again later."
    }
    //MARK:- Country Codes
    enum CountryCode: String {
        case US = "+1"
        case Chine = "+86"
    }
    
    //MARK:- Character Length
    enum  CharacterLength {
        case UserNameMaxLength
        case ReferralCodeMaxLength
        case FullNameMaxLength
        case FullNameMinLength
        case UserNameMinLength
        case LoginVerficationCode
        case PhoneNumberLengthUS
        case PhoneNumberLengthChina
        case UserInterestMinimumCategorySelection
        case ProfileChildAdditionalHeight
        case Address
        case ZipCode
        case Apartment
        case City
        case State
        case MinimumLength
        case EmailLength
        var value: Int {
            switch self {
            case .UserNameMaxLength, .ReferralCodeMaxLength:
                return 20
            case .FullNameMaxLength:
                return 50
            case .FullNameMinLength, .UserNameMinLength:
                return 2
            case .LoginVerficationCode:
                return 6
            case .PhoneNumberLengthUS:
                return 10
            case .PhoneNumberLengthChina:
                return 11
            case .UserInterestMinimumCategorySelection:
                return 3
            case .ProfileChildAdditionalHeight:
                return 20
            case .Address:
                return 50
            case .Apartment:
                return 50
            case .City:
                return 50
            case .State:
                return 50
            case .ZipCode:
                return 5
            case .MinimumLength:
                return 2
            case .EmailLength:
                return 100
            }
        }
    }
}
