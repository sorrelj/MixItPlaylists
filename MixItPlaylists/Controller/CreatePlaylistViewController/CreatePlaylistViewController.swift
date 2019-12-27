//
//  CreatePlaylistViewController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 12/9/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

import CryptoKit

// MARK: Create Playlist Response Struct

// Struct to send /createplaylist response to the view
struct CreatePlaylistResponse: Decodable {

    // track when the user has been created
    var success: Bool

    // error message if error
    var message: String

    // init the struct
    init (success: Bool, message: String) {
        self.success = success
        self.message = message
    }


}

// MARK: Create Playlist View Controller

final class CreatePlaylistViewController: ObservableObject {

    // login user function
    func createPlaylist(name: String, description: String, type: String, image: UIImage?, callback: @escaping (CreatePlaylistResponse)->() ) {
        
        let spotifyController = SpotifyWebAPIController()
                
        
        
        /* --------------------
                GET ME
         */
        // get spotify userid call
        let getMeReq = SpotifyAPIRequest(requestType: .GET, name: .getMe, params: [:], expectedResponse: .nothing)
        
        // perform api network call
        spotifyController.spotifyWebAPIRequest(req: getMeReq, callback: { resp in
            // error
            if (resp.error) {
                print(resp.errorData)
                return callback(CreatePlaylistResponse(success: false, message: "error"))
            }
            
            // get the id
            guard let spotifyUserId = resp.dataObject["id"] as? String else {
                print("Create Playlist: user id error")
                return callback(CreatePlaylistResponse(success: false, message: "error"))
            }
                        
            // set the endpoint
            let end = "users/"+spotifyUserId+"/playlists"
            
            
            
            
            
            
            
            /* ---------------------------
                   Craete Playlist
            */
            
            // create playlist call
            let createPlaylistReq = SpotifyAPIRequest(requestType: .POST, rawName: end, params: [
                "name": name, "description": description, "public": "true"], expectedResponse: .nothing)
            
            // perform create playlist call
            spotifyController.spotifyWebAPIRequest(req: createPlaylistReq, callback: { resp in
                // error
                if (resp.error) {
                    print(resp.errorData)
                    return callback(CreatePlaylistResponse(success: false, message: "error"))
                }
                
                // get the id
                guard let spotifyPlaylistId = resp.dataObject["id"] as? String else {
                    print("Create Playlist: playlist id")
                    return callback(CreatePlaylistResponse(success: false, message: "error"))
                }

                
                
                
                
                /* ------------------------------
                       Create(MIX IT PLAYLISTS)
                */
                // create playlist
                self.createMixItPlaylist(playlistID: spotifyPlaylistId, type: type, callback: { success in
                    //error
                    if !success {
                        print("Create Playlist: create error")
                        return callback(CreatePlaylistResponse(success: false, message: "error"))
                    }else{
                        
                        /* ---------------
                               IMAGE
                        */
                        // check for image
                        if image != UIImage() {
                            let endU = "playlists/"+spotifyPlaylistId+"/images"
                            
                            // base64 encode image
                            let imageData = image?.jpegData(compressionQuality: 0.1)?.base64EncodedString()
                            
                            // check if image data is too large
                            if imageData!.count > 256000 {
                                print(imageData!.count)
                                
                                let errMsg = "Playlist was created but the image you provided was too large for a Spotify playlist (>256KB). You can upload another image or cropped image of the original from the playlist page."
                                
                                return callback(CreatePlaylistResponse(success: true, message: errMsg))
                            }else{
                                // upload image
                                let uploadImage = SpotifyAPIRequest(requestType: .PUT, rawName: endU, customParams: [imageData!], expectedResponse: .nothing, imgHeader: true)
                                
                                // perform create playlist call
                                spotifyController.spotifyWebAPIRequest(req: uploadImage, callback: { resp in
                                    // error
                                    if (resp.error) {
                                        print(resp.errorData)
                                        return callback(CreatePlaylistResponse(success: false, message: resp.errorData["message"] as! String))
                                    }else{
                                        return callback(CreatePlaylistResponse(success: true, message: "Your playlist was created and added to your Spotify account."))
                                    }
                                })
                            }

                        /* --------------------
                                NO IMAGE
                        */
                        } else {
                            return callback(CreatePlaylistResponse(success: true, message: ""))
                        }
                        
                    }
                    
                })
                
            })
            
        })
    }
    
    private func createMixItPlaylist(playlistID: String, type: String, callback: @escaping (Bool)->() ) {
 
        // set the request
        let create = APIRequest(requestType: .POST, name: .createPlaylist, params: ["playlist_id": playlistID, "type": type], withToken: true)
        
        DispatchQueue.main.async {
            // perform api network call
            APINetworkController().apiNetworkRequest(req: create, callback: { resp in
                print(resp)
                
                // No errors user is authorized
                if (resp.statusCode == 200){
                    return callback(true)
                // Error
                }else{
                    return callback(false)
                }
            })
        }
        
        
    }

}

