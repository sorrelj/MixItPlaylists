//
//  GetOpenPlaylistsController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 2/11/20.
//  Copyright © 2020 MixIt. All rights reserved.
//

import Foundation


struct GetOpenPlaylistsReturn {
    
    // friends playlist models
    var friendsPlaylists: [PlaylistReturnModel]
    
    // public playlist models
    var publicPlaylists: [PlaylistReturnModel]
    
    // error
    var error: Bool
    
    // error message
    var message: String
    
    // init no error
    init(friendsPlaylists: [PlaylistReturnModel], publicPlaylists: [PlaylistReturnModel]){
        self.friendsPlaylists = friendsPlaylists
        self.publicPlaylists = publicPlaylists
        self.error = false
        self.message = ""
    }
    
    // init with error
    init(error: Bool, message: String){
        self.friendsPlaylists = []
        self.publicPlaylists = []
        self.error = error
        self.message = message
    }
    
}

class GetOpenPlaylistsController {
    
    func getPlaylists(callback: @escaping (GetOpenPlaylistsReturn)->()) {
        // set request
        let req = APIRequest(requestType: .GET, name: .getOpenPlaylists, params: [:], withToken: true)
                
        // get scene
        let scene = UIApplication.shared.connectedScenes.first
        guard let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) else {
            print("Get scene error")
            return
        }
        
        // perform request
        APINetworkController().apiNetworkRequest(req: req, callback: { resp in
            print("GET OPEN PLAYLISTS", resp)
            
            // 200
            if resp.statusCode == 200 {
                // parse friends playlists
                guard let friendsPlaylistsRaw = resp.body["friends"] as? [[Any]] else {
                    return callback(GetOpenPlaylistsReturn(error: true, message: "Error getting friends playlists"))
                }
                
                // create friends array
                var friendsPlaylists: [PlaylistReturnModel] = []
                
                // loop through each playlist
                for friend in friendsPlaylistsRaw {
                    if let friendPlays = friend as? [[String: String]] {
                        for playlists in friendPlays {
                            // get each playlist
                            friendsPlaylists.append(PlaylistReturnModel(
                                    creator: playlists["username"]!,
                                    playlist_id: playlists["playlist_id"]!,
                                    type: playlists["type"]!,
                                    status: "open",
                                    token: playlists["token"]!
                            ))
                        }
                    }
                }
                
                
                // parse public playlists
                
                
                
                
                // return callback
                return callback(GetOpenPlaylistsReturn(friendsPlaylists: friendsPlaylists, publicPlaylists: []))
                
            }else{
                // error
                return callback(GetOpenPlaylistsReturn(error: true, message: "An unknown error occurreds"))
            }
        })
    }
}

