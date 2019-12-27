//
//  UserPlaylistsView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 10/29/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct UserPlaylistsView: View {
    @State var playlists: [APIRequest] = []
    
    var body: some View {
        
        VStack {
            List(0..<5){ item in
                VStack {
                    Text("")
                        .foregroundColor(.white)
                        .padding(.all, 20)
    
                    
                }
            }
        }
        
    }
}

struct UserPlaylistsView_Previews: PreviewProvider {
    static var previews: some View {
        UserPlaylistsView()
            .colorScheme(.dark)
    }
}
