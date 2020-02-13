//
//  HomePlaylistView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 12/31/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct HomePlaylistView: View {
    
    /// MARK: Binding vars
    
    // root view
    @Binding var rootView: RootViewTypes
    
    // controller
    @ObservedObject var getPlaylists: GetPlaylistViewController
    
    // selected playlist id
    @Binding var selectedPlaylist: MixItPlaylistModel
    
    var body: some View {
        VStack {
            VStack {
                Text("Friends' Playlists")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                    ForEach(self.getPlaylists.friendsPlaylists) { playlist in
                        // navigation link
                        NavigationLink(destination: ConfirmJoinPlaylistView(selectedPlaylist: self.$selectedPlaylist, rootView: self.$rootView, playlist: playlist)){
                            VStack {
                                Image(uiImage: playlist.spotifyData.image)
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .aspectRatio(contentMode: .fill)
                                
                                Text(playlist.spotifyData.name)
                                
                                Text(playlist.playlistCreator)
                            }
                            .padding(.leading,10)
                            .padding(.trailing,10)
                        }
                        .onTapGesture {
                            self.selectedPlaylist = playlist
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    }
                    .padding(.leading,10)
                    .padding(.trailing,10)
                }
            }
            
            VStack {
                Text("Public Playlists")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                    ForEach(self.getPlaylists.publicPlaylists) { playlist in
                        // navigation link
                        NavigationLink(destination: ConfirmJoinPlaylistView(selectedPlaylist: self.$selectedPlaylist, rootView: self.$rootView, playlist: playlist)){
                            VStack {
                                Image(uiImage: playlist.spotifyData.image)
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .aspectRatio(contentMode: .fill)
                                
                                Text(playlist.spotifyData.name)
                                
                                Text(playlist.playlistCreator)
                            }
                            .padding(.leading,10)
                            .padding(.trailing,10)
                        }
                        .onTapGesture {
                            self.selectedPlaylist = playlist
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    }
                    .padding(.leading,10)
                    .padding(.trailing,10)
                }
            }
        }
    }
}

struct HomePlaylistView_Previews: PreviewProvider {
    @State static var root: RootViewTypes = .HOME
    @ObservedObject static var playlist = GetPlaylistViewController(type: .MY_PLAYLISTS)
    @State static var play: MixItPlaylistModel = MixItPlaylistModel()
    static var previews: some View {
        HomePlaylistView(rootView: $root, getPlaylists: playlist, selectedPlaylist: $play)
    }
}

