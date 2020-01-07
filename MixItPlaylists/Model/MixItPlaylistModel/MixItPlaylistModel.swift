//
//  MixItPlaylistModel.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 10/29/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation


struct MixItPlaylistModel: Identifiable {

    // id
    var id: String
    
    // playlist creator
    var playlistCreator: String
    
    // type
    var type: String
    
    // status
    var status: String
    
    // spotify playlist data
    var spotifyData: SpotifyPlaylistModel
    
    init(){
        self.id = ""
        self.playlistCreator = ""
        self.type = ""
        self.status = ""
        self.spotifyData = SpotifyPlaylistModel()
    }
    
    init(id: String, playlistCreator: String, type: String, status: String, spotifyData: SpotifyPlaylistModel){
        self.id = id
        self.playlistCreator = playlistCreator
        self.type = type
        self.status = status
        self.spotifyData = spotifyData
    }
    
    
}
