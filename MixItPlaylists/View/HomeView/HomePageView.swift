//
//  HomePageView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 10/22/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct HomePageView: View {
    
    @Binding var rootView: RootViewTypes
    
   
    var body: some View {
        VStack{
            NavigationView() {
                ZStack{
                    Color(UIColor(named: "background_main_dark")!)
                        .edgesIgnoringSafeArea(.all)
                    
                    GeometryReader { g in
                    VStack{
                        // top half
                        VStack{
                            Text("Welcome Back!")
                                .bold()
                                .font(.custom("Helvetica", size: 40))
                                .padding(.top, 35)
                            
                            Spacer()
                            
                            // join and host playlist
                            HStack{
                                Spacer()
                                
                                NavigationLink(destination: CreatePlaylistView()) {
                                    Text("Create a Playlist")
                                        .font(.custom("Helvetica", size: 15))
                                        .padding(.top, 10)
                                        .padding(.bottom, 10)
                                        .padding(.leading, 24)
                                        .padding(.trailing, 24)
                                        .background(Color.pink)
                                        .foregroundColor(Color.white)
                                }
                                .cornerRadius(20)
                                
                                
                                Spacer()
                                
                                NavigationLink(destination: JoinPlaylistView()) {
                                    Text("Join a Playlist")
                                        .font(.custom("Helvetica", size: 15))
                                        .padding(.top, 10)
                                        .padding(.bottom, 10)
                                        .padding(.leading, 24)
                                        .padding(.trailing, 24)
                                        .background(Color.pink)
                                        .foregroundColor(Color.white)
                                }
                                .cornerRadius(20)
                                
                                Spacer()
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("My Playlists")
                                    .font(.custom("Helvetica-Bold", size: 25))
                                    .frame(width: g.size.width, alignment: .center)
                            }
                            
                        }.frame(width: g.size.width, height: g.size.height/3)
                        
                        // table view
                        VStack{
                            UserPlaylistsView()
                        }
                        .frame(maxWidth: g.size.width, maxHeight: 2*g.size.height/3)
                    }
                    }
                
                }
            
                .navigationBarTitle(Text(""), displayMode: .inline)
                    
                    
                // Navigation button 1
                .navigationBarItems(leading:
                    NavigationLink(destination: HomeInfoView(rootView: self.$rootView)){
                        HStack{
                           
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.white)
                            
                        }
                    }.font(.custom("Helvetica-Bold", size: 24)),
                                    trailing:
                    NavigationLink(destination: InfoView()){
                        HStack{
                            
                            Image(systemName: "person.3.fill")
                                .foregroundColor(.white)
                            
                        }
                    }.font(.custom("Helvetica-Bold", size: 20))
                )
                    

                
                
            }
        }
        
    }
}

struct HomePageView_Previews: PreviewProvider {
    @State static var root: RootViewTypes = .HOME
    static var previews: some View {
        HomePageView(rootView: $root).colorScheme(.dark)
    }
}
