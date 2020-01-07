//
//  HomePageView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 10/22/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct HomePageView: View {
    
    /// MARK: binding vars
    
    // root view
    @Binding var rootView: RootViewTypes
    
    // selected playlist ID
    @Binding var selectedPlaylist: MixItPlaylistModel
    
    /// MARK: Controllers
    // my playlists controller
    @ObservedObject var myPlaylistsController = GetPlaylistViewController(type: .MY_PLAYLISTS)
    
    // friends playlists controller
    @ObservedObject var friendPlaylistsController = GetPlaylistViewController(type: .FRIENDS_PLAYLISTS)
    
    // nearby playlists controller
    @ObservedObject var nearbyPlaylistsController = GetPlaylistViewController(type: .NEARBY_PLAYLISTS)
    
    
    /// MARK: View
    var body: some View {
        VStack{
            NavigationView() {
                ZStack{
                    Color(UIColor(named: "background_main_dark")!)
                        .edgesIgnoringSafeArea(.all)
                    
                    GeometryReader { g in
                    VStack{
                        // top half
                        VStack{
                            HomePlaylistView(playlistViewName: "My Playlists", rootView: self.$rootView, getPlaylists: self.myPlaylistsController, selectedPlaylist: self.$selectedPlaylist)
                        }
                        .frame(minWidth: g.size.width, maxHeight: g.size.height/3)
                        
                        VStack{
                            HomePlaylistView(playlistViewName: "My Friends' Playlists", rootView: self.$rootView, getPlaylists: self.friendPlaylistsController, selectedPlaylist: self.$selectedPlaylist)
                        }
                        .frame(minWidth: g.size.width, maxHeight: g.size.height/3)
                        
                        // join and host playlist
                        VStack {
                            HomePlaylistView(playlistViewName: "Nearby Playlists", rootView: self.$rootView, getPlaylists: self.nearbyPlaylistsController, selectedPlaylist: self.$selectedPlaylist)
                        }
                        .frame(minWidth: g.size.width, maxHeight: g.size.height/3)
                    }
                    }
                
                }
            
                .navigationBarTitle(Text(""), displayMode: .inline)
                    
                    
                // Navigation button 1
                .navigationBarItems(leading:
                    NavigationLink(destination: HomeInfoView(rootView: self.$rootView)){
                        HStack{
                           
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.white)
                            
                        }
                    }.font(.custom("Helvetica-Bold", size: 24)),
                                    trailing:
                    NavigationLink(destination: FriendsRootView()){
                        HStack{
                            
                            Image(systemName: "person.3.fill")
                                .foregroundColor(.white)
                            
                        }
                    }.font(.custom("Helvetica-Bold", size: 20))
                )
                
                .background(NavigationConfigurator { nc in
                    nc.navigationBar.tintColor = .white
                })
                
            }
        }
        
    }
}

struct HomePageView_Previews: PreviewProvider {
    @State static var root: RootViewTypes = .HOME
    @State static var play: MixItPlaylistModel = MixItPlaylistModel()
    static var previews: some View {
        HomePageView(rootView: $root, selectedPlaylist: $play).colorScheme(.dark)
    }
}
