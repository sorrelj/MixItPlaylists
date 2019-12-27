//
//  HostPlaylistRootView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 12/18/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI
struct HostPlaylistRootView: View {
        
     /// MARK: Binding vars
    // playlist id
    @Binding var playlistID: String
    
    
    /// MARK: State vars
    
    /*
       Controllers
    */
    // Get Spotify Playlist View Controller
    @ObservedObject var getSpotifyPlaylistViewController = GetSpotifyPlaylistViewController()
    
    // Get Spotify Songs View Controller
    @ObservedObject var getSpotifySongsViewController = GetSpotifySongsViewController()
    
    
    /*
        Host Playlist  view
     */
    // Host playlist main view controller
    @ObservedObject var hostMainViewController = HostPlaylistViewController()
    
    // activity indicator
    @State private var showActivityIndicator = false
    
    // Playlist info State vars
    @State var spotifyPlaylistData: SpotifyPlaylistModel = SpotifyPlaylistModel()
    
    
    
    
    /// MARK: Private variables
    
    /*
       Host Playlist  view
    */
   
    
    /// MARK: Private functions
    
    // on startup
    private func onViewStartup() {
        // connect app remote if spotify app installed
        
        if self.hostMainViewController.isSpotifyAppInstalled() {
            // add notifation reciever
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "appRemoteConnected"), object: nil, queue: nil, using: self.onAppRemoteConnected)
        
            // connect app remote
            self.hostMainViewController.connectAppRemote()
        }else{
            // Display error
            // must have spotify app
            print("NO SPOTIFY APP")
        }
    }
    
    // when the app remote is connected
    private func onAppRemoteConnected(_ notification: Notification){
        
        // get the playlist details
        self.getSpotifyPlaylistViewController.getSingleSpotifyPlaylist(playlistID: self.playlistID, callback: { resp in
                        
            // check for error
            if resp.error {
                print(resp.errorMessage)
                //display error
            }else{
                // set playlist data
                self.spotifyPlaylistData = resp.playlistData!
            }
        })
        
        // get playlist tracks
        self.getSpotifySongsViewController.getSpotifyPlaylistSongs(playlistID: self.playlistID, callback: { resp in
            
            // remove activity indicator
            self.showActivityIndicator = false
            
            // check error
            if resp.error {
                print(resp.errorMessage)
                // handle error
            }else{
                // get songs
                var songQueue = resp.songs!
                
                // pull first song
                let currentSong = songQueue.remove(at: 0)
                
                // set current song
                self.hostMainViewController.currentSong = currentSong
                
                // set song list
                self.hostMainViewController.spotifySongListViewController.setSongs(songs: songQueue)
                
                // play song
                self.hostMainViewController.playPlaylist(playlistID: self.playlistID)
            }
        })
    }
    
    var body: some View {
        NavigationView() {
            ZStack{
                Color(UIColor(named: "background_main_dark")!)
                    .edgesIgnoringSafeArea(.all)
                
                GeometryReader { g in
                VStack{
                    //current song VStack
                    VStack {
                        if !self.hostMainViewController.currentSong.id.isEmpty {
                            // current song view
                            SpotifyHostCurrentSongView(hostMainViewController: self.hostMainViewController)
                        }
                        
                        // song progress bar
                        /*
                        HStack {
                            Text(self.hostMainViewController.songProgressString)
                            Group{
                                if self.hostMainViewController.songProgressMilliSeconds <= 0 {
                                    ProgressBar(progressPercent: 0.0)
                                }else{
                                    ProgressBar(progressPercent: CGFloat(self.hostMainViewController.songProgressMilliSeconds/self.hostMainViewController.currentSong.lengthMS))
                                }
                            }
                            Text(self.hostMainViewController.currentSong.stringLength)
                        }
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                        .frame(width: g.size.width, height: 8.0)
                        */
                    }
                    
                    // songs view
                    VStack{
                        // song table view
                        HostPlaylistSongTabView(spotifySongListViewController: self.hostMainViewController.spotifySongListViewController)
                    }
                }
                }
                
                // activity indicator
                if self.showActivityIndicator {
                    ActivityIndicator()
                }
                
            }
        
            // Navigation title
            .navigationBarTitle(Text(self.spotifyPlaylistData.name), displayMode: .inline)
                
                
            // Navigation button 1
            .navigationBarItems(leading:
                NavigationLink(destination: InfoView()){
                    HStack{
                       
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.white)
                        
                    }
                }.font(.custom("Helvetica-Bold", size: 24)),
                                trailing:
                NavigationLink(destination: InfoView()){
                    HStack{
                        
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.white)
                        
                    }
                }.font(.custom("Helvetica-Bold", size: 20))
            )
        }
        .onAppear(){
            // show activity
            self.showActivityIndicator = true
            
            // root view appears
            self.onViewStartup()
        }
    }
}

struct HostPlaylistRootView_Previews: PreviewProvider {
    @State static var playID: String = "3JuZ7JkllY2RfYL5ML1zLh"
    static var previews: some View {
        HostPlaylistRootView(playlistID: self.$playID).colorScheme(.dark)
    }
}
