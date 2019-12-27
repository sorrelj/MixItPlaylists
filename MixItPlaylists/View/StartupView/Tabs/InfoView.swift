//
//  InfoView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 9/29/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct InfoView: View {
    
    private func websiteButtonAction() {
        
    }
    
    var body: some View {
        VStack (alignment: .center) {
            ZStack {
                Color(UIColor(named: "background_main_dark")!)
                    .edgesIgnoringSafeArea(.all)
                
                
        
                VStack{
                    
                    
                    // Main Titl
                    Text("Mix It Playlists")
                        .font(.custom("Helvetica-Bold", size: 40))
                        .foregroundColor(Color.white)
                        .padding(.top,20)
                    
                    Text("Mix It Playlists generates live collaborative playlists for everyday music enthusiasts in any environment. Using the Spotify platform, this application allows you to create custom playlists and invite others to request songs straight to your device in real time! This enables DJs to play music their listeners want to hear and allows personal users to discover new songs through the help of their friends. Mix It Playlists turns music social, as it should be progressing through the twenty-first century.")
                        .font(.custom("Helvetica", size: 16))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .frame(maxHeight: .infinity)
                    
                    Spacer()
                    
                    Button(action: self.websiteButtonAction){
                        Text("Check out our Website")
                            .font(.custom("Helvetica", size: 16))
                            .padding(.top, 8)
                            .padding(.bottom, 8)
                            .padding(.leading, 30)
                            .padding(.trailing, 30)
                            .foregroundColor(.white)
                            .background(Color.pink)
                    }
                    .cornerRadius(20)
                    .padding(.bottom, 20)
                    
                }
            }
        }
        
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
