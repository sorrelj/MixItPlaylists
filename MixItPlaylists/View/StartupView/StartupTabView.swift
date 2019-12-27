//
//  StartupTabView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 9/29/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI


struct StartupTabView: View {
    @Binding var rootViewType: RootViewTypes
    @Binding var isSpotifyAuthed: Bool
    
    @State private var currentTab: Int = 2
    
    @State private var loginUsername: String = ""
    @State private var loginPassword: String = ""
    
    @State private var phoneNumber: String = ""
    
    @State private var forgotPassword: Bool = false
    @State private var confirmAccount: Bool = false
   

    var body: some View {
        ZStack{
            Color(UIColor(named: "background_main_light")!)
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { g in
                VStack {
                    VStack{
                        AppIconView()
                    }.frame(width: g.size.width, height: g.size.height/3)
                    
                    VStack{
                        if (self.forgotPassword){
                            ForgotPasswordView(forgotPassword: self.$forgotPassword)
                        }else if (self.confirmAccount){
                            ConfirmCreateAccountMainView(confirmAccount: self.$confirmAccount, phoneNumber: self.$phoneNumber, isSpotifyAuthed: self.$isSpotifyAuthed, currentTab: self.$currentTab)
                        }else{
                            TabView (selection: self.$currentTab) {
                                InfoView()
                                    .tabItem {
                                        Image(systemName: "info.circle.fill")
                                        Text("About")
                                    }.tag(1)
                                LoginView(rootViewType: self.$rootViewType, username: self.$loginUsername, password: self.$loginPassword, confirmAccount: self.$confirmAccount, forgotPassword: self.$forgotPassword, phoneNumber: self.$phoneNumber)
                                    .tabItem {
                                        Image(systemName: "person.crop.circle.fill")
                                        Text("Login")
                                    }.tag(2)
                                SignupView(currentTab: self.$currentTab, loginUsername: self.$loginUsername, loginPassword: self.$loginPassword, confirmAccount: self.$confirmAccount, phoneNumber: self.$phoneNumber)
                                    .tabItem {
                                        Image(systemName: "person.crop.circle.fill.badge.plus")
                                        Text("Sign Up")
                                    }.tag(3)
                                
                            }
                        }
                    }
                    //.frame(width: g.size.width, height: (2 * (g.size.height/3)))
                
                }
            }
            
            
        }
        
    }
}

struct StartupTabView_Previews: PreviewProvider {
    @State static var page: RootViewTypes = .AUTH
    @State static var spot: Bool = false
    static var previews: some View {
        StartupTabView(rootViewType: $page, isSpotifyAuthed: $spot).colorScheme(.dark)
    }
}
