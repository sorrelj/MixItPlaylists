//
//  AlertObject.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 10/10/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation

struct AlertObject: Decodable {
    // title of the alert
    var title: String
    
    // main message of the alert
    var message: String
    
    // button text for the alert
    var button: String
    
    init(){
        self.title = "title"
        self.message = "message"
        self.button = "button"
    }
    
    init(title: String, message: String, button: String){
        self.title = title
        self.message = message
        self.button = button
    }
    
    
}
