//
//  GetMyPlaylistsController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 12/31/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation


struct GetMyPlaylistsReturn {
    
    // playlist models
    var playlists: [PlaylistReturnModel]
    
    // error
    var error: Bool
    
    // error message
    var message: String
    
    // init no error
    init(playlists: [PlaylistReturnModel]){
        self.playlists = playlists
        self.error = false
        self.message = ""
    }
    
    // init with error
    init(error: Bool, message: String){
        self.playlists = []
        self.error = error
        self.message = message
    }
    
}

class GetMyPlaylistsController {
    
    func getPlaylists(callback: @escaping (GetMyPlaylistsReturn)->()) {
        // set request
        let req = APIRequest(requestType: .GET, name: .getMyPlaylists, params: [:], withToken: true)
        
        // get username
        
        // get scene
        let scene = UIApplication.shared.connectedScenes.first
        guard let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) else {
            print("Get scene error")
            return
        }
        
        // set username
        let username = sd.userData.username
        
        // perform request
        APINetworkController().apiNetworkRequest(req: req, callback: { resp in
            // 200
            if resp.statusCode == 200 {
                // parse playlists
                guard let playlistBody = resp.body["playlists"] as? [[String: String]] else {
                    return callback(GetMyPlaylistsReturn(error: true, message: "Error getting your playlists"))
                }
                
                // create array of playlists
                var playlists: [PlaylistReturnModel] = []
                
                // loop through playlists
                for play in playlistBody {
                    let temp =  PlaylistReturnModel(
                                    creator: username,
                                    playlist_id: play["playlist_id"]!,
                                    type: play["type"]!,
                                    status: play["status"]!
                                )
                    
                    // add playlist
                    playlists.append(temp)
                }
                
                // return callback
                return callback(GetMyPlaylistsReturn(playlists: playlists))
                
            }else{
                // error
                return callback(GetMyPlaylistsReturn(error: true, message: resp.body["message"] as! String))
            }
        })
    }
}
