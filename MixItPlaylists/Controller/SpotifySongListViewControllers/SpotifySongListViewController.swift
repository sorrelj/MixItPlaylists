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
    func setSongs(songs: [SpotifySongModel]){
        self.songs = songs
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

