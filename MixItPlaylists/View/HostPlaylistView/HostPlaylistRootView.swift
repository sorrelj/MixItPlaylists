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
    @Binding var playlist: MixItPlaylistModel
    
    // root view
    @Binding var rootView: RootViewTypes
    
    /// MARK: State variables
    // alert object
    @State private var alertObj: AlertObject = AlertObject()
    
    // show alert
    @State private var showHostAlert: Bool = false
    
    // go to home page
    @State private var goHome: Bool = false
    
    
    /// MARK: Controllers
    // Host playlist main view controller
    @ObservedObject var hostMainViewController = HostPlaylistViewController()
    
    // Get Spotify Playlist View Controller
    @ObservedObject var getSpotifyPlaylistViewController = GetSpotifyPlaylistViewController()
    
    // Get Spotify Songs View Controller
    @ObservedObject var getSpotifySongsViewController = GetSpotifySongsViewController()
    
    
    
    /// MARK: State vars
    
    // activity indicator
    @State var showActivityIndicator = true
    
    
    /// MARK: Private functions
    // on startup
    /*
    func onViewStartup() {
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
    */
    
    func onViewStartup(){
        // make sure spotify app is installed
        if !self.hostMainViewController.isSpotifyAppInstalled() {
            // remove activity indicator
            self.showActivityIndicator = false
            
            // show alert
            self.alertObj = AlertObject(title: "Alert", message: "The Spotify App must be installed to play music.", button: "OK")
            self.showHostAlert = true
            
            // set go to home page when alert is closed
            self.goHome = true
            
            return
        }
        
        // get playlist details
        if self.playlist.spotifyData.id.isEmpty {
            // get the data
            self.getSpotifyPlaylistViewController.getSingleSpotifyPlaylist(playlistID: self.playlist.id, callback: { resp in
                            
                // check for error
                if resp.error {
                    print(resp.errorMessage)
                    //display error
                }else{
                    DispatchQueue.main.async {
                        // set playlist data
                        self.hostMainViewController.spotifyPlaylistData = resp.playlistData!
                    }
                }
            })
        }else{
            // set the data
            self.hostMainViewController.spotifyPlaylistData = self.playlist.spotifyData
        }
        
        // get playlist tracks
        self.getSpotifySongsViewController.getSpotifyPlaylistSongs(playlistID: self.playlist.id, callback: { resp in
            
            // remove activity indicator
            self.showActivityIndicator = false
            
            // check error
            if resp.error {
                print(resp.errorMessage)
                // handle error
            }else{
                // get songs
                let songQueue = resp.songs!
                
                // set song list
                self.hostMainViewController.spotifySongListViewController.setSongs(songs: songQueue)
                
                // play song
                //self.hostMainViewController.playPlaylist(playlistID: self.playlist.id)
                self.hostMainViewController.connectAppRemote(playlistID: self.playlist.id)
            }
        })
    }
    
    
    // when the app remote is connected
    /*
    private func onAppRemoteConnected(_ notification: Notification){
        
        // get connection status
        guard let connected = notification.userInfo?["connected"] as? Bool else {
            print("GET APP REMOTE STATUS ERROR")
            return
        }
        
        guard connected == true else {
            print("APP REMOTE CONNECTION ERROR")
            return
        }
        
        // get the playlist details if needed
        if self.playlist.spotifyData.id.isEmpty {
            // get the data
            self.getSpotifyPlaylistViewController.getSingleSpotifyPlaylist(playlistID: self.playlist.id, callback: { resp in
                            
                // check for error
                if resp.error {
                    print(resp.errorMessage)
                    //display error
                }else{
                    DispatchQueue.main.async {
                        // set playlist data
                        self.hostMainViewController.spotifyPlaylistData = resp.playlistData!
                    }
                }
            })
        }else{
            // set the data
            self.hostMainViewController.spotifyPlaylistData = self.playlist.spotifyData
        }
        
        // get playlist tracks
        self.getSpotifySongsViewController.getSpotifyPlaylistSongs(playlistID: self.playlist.id, callback: { resp in
            
            // remove activity indicator
            self.showActivityIndicator = false
            
            // check error
            if resp.error {
                print(resp.errorMessage)
                // handle error
            }else{
                // get songs
                var songQueue = resp.songs!
                
                // set song list
                self.hostMainViewController.spotifySongListViewController.setSongs(songs: songQueue)
                
                // play song
                self.hostMainViewController.playPlaylist(playlistID: self.playlist.id)
            }
        })
    }
    */
    
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
                            NavigationLink(destination: HostPlaylistCurrentSongPlayerView(hostMainViewController: self.hostMainViewController)){
                                VStack{
                                    // current song view
                                    SpotifyHostCurrentSongView(hostMainViewController: self.hostMainViewController)
                                }
                            }
                            .frame(width: g.size.width)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    // songs view
                    VStack{
                        // song table view
                        HostPlaylistSongTabView(spotifySongListViewController: self.hostMainViewController.spotifySongListViewController)
                    }
                }
                .alert(isPresented: self.$showHostAlert){
                    Alert(title: Text(self.alertObj.title), message: Text(self.alertObj.message), dismissButton: .default(Text(self.alertObj.button), action: {
                        if self.goHome {
                            // root view home
                            self.rootView = .HOME
                        }
                    }))
                }
                }
                
                // activity indicator
                if self.showActivityIndicator {
                    ActivityIndicator()
                }
                
            }
        
            // Navigation title
            .navigationBarTitle(Text(self.hostMainViewController.spotifyPlaylistData.name), displayMode: .inline)
                
            // Navigation button 1
            .navigationBarItems(leading:
                NavigationLink(destination: InfoView()){
                    HStack{
                        Image(systemName: "info.circle.fill")
                    }
                }.font(.custom("Helvetica-Bold", size: 24)),
                                trailing:
                NavigationLink(destination: InfoView()){
                    HStack{
                        Image(systemName: "person.3.fill")
                    }
                }.font(.custom("Helvetica-Bold", size: 20))
            )
            
            .background(NavigationConfigurator { nc in
                nc.navigationBar.tintColor = .white
            })
        }
        .onAppear(){
            // root view appears
            self.onViewStartup()
        }
    }
}

struct HostPlaylistRootView_Previews: PreviewProvider {
    @State static var play: MixItPlaylistModel = MixItPlaylistModel()
    @State static var root: RootViewTypes = .HOST_PLAYLIST
    static var previews: some View {
        HostPlaylistRootView(playlist: self.$play, rootView: self.$root).colorScheme(.dark)
    }
}
