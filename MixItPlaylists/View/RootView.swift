//
//  RootVIew.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 10/29/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct RootView: View {
    // root view
    @State var rootViewType: RootViewTypes = .LAUNCH
    
    // bool if spotify is connected
    @State var isSpotifyAuthed: Bool = false
    
    // playlist ID for host / joined
    @State var playlist: MixItPlaylistModel = MixItPlaylistModel()
    
    // keychain controller
    private var authController = StartupAuthViewController()
    
    var body: some View {
        Group {
            if self.isSpotifyAuthed || self.rootViewType == .AUTH || self.rootViewType == .LAUNCH {
                containedView()
            }else{
                SpotifyAuthView(isSpotifyAuthed: self.$isSpotifyAuthed)
            }
        }
        .onAppear{self.checkAuth()}
    }
    
    func containedView() -> AnyView {
        switch self.rootViewType {
            // launch view
            case .LAUNCH: return AnyView(LaunchScreenView())
            
            // login / register root view
            case .AUTH: return AnyView(StartupTabView(rootViewType:
                self.$rootViewType, isSpotifyAuthed: self.$isSpotifyAuthed ))
            
            // home root view
            case .HOME: return AnyView(HomePageView(rootView: self.$rootViewType, selectedPlaylist: self.$playlist))
            
            // host root view
            case .HOST_PLAYLIST: return AnyView(HostPlaylistRootView(playlist: self.$playlist))
        }
    }
    
    func checkAuth(){
        authController.authUser(callback: { authed in
            let delay = 1.2

            if (authed) {
                DispatchQueue.main.asyncAfter(deadline: .now()+delay, execute: {
                    self.rootViewType = .HOME
                })
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now()+delay, execute: {
                    self.rootViewType = .AUTH
                })
            }
        })
    }
    
    mutating func setRootView(view: RootViewTypes){
        self.rootViewType = view
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .colorScheme(.dark)
    }
}
