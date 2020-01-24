//
//  SelectExistingPlaylistView.swift
//  MixItPlaylists
//
//  Created by Carson Grin on 1/23/20.
//  Copyright © 2020 MixIt. All rights reserved.
//

import SwiftUI

struct SelectExistingPlaylistView: View {
    
        // playlist title
       @Binding var playlistTitle: String
       // playlist description
       @Binding var playlistDescription: String
       // playlist image
       @Binding var playlistImage: UIImage?
    
       @ObservedObject var getExisting = SelectExistingPlaylistController()
    
    
    func onPlaylistButton(playlist: SpotifyPlaylistModel) {
        print(playlist)
        self.playlistTitle = playlist.name
        self.playlistDescription = playlist.description
        self.playlistImage = playlist.image
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                ForEach(self.getExisting.playlists) { playlist in
                    // navigation link
                    Button(action: {self.onPlaylistButton(playlist: playlist)}){
                        VStack {
                            Image(uiImage: playlist.image)
                                .resizable()
                                .frame(width: 150, height: 150)
                                .aspectRatio(contentMode: .fill)
                            
                            Text(playlist.name)
                            
                        }
                        .padding(.leading,10)
                        .padding(.trailing,10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                }
                .padding(.leading,10)
                .padding(.trailing,10)
            }
        }    }
}

//struct SelectExistingPlaylistView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectExistingPlaylistView()
//    }
//}