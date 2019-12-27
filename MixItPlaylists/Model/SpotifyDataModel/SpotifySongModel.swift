//
//  SpotifySongModel.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 12/19/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation

struct SpotifySongModel: Identifiable {

    // spotify id
    var id: String
    
    // name
    var name: String
    
    // length ms
    var lengthMS: Float
    
    // total length String
    var stringLength: String
    
    // artist
    var artist: SpotifyArtistModel
    
    // album
    var album: SpotifyAlbumModel

    init(){
        self.id = ""
        self.name = ""
        self.lengthMS = 0
        self.stringLength = "0:00"
        self.artist = SpotifyArtistModel()
        self.album = SpotifyAlbumModel()
    }
    
    init(id: String, name: String, lengthMS: Float, stringLength: String, artistID: String, artistName: String, albumID: String, albumName: String, albumImage: UIImage){
        self.id = id
        self.name = name
        self.lengthMS = lengthMS
        self.stringLength = stringLength
        self.artist = SpotifyArtistModel(id: artistID, name: artistName)
        self.album = SpotifyAlbumModel(id: albumID, name: albumName, image: albumImage)
    }
}
