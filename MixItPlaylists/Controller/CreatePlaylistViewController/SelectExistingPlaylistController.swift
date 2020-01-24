//
//  SelectExistingPlaylistController.swift
//  MixItPlaylists
//
//  Created by Carson Grin on 1/23/20.
//  Copyright © 2020 MixIt. All rights reserved.
//

import Foundation
import Combine
import SwiftUI


final class SelectExistingPlaylistController: ObservableObject {
    
    @Published var playlists: [SpotifyPlaylistModel] = []
    
    init() {
        getExisting()
    }
    
    // parse single playlist
    private func parseSinglePlaylist(playlistSpotifyData: [String: Any]){
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
        
        // get id
         guard let id = playlistSpotifyData["id"] as? String else {
                   print("ERROR: parse single playlist - id")
                   return
        }

        // get image data
        let imgData = NSData(contentsOf: URL(string: imageURL)!)
        
        // get image
        let uiImage = UIImage(data: imgData! as Data)
        
        let spotPlaylists = SpotifyPlaylistModel(id: id, image: uiImage!, name: name, description: description)
        // add to view
        DispatchQueue.main.async {
            self.playlists.append(spotPlaylists)
        }
    }
    
    func getExisting() {
        
        // set request
        let req = SpotifyAPIRequest(requestType: .GET, name: .getMyExisting, params: [:], expectedResponse: .nothing)
        
        // perform request
        SpotifyWebAPIController().spotifyWebAPIRequest(req: req, callback: { resp in
            if (resp.error) {
                // handle error
                print(resp.error, resp.errorData)

            }else{
                print(resp.dataObject)
                
                guard let items = resp.dataObject["items"] as? [[String: Any]] else{
                    print("parse error")
                    return
                }
                
                for item in items {
                    self.parseSinglePlaylist(playlistSpotifyData: item)
                }
       
            }
        
        })
    }
}
