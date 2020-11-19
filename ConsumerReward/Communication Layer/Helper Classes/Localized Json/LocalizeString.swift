//  Created by nvish on 11/05/18.
//  Copyright © 2018 Apple. All rights reserved.

import Foundation


func GET_LOCALIZED_STRING(forClass className: String, withKey key: String ) -> String {
    do {
        var fileName = "English"
        if KeychainWrapper.standard.string(forKey: "Language")?.caseInsensitiveCompare("cn") == .orderedSame {
            fileName = "Chinese"
        }
        if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
            let data = try Data(contentsOf: file)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let object = json as? [String: Any] {
                // json is a dictionary
                let title = (object[className] as! [String: Any])[key] as! String
                return title
            } else if let object = json as? [Any]
            {
                // json is an array
                 let title = ((object[0] as! [String: Any]) [className] as! [String: Any])[key] as! String
                return title
            } else {
                //JSON is Invalid
                return ""
            }
        } else {
            //No File
            return ""
        }
    } catch {
        //print(error.localizedDescription)
        return ""
    }
}

func GET_LOCALIZED_STRING_DICTIONARY(forClass className: String) -> [String:String] {
    do {
        var fileName = "English"
        if KeychainWrapper.standard.string(forKey: "Language")?.caseInsensitiveCompare("cn") == .orderedSame {
            fileName = "Chinese"
        }
        fileName = "English"
        if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
            let data = try Data(contentsOf: file)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let object = json as? [String: Any] {
                // json is a dictionary
                let dict = (object[className] as! [String: String])
                return dict
            } else {
                //JSON is Invalid
                return [:]
            }
        } else {
            //No File
            return [:]
        }
    } catch {
        //print(error.localizedDescription)
        return [:]
    }
}
