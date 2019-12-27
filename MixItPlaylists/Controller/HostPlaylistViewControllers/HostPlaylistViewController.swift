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
    
    /// MARK: Controller vars

    // Spotify Song List View Controller
    @ObservedObject var spotifySongListViewController = SpotifySongListViewController()
    
    
    
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
    func connectAppRemote() {
        // connect app remote
        appRemote.connect()
        
        // add notification for player state change
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "playerStateChange"), object: nil, queue: nil, using: self.onPlayerStateChange)
    }

    // play a song
    func playPlaylist(playlistID: String){
        // play playlist
        self.appRemote.playerAPI?.play(SpotifyConstants.PLAYLIST+playlistID, callback: nil)
        
        // set shuffle to false
        self.appRemote.playerAPI?.setShuffle(false, callback: nil)
        
        // set mode to repeat playlist
        self.appRemote.playerAPI?.setRepeatMode(.context, callback: nil)
        
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
    
    
    /// MARK: Private Helper Functions
    // set the current song
    private func setCurrentSong(song: SpotifySongModel){
        self.currentSong = song
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
        self.currentSong = self.spotifySongListViewController.getAndRemoveFirst()
        
        // add old song back in
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
    
}
