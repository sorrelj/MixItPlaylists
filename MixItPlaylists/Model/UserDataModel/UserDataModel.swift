//
//  UserDataModel.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 1/1/20.
//  Copyright © 2020 MixIt. All rights reserved.
//

import Foundation

struct UserDataModel {
    
    // username
    var username: String
    
    // imageID
    var imageID: String
    
    // number
    var number: String
    
    // init
    init() {
        self.username = ""
        self.imageID = ""
        self.number = ""
    }
    
    init(username: String, imageID: String, number: String){
        self.username = username
        self.imageID = imageID
        self.number = number
    }
}

