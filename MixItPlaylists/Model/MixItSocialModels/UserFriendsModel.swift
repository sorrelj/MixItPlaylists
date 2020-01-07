//
//  UserFriendsModel.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 1/7/20.
//  Copyright © 2020 MixIt. All rights reserved.
//

import Foundation

struct UserFriendsModel: Identifiable {
    
    // username
    var id: String
    
    // image
    var image: UIImage
    
    init(){
        self.id = ""
        self.image = UIImage()
    }
    
    init(username: String, image: UIImage){
        self.id = username
        self.image = image
    }
    
}
