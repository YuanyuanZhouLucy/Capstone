//
//  User.swift
//  Aphasia App
//
//  Created by Katherine Bancroft on 2020-01-09.
//  Copyright © 2020 Yuanyuan Zhou. All rights reserved.
//

import Foundation

class User {
    var userName: String
    var slpName: String
    var slpEmail: String
    
    init() {
        userName = ""
        slpName = ""
        slpEmail = ""
    }
    
    init(userName:String, slpName:String, slpEmail:String){
        self.userName = userName
        self.slpName = slpName
        self.slpEmail = slpEmail
    }
}
