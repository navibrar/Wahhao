//  Created by Navpreet on 24/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import Foundation

struct Validations {
    static func isValidEmailAddress(emailId: String) -> Bool {
       let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        //let emailRegEx  = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailId)
    }
    static func isValidPhoneNumber(phoneNumber: String) -> Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: phoneNumber, options: [], range: NSMakeRange(0, phoneNumber.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == phoneNumber.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    static func isValidPhoneCountryBased(phoneNumber:String,countryCode : String) -> Bool {
        if countryCode == "+86" {
            //maxLength = 11
            if (phoneNumber.trimmingCharacters(in: .whitespaces).count) <= 10 {
                return false
            }else {
                return true
            }
        }else {
            //maxLength = 10
            if (phoneNumber.trimmingCharacters(in: .whitespaces).count) <= 9 {
                return false
            }else {
                return true
            }
        }
        //return false
    }
    static func getMimeType(file_extenstion: String) -> String {
        var fileType = ""
        if file_extenstion.caseInsensitiveCompare("pdf") == .orderedSame {
            fileType = "application/pdf"
        }else if file_extenstion.caseInsensitiveCompare("doc") == .orderedSame || file_extenstion.caseInsensitiveCompare("docx") == .orderedSame {
            fileType = "application/msword"
        }else if file_extenstion.caseInsensitiveCompare("jpg") == .orderedSame || file_extenstion.caseInsensitiveCompare("jpeg") == .orderedSame {
            fileType = "image/jpeg"
        }else if file_extenstion.caseInsensitiveCompare("png") == .orderedSame {
            fileType = "image/png"
        }else if file_extenstion.caseInsensitiveCompare("txt") == .orderedSame {
            fileType = "text/plain"
        }else if file_extenstion.caseInsensitiveCompare("rtf") == .orderedSame {
            fileType = "application/rtf"
        }else if file_extenstion.caseInsensitiveCompare("xls") == .orderedSame {
            fileType = "application/vnd.ms-excel"
        }
        return fileType
    }
    static func isValidUrl (url: String) -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: url)
    }
}
