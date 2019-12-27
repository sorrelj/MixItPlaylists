//
//  SpotifyArtistModel.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/19/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation

struct SpotifyArtistModel: Identifiable {

    // spotify id
    var id: String
    
    // image
    var image: UIImage
    
    // name
    var name: String
    
    init(){
        self.id = ""
        self.image = UIImage()
        self.name = ""
    }
    
    // init with image
    init(id: String, image: UIImage, name: String){
        self.id = id
        self.image = image
        self.name = name
    }
    
    // init no image
    init(id: String, name: String){
        self.id = id
        self.name = name
        self.image = UIImage()
    }
}
