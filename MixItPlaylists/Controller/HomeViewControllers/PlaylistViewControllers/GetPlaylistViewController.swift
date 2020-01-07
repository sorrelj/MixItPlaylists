//
//  GetPlaylistViewController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 12/31/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation


// playlist list types
enum GetPlaylistType: String {
    case
        MY_PLAYLISTS,
        FRIENDS_PLAYLISTS,
        NEARBY_PLAYLISTS
}

// playlists return model
struct PlaylistReturnModel {
    // creator
    var creator: String
    
    // playlist id
    var playlist_id: String
    
    // type
    var type: String
    
    // status
    var status: String
    
    init(creator: String, playlist_id: String, type: String, status: String){
        self.creator = creator
        self.playlist_id = playlist_id
        self.type = type
        self.status = status
    }
}

final class GetPlaylistViewController: ObservableObject {
    
    @Published var playlists: [MixItPlaylistModel] = []
    
    // Dispatch Queue
    //var playlist_DispatchQueue: DispatchQueue

    
    /// MARK: init playlist types
    init(type: GetPlaylistType){
        if type == .MY_PLAYLISTS {
            // my playlists
            self.getMyPlaylists()
        }else if type == .FRIENDS_PLAYLISTS {
            // friends playlists
        }else if type == .NEARBY_PLAYLISTS {
            // nearby playlists
        }
    }
    
    func getMyPlaylists() {
        let getMyPlaylists = GetMyPlaylistsController()
        
        // get playlists
        getMyPlaylists.getPlaylists(callback: { playlistReturns in
            if (playlistReturns.error){
                // handle error
                print("ERROR - get my playlists", playlistReturns.message)
            }else{
                // parse playlists
                DispatchQueue.main.async {
                    self.parsePlaylists(playlists: playlistReturns.playlists)
                }
            }
        })
    }
    
    
    
    // parse playlists
    private func parsePlaylists(playlists: [PlaylistReturnModel]) {
        // spotify controller
        let spotifyController = SpotifyWebAPIController()
        
        // get spotify data for each playlist
        for playlist in playlists {
            let req = SpotifyAPIRequest(requestType: .GET, rawName: ("playlists/"+playlist.playlist_id), params: ["fields": "name,images,description"], expectedResponse: .nothing)
            
            // perform request
            spotifyController.spotifyWebAPIRequest(req: req, callback: { resp in
                if resp.error {
                    // handle error
                    print(resp.error, resp.errorData)
                }else{
                    self.parseSinglePlaylist(playlist: playlist, playlistSpotifyData: resp.dataObject)
                }
            })
        }
    }
    
    // parse single playlist
    private func parseSinglePlaylist(playlist: PlaylistReturnModel, playlistSpotifyData: [String: Any]){
        // get playlist name
        guard let name = playlistSpotifyData["name"] as? String else {
            print("ERROR: parse single playlist - name")
            return
        }
        
        // get playlist description
        guard let description = playlistSpotifyData["description"] as? String else {
            print("ERROR: parse single playlist - description")
            return
        }
        
        // get image array
        guard let images = playlistSpotifyData["images"] as? [Any] else {
            print("ERROR: parse single playlist - images")
            return
        }
        
        // get first image
        guard let firstImage = images[0] as? [String: Any] else {
            print("ERROR: parse single playlist - first image")
            return
        }
        
        // get url
        guard let imageURL = firstImage["url"] as? String else {
            print("ERROR: parse single playlist - imageURL")
            return
        }

        // get image data
        let imgData = NSData(contentsOf: URL(string: imageURL)!)
        
        // get image
        let uiImage = UIImage(data: imgData! as Data)
        
        // set final data
        let spotifyData = SpotifyPlaylistModel(id: playlist.playlist_id, image: uiImage!, name: name, description: description)
        
        let finalPlaylistData = MixItPlaylistModel(id: playlist.playlist_id, playlistCreator: playlist.creator, type: playlist.type, status: playlist.status, spotifyData: spotifyData)
        
        // add to view
        DispatchQueue.main.async {
            self.playlists.append(finalPlaylistData)
        }
    }
}
