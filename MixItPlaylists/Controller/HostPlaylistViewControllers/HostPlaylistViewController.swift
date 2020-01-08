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



// MARK: Host Playlist View Controller

final class HostPlaylistViewController: ObservableObject {
    
    
    /// MARK: Published Controller vars
    
    // current song
    @Published var currentSong: SpotifySongModel = SpotifySongModel()
   
    // play or paused status
    @Published var playbackStatus: String = SpotifyConstants.PAUSE_ICON
    
    // Playlist info State vars
    @Published var spotifyPlaylistData: SpotifyPlaylistModel = SpotifyPlaylistModel()
    
    // Song progress pcnt
    @Published var songProgressPercent: CGFloat = 0
    
    // Song progress String
    @Published var songProgressString: String = "0:00"
    
    
    /// MARK: Controller vars

    // Spotify Song List View Controller
    @ObservedObject var spotifySongListViewController = SpotifySongListViewController()

    
    /// MARK: Private vars
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
    
    // connect app remote
    func connectAppRemote(playlistID: String) {
        // connect app remote
        //appRemote.connect()
        
        // authorize and play
        self.appRemote.authorizeAndPlayURI(SpotifyConstants.PLAYLIST+playlistID)
        
        // add notification for player state change
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "playerStateChange"), object: nil, queue: nil, using: self.onPlayerStateChange)
    }

    
    // play a song
    func playPlaylist(playlistID: String){
        // set current song
        self.setCurrentSong(song: self.spotifySongListViewController.getAndRemoveFirst())
        
        // set shuffle to false
        self.appRemote.playerAPI?.setShuffle(false, callback: nil)
        
        // set mode to repeat playlist
        self.appRemote.playerAPI?.setRepeatMode(.context, callback: nil)
        
        // play playlist
        self.appRemote.playerAPI?.play(SpotifyConstants.PLAYLIST+playlistID, callback: nil)
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
    private func setCurrentSong(song: SpotifySongModel){
        // set the song data
        self.currentSong = song
        
        // reset timer vars
        self.songProgressPercent = 0
        self.songProgressString = "0:00"
    }
    
    // player state change notification
    private func onPlayerStateChange(_ notification: Notification) {
        // get player state
        guard let playerState = notification.userInfo?["playerState"] as? SPTAppRemotePlayerState else {
            print("GET PLAYER STATE ERROR")
            return
        }
        
        // ignore non existant song
        guard playerState.track.uri != SpotifyConstants.TRACK else {
            return
        }
        
        // ignore no song change
        guard playerState.track.uri != (SpotifyConstants.TRACK + self.currentSong.id) else {
            return
        }
        
        // store old current song
        let tempSong = self.currentSong
        
        // change current song
        self.setCurrentSong(song: self.spotifySongListViewController.getAndRemoveFirst())
        
        // add old song back in
        // if not empy song
        self.spotifySongListViewController.addSongToEnd(song: tempSong)
        
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
