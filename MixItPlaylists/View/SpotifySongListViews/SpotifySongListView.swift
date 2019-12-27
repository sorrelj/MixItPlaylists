//
//  SpotifySongListView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 12/19/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct SpotifySongListView: View {
    
    @ObservedObject var spotifySongs: SpotifySongListViewController
    
    var body: some View {
        ZStack {
            Color(UIColor(named: "background_main_dark")!)
                .edgesIgnoringSafeArea(.all)
            
            
        GeometryReader { g in
        Group{
            ScrollView(.vertical, showsIndicators: true) {
            VStack {
                
                ForEach(self.spotifySongs.songs){ song in
                    // image / title / artist
                    HStack(alignment: .center) {
                        // image
                        Image(uiImage: song.album.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:75, height:75)
                            .padding(.leading, 20)
                            
                        // title artist
                        VStack(alignment: .leading) {
                            Text(song.name)
                                .font(.custom("Helvetica", size: 16))
                                .lineLimit(1)
                                .padding(.bottom, 8)
                            Text(song.artist.name)
                                .padding(.leading,12)
                                .font(.custom("Helvetica", size: 12))
                        }
                        .foregroundColor(.white)
                        .padding(.leading,10)
                        .padding(.trailing, 20)
                        
                        Spacer()
                    }
                    
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                }
                .frame(width: g.size.width)
            }
            }
        }
        }
        }
    }
}

struct SpotifySongListView_Previews: PreviewProvider {
    @ObservedObject static var getSongs = SpotifySongListViewController()
    static var previews: some View {
        SpotifySongListView(spotifySongs: getSongs)
            .colorScheme(.dark)
            .onAppear(){
                getSongs.setSongs(songs: [SpotifySongModel(id: "abc", name: "Song Name", lengthMS: 1234, stringLength: "0:00", artistID: "123", artistName: "Artist Name...", albumID: "xyz", albumName: "Album Name...", albumImage: UIImage(systemName: "square.fill")!)])
        }
    }
}
