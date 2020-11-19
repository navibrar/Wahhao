//  Created by nvish on 11/05/18.
//  Copyright © 2018 Apple. All rights reserved.

import Foundation

func GET_US_STATES() -> [NSDictionary] {
    do {
        let fileName = "US-State-Cities"
        if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
            let data = try Data(contentsOf: file)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let object = json as? [String: Any] {
                // json is a dictionary
                let dict = (object["states"] as! [NSDictionary])
                return dict //as! [Dictionary<String, Any>] as [NSDictionary]
            }else {
                //JSON is Invalid
                return []
            }
        }else {
            //No File
            return []
        }
    }catch {
        //print(error.localizedDescription)
        return []
    }
}
