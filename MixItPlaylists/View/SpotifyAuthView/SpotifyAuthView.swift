//
//  SpotifyAuthView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/13/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct SpotifyAuthView: View {

    @Binding var isSpotifyAuthed: Bool
    
    // activity indicator
    @State private var showActivityIndicator: Bool = false
    
    // alert object
    @State private var alertObj: AlertObject = AlertObject()
    
    // show alert
    @State private var showSpotifyAlert: Bool = false
    
    /// MARK: Functions
    init(isSpotifyAuthed: Binding<Bool>) {

        self._isSpotifyAuthed = isSpotifyAuthed
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "spotifyConnected"), object: nil, queue: nil,
        using: self.onSpotifyAuth)
    }
    
    // notification reciever
    func onSpotifyAuth(_ notification: Notification) {
        // remove activity indicator
        self.showActivityIndicator = false
        
        // get status
        if let _ = notification.userInfo?["status"] as? String {
            // start spotify session
            self.isSpotifyAuthed = true
        }else if let error = notification.userInfo?["error"] as? String {
            print("SHOW ERROR - +++++ FIX THIS +++++")
            // show known error
            self.alertObj = AlertObject(title: "Alert", message: error, button: "Try Again")
            self.showSpotifyAlert = true
        }else{
            // show unknown error
            self.alertObj = AlertObject(title: "Alert", message: "An unknown error has occurred.", button: "Try Again")
            self.showSpotifyAlert = true
        }
        
    }
    
    private func loginSpotifyButtonAction() {
        let scene = UIApplication.shared.connectedScenes.first
        if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            // add loading symbol
            self.showActivityIndicator = true
            
            sd.connect()
        }
    }
    
    var body: some View {
        NavigationView {
        ZStack{
        Color(UIColor(named: "background_main_dark")!)
            .edgesIgnoringSafeArea(.all)
            
            // rows
            GeometryReader { g in
            VStack{
                VStack{
                    Text("Connect to Spotify")
                        .font(.custom("Helvetica-bold", size: 35))
                        .foregroundColor(Color.white)
                    Spacer()
                }
                .frame(width: g.size.width, height: g.size.height/4)
                
                
                VStack{
                    VStack {
                        Image("Spotify_icon_white")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                    }
                    .frame(width:g.size.width, height: g.size.height/4)
                    
                    VStack {
                        Button(action: self.loginSpotifyButtonAction) {
                            Text("Connect")
                                .font(.custom("Helvetica-bold", size: 18))
                                .padding(.all, 12)
                                .frame(minWidth: 0, maxWidth: (g.size.width/3))
                                .background(Color(UIColor(named: "Spotify_color_green")!))
                                .foregroundColor(Color.white)
                        }
                        .cornerRadius(20)
                        .padding(.top, 30)
                        .alert(isPresented: self.$showSpotifyAlert) {
                            Alert(title: Text(self.alertObj.title), message: Text(self.alertObj.message), dismissButton: .default(Text(self.alertObj.button)))
                        }
                        
                        Spacer()
                    }
                    .frame(width: g.size.width, height: g.size.height/4)
                    
                }
                
                VStack{
                    Spacer()
                    
                    NavigationLink(destination: SpotifyAuthHelpView()) {
                        Text("Need Help?")
                            .font(.custom("Helvetica", size: 16))
                    }
                    
                    Spacer()
                }
                .frame(width: g.size.width, height: g.size.height/4)
                
                .navigationBarTitle("", displayMode: .inline)
                .background(NavigationConfigurator { nc in
                    nc.navigationBar.setBackgroundImage(UIImage(),for: .default)
                    nc.navigationBar.shadowImage = UIImage()
                    nc.navigationBar.tintColor = .white
                })
                
            }
            }
            
            //loading view
            if self.showActivityIndicator {
                ActivityIndicator()
            }
        }

        }
        
        
            
    }
}

struct SpotifyAuthView_Previews: PreviewProvider {
    @State static var auth: Bool = false;
    static var previews: some View {
        SpotifyAuthView(isSpotifyAuthed: $auth).colorScheme(.dark)
        
    }
}
