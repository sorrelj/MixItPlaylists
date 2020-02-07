//
//  SpotifySongSearchViewController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 1/10/20.
//  Copyright © 2020 MixIt. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

import CryptoKit


// MARK: Spotify Search Response
struct SpotifySongSearchResponse{
    // error
    var error: Bool
    
    // error message
    var message: String
    
    init(error: Bool, message: String){
        self.error = error
        self.message = message
    }
}


// MARK: Get Spotify Playlist View Controller

final class SpotifySongSearchViewController: ObservableObject {
    
    // searched list
    @Published var searchedSongList: [SpotifySongModel] = []

    /// MARK: Functions
    func searchSong(search: String, callback: @escaping (SpotifySongSearchResponse)->()){        
        // reset search list
        self.searchedSongList.removeAll()
        
        // set request
        let req = SpotifyAPIRequest(requestType: .GET, name: .search, params: ["q": search, "type": "track", "limit": "25"], expectedResponse: .nothing)
        
        // send search request
        SpotifyWebAPIController().spotifyWebAPIRequest(req: req, callback: { resp in
            if resp.error{
                return callback(SpotifySongSearchResponse(error: true, message: "An Unknown Error Occured."))
            }
            
            // parse results
            
            // get tracks
            guard let tracks = resp.dataObject["tracks"] as? [String: Any] else{
                print("SPOTIFY SEARCH - get tracks error")
                return callback(SpotifySongSearchResponse(error: true, message: "An Unknown Error Occured."))
            }
            
            // get items
            guard let items = tracks["items"] as? [[String:Any]] else {
                print("SPOTIFY SEARCH - get items error")
                return callback(SpotifySongSearchResponse(error: true, message: "An Unknown Error Occured."))
            }
            
            // parse all results
            self.parseAllItems(songs: items)
            
            // send callback with no error
            return callback(SpotifySongSearchResponse(error: false, message: ""))
            
        })
    }
    
    // parse all songs
    private func parseAllItems(songs: [[String: Any]]){
        // parse the data
        for trackData in songs {
            self.parseSingleItem(itemX: trackData, callback: { sSong in
                // add item
                DispatchQueue.main.async {
                    self.searchedSongList.append(sSong)
                }
            })
        }
    }
    
    // parse a single song
    private func parseSingleItem(itemX: [String: Any], callback: @escaping (SpotifySongModel)->()){
        // Song data
                
        // id
        guard let songID = itemX["id"] as? String else{
            print("error - song id")
            return
        }
                
        // name
        guard let songName = itemX["name"] as? String else{
            print("error - song name")
            return
        }
        
        // length ms
        guard let lengthMS = itemX["duration_ms"] as? Float else {
            print("error - song length")
            return
        }
        
        // length string
        let strLength = self.msToString(ms: lengthMS)
        
        // Artist
        
        // artist object
        guard let artists = itemX["artists"] as? [Any] else{
            print("error - artists object")
            return
        }
        
        // firts artist
        guard let artistOne = artists[0] as? [String: Any] else{
            print("error - artist one")
            return
        }
        
        // id
        guard let artistID = artistOne["id"] as? String else{
            print("error - artist id")
            return
        }
        
        // name
        guard let artistName = artistOne["name"] as? String else{
            print("error - artist name")
            return
        }
        

        
        // Album
        
        // album object
        guard let album = itemX["album"] as? [String: Any] else{
            print("error - album object")
            return
        }
        
        // id
        guard let albumID = album["id"] as? String else{
            print("error - album id")
            return
        }
        
        // name
        guard let albumName = album["name"] as? String else{
            print("error - album name")
            return
        }
        
        // get image array
        guard let imgArray = album["images"] as? [Any] else {
            print("error - image 1")
            return
        }
        
        // get small img
        guard let smallImg = imgArray[0] as? [String: Any] else {
            print("error - image 2")
            return
        }
        
        // get small image object
        guard let imgURL = smallImg["url"] as? String else {
            print("error - image 3")
            return
        }
        
        let imgData = NSData(contentsOf: URL(string: imgURL)!)
        let uiImage = UIImage(data: imgData! as Data)!
        
        return callback(SpotifySongModel(id: songID, name: songName, lengthMS: lengthMS, stringLength: strLength, artistID: artistID, artistName: artistName, albumID: albumID, albumName: albumName, albumImage: uiImage))
    }
    
    // milliseconds to string
    private func msToString(ms: Float) -> String {
        // get minutes
        let min = Int(floor(ms/60000))
        
        // remove minute
        let temp = Float(Int(ms) % 60000)
        
        // get seconds
        let sec = Int(floor(temp/1000))
        
        // convert seconds to string
        var secondStr = sec.description
        if sec < 10 {
            secondStr = "0" + secondStr
        }
        
        return (min.description + ":" + secondStr)
    }
    
    
}

