//
//  HostPlaylistCurrentSongPlayerView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 12/29/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct HostPlaylistCurrentSongPlayerView: View {
    
    /// MARK: Controllers
    @ObservedObject var hostMainViewController: HostPlaylistViewController
    
    var body: some View {
        ZStack{
        Color(UIColor(named: "background_main_dark")!)
            .edgesIgnoringSafeArea(.all)
        
            GeometryReader { g in
            VStack{
                // song image
                Image(uiImage: self.hostMainViewController.getSpotifySongsViewController.currentSong.album.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: g.size.width, height: g.size.width)
                    .padding(.top, g.size.height/8)
                
                // song info
                VStack{
                    // song title
                    Text(self.hostMainViewController.getSpotifySongsViewController.currentSong.name)
                        .font(.custom("Helvetica-Bold", size: 25))
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    
                    // song Artist
                    Text(self.hostMainViewController.getSpotifySongsViewController.currentSong.artist.name)
                        .font(.custom("Helvetica", size: 18))
                        .padding(.top, 10)
                }
                .foregroundColor(.white)
                .padding(.top, 10)
                
                // song progress bar
                HStack {
                    // song progress string
                    Text(self.hostMainViewController.songProgressString)
                        .font(.custom("Helvetica", size: 18))
                        .foregroundColor(.white)
                    
                    // progress bar
                    ProgressBar(progressPercent: self.hostMainViewController.songProgressPercent)
                    
                    // total song length
                    Text(self.hostMainViewController.getSpotifySongsViewController.currentSong.stringLength)
                        .font(.custom("Helvetica", size: 18))
                        .foregroundColor(.white)
                }
                .padding(.top, 30)
                .frame(width: g.size.width, height: 8.0)
                
                // playback buttons
                HStack {
                    // prev button
                    Button(action: self.hostMainViewController.changePlaybackStatus) {
                        Image(systemName: "backward.fill")
                    }
                    
                    Spacer()
                    
                    // play / pause button
                    Button(action: self.hostMainViewController.changePlaybackStatus) {
                        Image(systemName: self.hostMainViewController.playbackStatus)
                    }
                    
                    Spacer()
                    
                    // next button
                    Button(action: self.hostMainViewController.nextSongAction) {
                        Image(systemName:"forward.fill")
                    }
                }
                .font(.custom("Helvetica", size: 30))
                .foregroundColor(.white)
                .padding(.top, 35)
                .frame(width: 2*g.size.width/3)
                                
                Spacer()
            }}
            .padding(.leading, 30)
            .padding(.trailing, 30)
            .onAppear(){
                self.hostMainViewController.startProgressTimer()
            }
            .onDisappear(){
                self.hostMainViewController.stopProgressTimer()
            }
        }
    }
}

struct HostPlaylistCurrentSongPlayerView_Previews: PreviewProvider {
    @ObservedObject static var host = HostPlaylistViewController()
    static var previews: some View {
        HostPlaylistCurrentSongPlayerView(hostMainViewController: host)
        .onAppear() {
            host.getSpotifySongsViewController.currentSong.album.image = UIImage(systemName: "circle.fill")!
            host.getSpotifySongsViewController.currentSong.name = "Test Song Name"
            host.getSpotifySongsViewController.currentSong.artist.name = "Test Song Artist"
        }
    }
}
