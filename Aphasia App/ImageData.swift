//
//  ImageData.swift
//  Aphasia App
//
//  Created by user158243 on 1/12/20.
//  Copyright © 2020 Yuanyuan Zhou. All rights reserved.
//

import Foundation
import UIKit

class ImageData{
    
    let img_url: String
    var img_name: String!
    var img: UIImage!
    let fb_key: String
    let location: String
    
    init(img_url_ :String, img_name_:String, fb_key_:String, location_:String, img_:UIImage ){
        
        img_url = img_url_
        img_name = img_name_
        img = img_
        fb_key = fb_key_
        location = location_
    }
}
