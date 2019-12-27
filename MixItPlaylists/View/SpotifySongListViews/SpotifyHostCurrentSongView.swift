//
//  SpotifyHostCurrentSongView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 12/19/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct SpotifyHostCurrentSongView: View {
    
    /// MARK: Binding vars
    
    // observed view controller
    @ObservedObject var hostMainViewController: HostPlaylistViewController
    
    
    var body: some View {
        // image / title / artist
        HStack(alignment: .top) {
            // image
            Image(uiImage: self.hostMainViewController.currentSong.album.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:128, height:128)
                
            // title artist
            VStack(alignment: .leading) {
                // song name
                Text(self.hostMainViewController.currentSong.name)
                    .font(.custom("Helvetica", size: 16))
                    .lineLimit(1)
                    .padding(.bottom, 8)
                
                // artist name
                Text(self.hostMainViewController.currentSong.artist.name)
                    .padding(.leading,12)
                    .font(.custom("Helvetica", size: 12))
                
                // play / pause button
                Button(action: self.hostMainViewController.changePlaybackStatus) {
                    Image(systemName: self.hostMainViewController.playbackStatus)
                        .font(.custom("Helvetica", size: 30))
                }
                .padding(.top, 10)
                .padding(.leading, 12)
                
            }
            .foregroundColor(.white)
            .padding(.leading,10)
            .padding(.top, 5)
            
            Spacer()
        }
        .padding(.all, 20)
    }
}

struct SpotifyHostCurrentSongView_Previews: PreviewProvider {
    @ObservedObject static var host = HostPlaylistViewController()

    static var previews: some View {
        SpotifyHostCurrentSongView(hostMainViewController: host)
        .onAppear() {
            host.currentSong = SpotifySongModel(id: "abc", name: "Song Name", lengthMS: 1234, stringLength: "0:00", artistID: "123", artistName: "Artist Name...", albumID: "xyz", albumName: "Album Name...", albumImage: UIImage(systemName: "square.fill")!)
        }
    }
}
