//
//  HostPlaylistViewController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 12/18/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

import CryptoKit


/*
    To make sure a playlist is open

    While a song is playing
        app sends the current time every 30
    
    Backend function
        runs every 2.5 minutes
 
        loop all playlists
            if open and time > 1 minute ago
                set to closed
*/


// MARK: Host Playlist View Controller

final class HostPlaylistViewController: ObservableObject {
    
    
    /// MARK: Published Controller vars
    
   
    // play or paused status
    @Published var playbackStatus: String = SpotifyConstants.PAUSE_ICON
    
    // Playlist info State vars
    @Published var spotifyPlaylistData: SpotifyPlaylistModel = SpotifyPlaylistModel()
    
    // Song progress pcnt
    @Published var songProgressPercent: CGFloat = 0
    
    // Song progress String
    @Published var songProgressString: String = "0:00"
    
    
    /// MARK: Controller vars
    
    // Get Spotify Songs View Controller
    @ObservedObject var getSpotifySongsViewController = GetSpotifySongsViewController()

    
    /// MARK: Private vars
    // playlist ID
    private var playlistID: String = ""
    
    // prev song
    private var prevSong: String = SpotifyConstants.TRACK
    
    // progress timer
    private var progressTimer: Timer? = nil
    
    
    
    // session manager
    private var sessionManager: SPTSessionManager {
        let scene = UIApplication.shared.connectedScenes.first
        let sd : SceneDelegate = ((scene?.delegate as? SceneDelegate)!)
        return sd.sessionManager
    }
    
    // app remotes
    private var appRemote: SPTAppRemote {
        let scene = UIApplication.shared.connectedScenes.first
        let sd : SceneDelegate = ((scene?.delegate as? SceneDelegate)!)
        return sd.appRemote
    }
    
    
    /// MARK: Functions
    
    // is spotify app installed
    func isSpotifyAppInstalled() -> Bool {
        return sessionManager.isSpotifyAppInstalled
    }
    
    // set playlist to open on start
    func setPlaylistOpen(playlistID: String) {
        // set playlist id
        self.playlistID = playlistID
        
        // set open on start (first run)
        // set request
        let req = APIRequest(requestType: .POST, name: .setPlaylistOpen, params: ["playlist_id": self.playlistID, "isFirst": "true"], withToken: true)
        
        APINetworkController().apiNetworkRequest(req: req, callback: {resp in
            if (resp.statusCode != 200){
                print("\n\n~ SET PLAYLIST OPEN ERROR ~\n\n")
                print(resp)
                print("\n\n")
                return
            }
        })
        
        // set timer
        var openTimer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.setOpen), userInfo: nil, repeats: true)
    }
    
    // send set playlist open
    @objc private func setOpen() {
        // set request
        let req = APIRequest(requestType: .POST, name: .setPlaylistOpen, params: ["playlist_id": self.playlistID], withToken: true)
        
        APINetworkController().apiNetworkRequest(req: req, callback: {resp in
            if (resp.statusCode != 200){
                print("\n\n~ SET PLAYLIST OPEN ERROR ~\n\n")
                print(resp)
                print("\n\n")
                return
            }
        })
    }
    
    // connect app remote
    func connectAppRemote() {
        // wake up spotify app
        self.appRemote.authorizeAndPlayURI(SpotifyConstants.TRACK)
        
        // add app remote connected notification
        // add notifation reciever
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "appRemoteConnected"), object: nil, queue: nil, using: self.onAppRemoteConnected)
    }

    
    // when the app remote is connected
    func onAppRemoteConnected(_ notification: Notification){
        // set current song
        //self.setCurrentSong()
        
        // set shuffle to false
        self.appRemote.playerAPI?.setShuffle(false, callback: nil)
        
        // set mode to repeat playlist
        self.appRemote.playerAPI?.setRepeatMode(.context, callback: nil)
        
        // play playlist
        self.appRemote.playerAPI?.play(SpotifyConstants.PLAYLIST+self.playlistID, callback: nil)
        
        // add notification for player state change
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "playerStateChange"), object: nil, queue: nil, using: self.onPlayerStateChange)
    }
    
    // start progress timer
    func startProgressTimer() {
        // get player state to start timer at
        self.appRemote.playerAPI?.getPlayerState({ (result, error) in
            if error != nil {
                // error do something
                print("SPOTIFY START PROGRESS ERROR")
            }else{
                // player state
                let playerState = result as! SPTAppRemotePlayerState
                
                // set initial values
                
                // progress percent
                self.songProgressPercent = CGFloat(Float(playerState.playbackPosition)/Float(playerState.track.duration))
                
                // progress string
                self.songProgressString = self.msToString(ms: Float(playerState.playbackPosition))
                
                // start timer
                self.progressTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
            }
        })
    }
    
    // stop the timer
    func stopProgressTimer() {
        if self.progressTimer != nil {
            self.progressTimer?.invalidate()
        }
    }
    
    // play / pause track
    func changePlaybackStatus() {
        self.appRemote.playerAPI?.getPlayerState({ (result, error) in
            if error != nil {
                // error do something
                print("SPOTIFY PLAYBACK STATUS ERROR")
            }else{
                // get playerstate
                let playerState = result as! SPTAppRemotePlayerState
                
                // paused
                if playerState.isPaused {
                    // play song
                    self.resumePlayTrack()
                    
                    // show pause button
                    self.playbackStatus = SpotifyConstants.PAUSE_ICON
                }else{
                    // pause song
                    self.pauseTrack()
                    
                    // show play button
                    self.playbackStatus = SpotifyConstants.PLAY_ICON
                }
            }
        })
    }
    
    // next song
    func nextSongAction() {
        self.appRemote.playerAPI?.skip(toNext: nil)
    }
    
    
    
    /// MARK: Private Helper Functions
    // set the current song
    private func setCurrentSong(){
        // set the song data
        self.getSpotifySongsViewController.setCurrentSongNext()
        
        // reset timer vars
        self.songProgressPercent = 0
        self.songProgressString = "0:00"
    }
    
    // player state change notification
    private func onPlayerStateChange(_ notification: Notification) {
        print("DEBUG", "- Player State Change -")
        
        // get player state
        guard let playerState = notification.userInfo?["playerState"] as? SPTAppRemotePlayerState else {
            //print("GET PLAYER STATE ERROR")
            return
        }
        
        // ignore non existant song
        guard playerState.track.uri != SpotifyConstants.TRACK else {
            return
        }
        
        // ignore no song change - compare to prev song
        guard playerState.track.uri != self.prevSong else {
            print("DEBUG", "    NO SONG CHANGE")
            return
        }
        
        // set prev song
        self.prevSong = playerState.track.uri
        
        // check for unexpected song - should be skipped
        guard playerState.track.uri == (SpotifyConstants.TRACK + self.getSpotifySongsViewController.getNextSong().id) else {
            print("DEBUG", "    ~> NEXT SONG <~", playerState.track.uri, SpotifyConstants.TRACK + self.getSpotifySongsViewController.getNextSong().id)
            self.nextSongAction()
            return
        }
        
        // change current song
        self.setCurrentSong()
        print("DEBUG", "    + SET SONG NEXT +")
        
    }
    
    // resume play track
    private func resumePlayTrack() {
        self.appRemote.playerAPI?.resume({ (result,error) in
            if error != nil{
                print("SPOTIFY CONTINUE PLAYING ERROR")
            }
        })
    }
    
    // pause track
    private func pauseTrack() {
        self.appRemote.playerAPI?.pause({ (result,error) in
            if error != nil{
                print("SPOTIFY CONTINUE PLAYING ERROR")
            }
        })
    }
    
    // update progress
    @objc private func updateProgress(){
        // get player state
        self.appRemote.playerAPI?.getPlayerState({ (result, error) in
            if error != nil {
                // error do something
                print("SPOTIFY UPDATE PROGRESS ERROR")
            }else{
                // player state
                let playerState = result as! SPTAppRemotePlayerState
                
                // set values

                // progress percent
                self.songProgressPercent = CGFloat(Float(playerState.playbackPosition)/Float(playerState.track.duration))
                
                // progress string
                self.songProgressString = self.msToString(ms: Float(playerState.playbackPosition))
            }
        }
        
        )
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
