//
//  SpotifySongListViewController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 12/19/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation



/// MARK:  Spotify Song List View Controller
final class SpotifySongListViewController: ObservableObject {
    
    // song array
    @Published var songs: [SpotifySongModel] = []
    
    
    // set initial songs
    func setSongs(songs: [SpotifySongModel], position: Int){
        if self.songs.isEmpty {
            self.songs = songs
        }else{
            var tempSongs: [SpotifySongModel] = []
            if position != songs.count-1 {
                for i in (position+1)...songs.count-1 {
                    tempSongs.append(songs[i])
                }
            }
            if position != 0 {
                for i in 0...position-1 {
                    tempSongs.append(songs[i])
                }
            }
            self.songs = tempSongs
        }
    }
    
    // get and remove first song
    func getAndRemoveFirst() -> SpotifySongModel {
        return self.songs.remove(at: 0)
    }
    
    // add song to end
    func addSongToEnd(song: SpotifySongModel) {
        self.songs.append(song)
    }
    
}

