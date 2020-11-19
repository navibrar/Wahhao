//
//  ProductImages.swift
//  ConsumerReward
//
//  Created by Apple on 13/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.
//

import Foundation

struct ProductImages{
    
    var large: String
    var small: String
    var medium: String
    var media_type: String
    var orignal: String
    var Thumbnail: String
    var media_url: String
    
    var resolutionWidth : Float
    var resolutionHeight : Float

    init(dictionary: NSDictionary){
        self.large = dictionary["large"] as? String ?? ""
        self.medium = dictionary["medium"]  as? String ?? ""
        self.orignal = dictionary["original"] as? String ?? ""
        self.Thumbnail = dictionary["thumbnail"]  as? String ?? ""
        self.small = dictionary["small"]  as? String ?? ""
        self.media_type = dictionary["media_type"]  as? String ?? ""
        self.media_url = dictionary["media_url"]  as? String ?? ""
        let resolution_width  = dictionary["width"] ?? 0
        let resolution_height  = dictionary["height"] ?? 0
        
        self.resolutionWidth = Float(resolution_width as? Int ?? 0)
        self.resolutionHeight = Float(resolution_height as? Int ?? 0)

    }
}
