//
//  SpotifyAlbumModel.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 12/19/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation

struct SpotifyAlbumModel: Identifiable {

    // spotify id
    var id: String
    
    // name
    var name: String
    
    // image
    var image: UIImage
    
    
    init(){
        self.id = ""
        self.image = UIImage()
        self.name = ""
    }
    
    init(id: String, name: String, image: UIImage){
        self.id = id
        self.image = image
        self.name = name
    }
}
