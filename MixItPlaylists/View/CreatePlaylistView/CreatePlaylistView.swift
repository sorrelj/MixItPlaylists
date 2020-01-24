//
//  CreatePlaylistView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 10/29/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct CreatePlaylistView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // playlist types
    private var playlistSelections: [String] = ["Public", "Friends Only"]
    
    // State vars
    
    // playlist title
    @State var playlistTitle: String = ""
    // playlist description
    @State var playlistDescription: String = ""
    // playlist image
    @State var playlistImage: UIImage? = UIImage()
    
    // select image
    @State var showSelectImage: Bool = false
    
    // select playlist type
    @State var playlistTypeSelection: Int = 0
    
    // activity indicator
    @State private var showActivityIndicator = false
    
    // show create alert
    @State private var showCreatePlaylistAlert = false
    // alert object
    @State private var alertObj: AlertObject = AlertObject()
    
    // controller
    @State private var createPlaylistController = CreatePlaylistViewController()
    
    
    /// MARK: Functions
    
    
    // upload image button
    private func uploadImageButtonAction() {
        self.showSelectImage = true
    }
    
    // create playlist button
    private func createPlaylistButtonAction() {
        
        if (self.playlistTitle == "") {
            // show error alert
            self.alertObj = AlertObject(title: "Alert", message: "Please enter a Playlist Name.", button: "OK")
            self.showCreatePlaylistAlert = true
            
        }else{
            // show activity ind
            self.showActivityIndicator = true
            
            self.createPlaylistController.createPlaylist(name: self.playlistTitle, description: self.playlistDescription, type: self.playlistSelections[self.playlistTypeSelection].lowercased(), image: self.playlistImage, callback: { resp in
                
                // remove activity indicator
                self.showActivityIndicator = false
                
                // success
                if resp.success {
                    self.alertObj = AlertObject(title: "Alert", message: resp.message, button: "Continue")
                    self.showCreatePlaylistAlert = true
                // error
                }else{
                    self.alertObj = AlertObject(title: "Alert", message: resp.message, button: "OK")
                    self.showCreatePlaylistAlert = true
                }
            })
        }
    }
    
    var body: some View {
       
        ZStack{
            Color(UIColor(named: "background_main_dark")!)
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { g in
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    
                    // title
                    VStack {
                        Text("Create a Playlist")
                            .font(.custom("Helvetica-Bold", size: 40))
                            .foregroundColor(Color.white)
                            .padding(.bottom, 15)
                        
                        // select existing playlist
                        NavigationLink(destination: SelectExistingPlaylistView(playlistTitle: self.$playlistTitle, playlistDescription: self.$playlistDescription, playlistImage: self.$playlistImage)) {
                            Text("Select existing Spotify playlist")
                                .font(.custom("Helvetica", size: 14))
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 35)
                    
                    
                    
                    // playlist name
                    VStack {
                        // title
                        HStack {
                            Text("Playlist name")
                                .font(.custom("Helvetica", size: 13))
                                .foregroundColor(Color.white)
                                .padding(.leading,5)
                                
                            Spacer()
                        }
                        
                        // text input
                        RoundedTextField(placeholder: "Name", stateBinding: self.$playlistTitle, secureTextField: false)
                        
                    }
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    
                    // playlist description
                    VStack{
                        // title
                        HStack {
                            Text("Playlist Description")
                                .font(.custom("Helvetica", size: 13))
                                .foregroundColor(Color.white)
                                .padding(.leading,5)
                                
                            Spacer()
                        }
                        
                        // text input
                        RoundedTextField(placeholder: "Description (Optional)", stateBinding: self.$playlistDescription, secureTextField: false)
                        
                        
                    }
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    
                    
                    // playlist image
                    VStack {
                        if self.playlistImage != nil && self.playlistImage != UIImage() {
                            VStack{
                                Image(uiImage: self.playlistImage ?? UIImage())
                                    .resizable()
                                    .padding(.leading, 25)
                                    .padding(.trailing, 25)
                                    .aspectRatio(contentMode: .fit)
                                    
                            }
                            .frame(maxWidth: g.size.width, maxHeight: .infinity)
                            .padding(.top, 20)
                        }else{
                            VStack{
                                Text("Playlist Image")
                            }
                            .frame(width: g.size.width/2, height: 200)
                            .border(Color(UIColor(named: "background_main_light")!))
                            .padding(.top,20)
                        }
                        
                        Button(action: self.uploadImageButtonAction) {
                            Group {
                                if self.playlistImage == UIImage() {
                                    Text("Add Image")
                                }else{
                                    Text("Change Image")
                                }
                            }
                            .font(.custom("Helvetica", size: 15))
                            .padding(.all, 8)
                            .frame(minWidth: 0, maxWidth: (g.size.width/3))
                            .background(Color.pink)
                            .foregroundColor(Color.white)
                        }
                        .sheet(isPresented: self.$showSelectImage, content: {
                            ImagePicker(image: self.$playlistImage)
                        })
                        .cornerRadius(20)
                        .padding(.top, 15)
                        .padding(.bottom,15)
                    }
                    
                    
                    // public or friends selection
                    VStack {
                        // title
                        HStack {
                            Text("Select Playlist Privacy")
                                .font(.custom("Helvetica", size: 13))
                                .foregroundColor(Color.white)
                                .padding(.leading,5)
                                
                            Spacer()
                        }
                        
                        
                        Picker("Select", selection: self.$playlistTypeSelection) {
                            ForEach(0 ..< self.playlistSelections.count) { index in
                                Text(self.playlistSelections[index])
                                    .tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding(.leading, 35)
                    .padding(.trailing, 35)
                    
                    
                    // playlist image
                    VStack{
                        Button(action: self.createPlaylistButtonAction) {
                            Text("Create")
                                .font(.custom("Helvetica", size: 15))
                                .padding(.all, 8)
                                .frame(minWidth: 0, maxWidth: (g.size.width/4))
                                .background(Color.pink)
                                .foregroundColor(Color.white)
                        }
                        .cornerRadius(20)
                        .padding(.top,15)
                    }
                    .padding(.bottom, 50)
                    //Create button alert
                    .alert(isPresented: self.$showCreatePlaylistAlert) {
                        Alert(title: Text(self.alertObj.title), message: Text(self.alertObj.message), dismissButton: .default(Text(self.alertObj.button),
                            action: {
                                print("GO TO NEXT SCREEN")
                            })
                        )
    
                    }
                                       
                    
                }
                
            }
            }
            //loading view
            if self.showActivityIndicator {
                ActivityIndicator()
            }
        }
    }
}

struct CreatePlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePlaylistView().colorScheme(.dark)
    }
}
