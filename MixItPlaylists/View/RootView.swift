//
//  RootVIew.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 10/29/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @State var rootViewType: RootViewTypes = .LAUNCH
    @State var isSpotifyAuthed: Bool = false
    
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

    //TEMP
    //@State var temp: String = "37i9dQZEVXbLRQDuF5jeBp"
    
    
    func containedView() -> AnyView {
        switch self.rootViewType {
            
            case .LAUNCH: return AnyView(LaunchScreenView())
            case .AUTH: return AnyView(StartupTabView(rootViewType: self.$rootViewType, isSpotifyAuthed: self.$isSpotifyAuthed ))
            case .HOME: return AnyView(HomePageView(rootView: self.$rootViewType))
            
            // TEMP
            //case .HOST_PLAYLIST: return AnyView(HostPlaylistRootView(playlistID: self.$temp))
           
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
