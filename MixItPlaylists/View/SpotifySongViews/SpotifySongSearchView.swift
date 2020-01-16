//
//  SpotifySongSearchView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 1/10/20.
//  Copyright © 2020 MixIt. All rights reserved.
//

import SwiftUI

struct SpotifySongSearchView: View {
    
    // MARK: State vars
    // search text
    @State private var searchText = ""
    
    // selected song to add
    @State private var selectedSong: SpotifySongModel = SpotifySongModel()
    
    // cancel button bool
    @State private var showCancelButton: Bool = false
    
    // show activity indicator
    @State private var showActivityIndicator: Bool = false
    
    // alert object
    @State private var alertObj: AlertObject = AlertObject()
    
    // show search alert
    @State private var showSearchAlert: Bool = false
    
    @State private var showAddSongAlert: Bool = false
    
    /// MARK: Controllers
    // search vc
    @ObservedObject private var songSearchViewController: SpotifySongSearchViewController = SpotifySongSearchViewController()

    // get song view controller
    @ObservedObject private var getSongsViewController: GetSpotifySongsViewController
    
    /// MARK: Private class vars
    private var isHost: Bool
    
    /// MARK: Functions
    init(isHost: Bool, getSongsViewController: GetSpotifySongsViewController){
        self.isHost = isHost
        self.getSongsViewController = getSongsViewController
    }
    
    // end keyboard editing
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    // search song
    private func searchSong() {
        // check if search q if empty
        if self.searchText.isEmpty {
            return
        }
        
        self.songSearchViewController.searchSong(search: self.searchText, callback: { resp in
            // show no results
        })
    }
    
    // show select song alert
    private func showSelectSong(song: SpotifySongModel){
        // set the song
        self.selectedSong = song
        
        // show add song alert
        self.alertObj = AlertObject(title: "Info", message: "Add \""+song.name+"\"to Song Queue?", button: "Add Song")
        self.showAddSongAlert = true
    }
    
    // add selected song
    private func addSelectedSong() {
        // send request to add or request song
        self.getSongsViewController.addOrRequestSong(isHost: self.isHost, song: self.selectedSong, callback: { resp in
            print(resp)
        })
    }
    
    var body: some View {
        ZStack{
            Color(UIColor(named: "background_main_dark")!)
                .edgesIgnoringSafeArea(.all)
            GeometryReader { g in
            VStack {
                // Search view
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")

                        TextField("Search Songs, Artists or Albums", text: self.$searchText, onEditingChanged: { isEditing in
                            self.showCancelButton = true
                        }, onCommit: {
                            self.searchSong()
                        })
                        .foregroundColor(.white)

                        Button(action: {
                            self.searchText = ""
                            self.songSearchViewController.searchedSongList = []
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(self.searchText == "" ? 0 : 1)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)

                    if self.showCancelButton  {
                        Button("Cancel") {
                            self.endEditing()
                            self.searchText = ""
                            self.showCancelButton = false
                            self.songSearchViewController.searchedSongList = []
                        }
                        .foregroundColor(Color(.systemBlue))
                    }
                }
                .padding(.horizontal)
                .alert(isPresented: self.$showSearchAlert) {
                    Alert(title: Text(self.alertObj.title), message: Text(self.alertObj.message), dismissButton: .default(Text(self.alertObj.button)))
                }
                
                // list of searched users
                ScrollView(.vertical, showsIndicators: true) {
                    ForEach(self.songSearchViewController.searchedSongList) { song in
                        // image / title / artist
                        Button(action: {self.showSelectSong(song: song)}){
                            HStack(alignment: .center) {
                                // image
                                Image(uiImage: song.album.image)
                                    .renderingMode(.original)
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
                .alert(isPresented: self.$showAddSongAlert){
                    Alert(title: Text(self.alertObj.title), message: Text(self.alertObj.message), primaryButton: .cancel(), secondaryButton: .default(Text(self.alertObj.button), action: {
                            self.addSelectedSong()
                    }))
                }
            }
            }
            
            if self.showActivityIndicator {
                ActivityIndicator()
            }
            
        }
    }
}

struct SpotifySongSearchView_Previews: PreviewProvider {
    @ObservedObject static var getSpotifySongsViewController = GetSpotifySongsViewController()
    static var previews: some View {
        SpotifySongSearchView(isHost: true, getSongsViewController: self.getSpotifySongsViewController)
    }
}



