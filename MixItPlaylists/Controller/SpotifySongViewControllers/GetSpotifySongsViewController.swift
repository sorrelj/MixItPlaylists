//
//  GetSpotifySongsViewController.swift
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
struct SpotifySongsResponse {
    // playlist data
    var songs: [SpotifySongModel]?
    
    // error
    var error: Bool
    // error message
    var errorMessage: String
    
    init(songs: [SpotifySongModel]){
        self.songs = songs
        
        self.error = false
        self.errorMessage = ""
    }
    
    init (errorMessage: String){
        self.error = true
        self.errorMessage = errorMessage
        
        self.songs = nil
    }
    
}


// MARK: Get Spotify Playlist View Controller

final class GetSpotifySongsViewController: ObservableObject {
    
    // Dispatch Queues
    var trackData_DispatchQueue = DispatchQueue(label: "trackData-queue")
    
    // get a spotify playlist's songs
    func getSpotifyPlaylistSongs(playlistID: String, callback: @escaping (SpotifySongsResponse)->() ){
        
        guard playlistID != "" else {
            return
        }
        
        // set endpoint
        let endpoint = "playlists/" + playlistID + "/tracks"
        
        // set request
        let req = SpotifyAPIRequest(requestType: .GET, rawName: endpoint, params: ["fields": "items(track(id,name,duration_ms,artists,album(id,name,images))),next", "limit": "100"], expectedResponse: .nothing)
        
        
        // perform request
        SpotifyWebAPIController().spotifyWebAPIRequest(req: req, callback: { resp in
            if (resp.error) {
                // handle error
                print(resp.error, resp.errorData)
                return callback(SpotifySongsResponse(errorMessage: "error data"))
            }else{
                // parse songs
                guard let songs = resp.dataObject["items"] as? [[String: Any]] else{
                    return callback(SpotifySongsResponse(errorMessage: "error data"))
                }
                
                // check for more songs
                
                // get next
                if let next = resp.dataObject["next"] as? String {
                    // more songs to add
                    DispatchQueue.main.async {
                        self.continueAddingSongs(url: next, songList: songs, callback: { finalSongList in
                            self.parseAllItems(songs: finalSongList, callback: { resp in
                                return callback(SpotifySongsResponse(songs: resp))
                            })
                        })
                    }
                }else{
                    // no more songs to add
                    self.parseAllItems(songs: songs, callback: { resp in
                        if (resp.count > 0){
                            return callback(SpotifySongsResponse(songs: resp))
                        }else{
                            return callback(SpotifySongsResponse(errorMessage: "error data"))
                        }
                    })
                }
            }
            
        })
    }
    
    
    // continue adding songs
    private func continueAddingSongs(url: String, songList: [[String: Any]], callback: @escaping ([[String: Any]])->()){
        // set request
        let req = SpotifyAPIRequest(requestType: .GET, rawName: url, params: [:], expectedResponse: .nothing)
            
        // send request
        SpotifyWebAPIController().spotifyWebAPIRequest(req: req, callback: { resp in
            if (resp.error) {
                // handle error
                print(resp.error, resp.errorData)
                return //ERROR
            }else{
                // parse songs
                guard let songs = resp.dataObject["items"] as? [[String: Any]] else{
                    return //ERROR
                }
                
                // append songs to list
                let newSongList = songList + songs
                                
                // check for more songs
                
                // get next
                if let next = resp.dataObject["next"] as? String {
                    // more songs to add
                    DispatchQueue.main.async {
                        self.continueAddingSongs(url: next, songList: newSongList, callback: callback)
                    }
                }else{
                    // no more songs to add
                    // callback from recursive function
                    return callback(newSongList)
                }
            }
        })
        
    }

    
    // parse all songs
    private func parseAllItems(songs: [[String: Any]], callback: @escaping ([SpotifySongModel])-> ()){
            // dispatch group
            let itemDisp = DispatchGroup()
        
            // array to return
            var spotifySongs = [SpotifySongModel]()
        
            // parse the data
            for trackData in songs {
                itemDisp.enter()
                
                guard let track = trackData["track"] as? [String: Any] else{
                    print("error - json")
                    itemDisp.leave()
                    return
                }
                                
                self.parseSingleItem(itemX: track, callback: { sSong in
                    // add item
                    spotifySongs.append(sSong)
                    
                    itemDisp.leave()
                })
            }
            
            // done getting all songs
            itemDisp.notify(queue: .main, execute: {
                return callback(spotifySongs)
            })
        
    }
    
    // parse a single song
    private func parseSingleItem(itemX: [String: Any], callback: @escaping (SpotifySongModel)->()){
        self.trackData_DispatchQueue.async {
            
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

