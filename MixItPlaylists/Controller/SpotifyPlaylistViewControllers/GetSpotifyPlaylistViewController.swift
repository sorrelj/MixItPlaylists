//
//  GetSpotifyPlaylistViewController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 12/19/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

import CryptoKit

// MARK: Spotify Playlist Response
struct SpotifyPlaylistResponse {
    // playlist data
    var playlistData: SpotifyPlaylistModel?
    
    // error
    var error: Bool
    // error message
    var errorMessage: String
    
    init(playlistName: String, playlistDescription: String, playlistID: String, playlistImage: UIImage){
        self.playlistData = SpotifyPlaylistModel(id: playlistID, image: playlistImage, name: playlistName, description: playlistDescription)
        
        self.error = false
        self.errorMessage = ""
    }
    
    init (errorMessage: String){
        self.error = true
        self.errorMessage = errorMessage
        
        self.playlistData = nil
    }
    
}


// MARK: Get Spotify Playlist View Controller

final class GetSpotifyPlaylistViewController: ObservableObject {
    
    // get a spotify playlist
    func getSingleSpotifyPlaylist(playlistID: String, callback: @escaping (SpotifyPlaylistResponse)->() ){
        
        guard playlistID != "" else {
            return
        }
        
        // set endpoint
        let endpoint = "playlists/" + playlistID
        
        // set request
        let req = SpotifyAPIRequest(requestType: .GET, rawName: endpoint, params: ["fields": "id,name,description,images"], expectedResponse: .nothing)
        
        
        // perform request
        SpotifyWebAPIController().spotifyWebAPIRequest(req: req, callback: { resp in
            if (resp.error) {
                // handle error
                print(resp.error, resp.errorData)
                return callback(SpotifyPlaylistResponse(errorMessage: "error data"))
            }else{
                // get name
                guard let name = resp.dataObject["name"] as? String else{
                    return callback(SpotifyPlaylistResponse(errorMessage: "Error parsing Playlist data."))
                }
                
                // description
                guard let description = resp.dataObject["description"] as? String else {
                    return callback(SpotifyPlaylistResponse(errorMessage: "Error parsing Playlist data."))
                }
                
                // image array
                guard let imageArray = resp.dataObject["images"] as? [Any] else {
                    return callback(SpotifyPlaylistResponse(errorMessage: "Error parsing Playlist data."))
                }
                
                // image
                var image: UIImage = UIImage()
                if imageArray.count > 0 {
                    // get biggest image
                    guard let tempImg = imageArray[imageArray.count-1] as? [String: Any] else{
                        return callback(SpotifyPlaylistResponse(errorMessage: "Error parsing Playlist data."))
                    }
                    
                    // get the url
                    guard let imgURL = tempImg["url"] as? String else {
                        return callback(SpotifyPlaylistResponse(errorMessage: "Error parsing Playlist data."))
                    }
                    
                    // parse to UIImage
                    let imgData = NSData(contentsOf: URL(string: imgURL)!)
                    image = UIImage(data: imgData! as Data)!
                }
                
                // return callback
                return callback(SpotifyPlaylistResponse(playlistName: name, playlistDescription: description, playlistID: playlistID, playlistImage: image))
                
            }
            
        })
    }
    
    
}

