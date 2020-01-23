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
    let img_name: String
    var img: UIImage!
    let fb_key: String
    
    init(img_url_ :String, img_name_:String, fb_key_:String){
        
        img_url = img_url_
        img_name = img_name_
        img = UIImage()
        fb_key = fb_key_
    }
}
