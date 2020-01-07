//
//  ConfirmStartPlaylistView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 1/3/20.
//  Copyright © 2020 MixIt. All rights reserved.
//

import SwiftUI

struct ConfirmStartPlaylistView: View {
    
    /// MARK: Binding vars
    // selected playlist to set
    @Binding var selectedPlaylist: MixItPlaylistModel
    
    // root view
    @Binding var rootView: RootViewTypes
    
    // playlist to display
    var playlist: MixItPlaylistModel
    
    /// MARK: Functions
    private func startPlaylistButtonAction(){
        // set selected playlist
        self.selectedPlaylist = playlist
        
        // change root view to host
        self.rootView = .HOST_PLAYLIST
    }
    
    
    var body: some View {
         ZStack{
            Color(UIColor(named: "background_main_dark")!)
                               .edgesIgnoringSafeArea(.all)
                           
            GeometryReader { g in
            VStack{
                Image(uiImage: self.playlist.spotifyData.image)
                    .resizable()
                    .frame(width: g.size.width, height: g.size.width)
                    .aspectRatio(contentMode: .fill)
                    
                    
                // playlist title / author / description
                VStack{
                    // playlist title
                    Text(self.playlist.spotifyData.name)
                        .font(.custom("Helvetica-Bold", size: 28))
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                    
                    // playlist Artist
                    Text("Created by: " + self.playlist.playlistCreator)
                        .font(.custom("Helvetica", size: 17))
                        .padding(.top, 10)
                    
                    // playlist description
                    if !self.playlist.spotifyData.description.isEmpty {
                        Text(self.playlist.spotifyData.description)
                            .font(.custom("Helvetica", size: 14))
                            .padding(.top, 25)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .lineLimit(3)
                            .multilineTextAlignment(.center)
                    }
                }
                .foregroundColor(.white)
                .padding(.top, 10)
                
                // Start Playing Button
                Button(action: self.startPlaylistButtonAction){
                    Text("Start Playing")
                        .font(.custom("Helvetica", size: 15))
                        .padding(.all, 8)
                        .frame(minWidth: 0, maxWidth: (g.size.width/3))
                        .background(Color.pink)
                        .foregroundColor(Color.white)
                }
                .cornerRadius(20)
                .padding(.top, 25)
                
            }
            }
            .padding(.leading, 30)
            .padding(.trailing, 30)
        }
    }
}

struct ConfirmStartPlaylistView_Previews: PreviewProvider {
    @State static var play: MixItPlaylistModel = MixItPlaylistModel()
    @State static var rootView: RootViewTypes = .HOME
    static var dispPlay: MixItPlaylistModel = MixItPlaylistModel()
    static var previews: some View {
        ConfirmStartPlaylistView(selectedPlaylist: $play, rootView: $rootView,playlist: dispPlay)
    }
}
