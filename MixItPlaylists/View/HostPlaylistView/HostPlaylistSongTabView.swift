//
//  HostPlaylistSongTabView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 12/18/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct HostPlaylistSongTabView: View {
    
    /// MARK: binding vars
    
    // playlist songs view controller
    @ObservedObject var getSpotifySongsViewController: GetSpotifySongsViewController
    
    
    /// MARK: State vars
    
    // tabview state vars 
    @State private var currentTab: Int = 2
    @State private var notificationNumberIcon: String = "0.circle.fill"
    
    
    var body: some View {
        TabView (selection: self.$currentTab) {
            InfoView()
                .tabItem {
                    Image(systemName: self.notificationNumberIcon)
                    Text("Song Requests")
                }.tag(1)
            SpotifySongListView(spotifySongListViewController: self.getSpotifySongsViewController.spotifySongListViewController)
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Playlist Queue")
                }.tag(2)
            SpotifySongSearchView(isHost: true, getSongsViewController: self.getSpotifySongsViewController)
                .tabItem {
                    Image(systemName: "magnifyingglass.circle.fill")
                    Text("Add Songs")
                }.tag(3)
            
        }
    }
}

struct HostPlaylistSongTabView_Previews: PreviewProvider {
    @ObservedObject static var playlistSongs = GetSpotifySongsViewController()
    static var previews: some View {
        HostPlaylistSongTabView(getSpotifySongsViewController: playlistSongs)
    }
}
