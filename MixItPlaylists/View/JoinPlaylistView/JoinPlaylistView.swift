//
//  JoinPlaylistView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 10/29/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct JoinPlaylistView: View {
    var body: some View {
        ZStack{
            Color(UIColor(named: "background_main_dark")!)
                .edgesIgnoringSafeArea(.all)
                       
            VStack {
                Text("Join Playlist")
            }
        }
    }
}

struct JoinPlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        JoinPlaylistView()
    }
}
