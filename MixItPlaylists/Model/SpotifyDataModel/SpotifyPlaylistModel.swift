//
//  SpotifyPlaylistModel.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 12/19/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation

struct SpotifyPlaylistModel: Identifiable {

    // spotify id
    var id: String
    
    // image
    var image: UIImage
    
    // name
    var name: String
    
    // description
    var description: String
    
    init(){
        self.id = ""
        self.image = UIImage()
        self.name = ""
        self.description = ""
    }
    
    init(id: String, image: UIImage, name: String, description: String){
        self.id = id
        self.image = image
        self.name = name
        self.description = description
    }
}
