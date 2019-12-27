//
//  LaunchScreenView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/29/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
        Color(UIColor(named: "background_main_dark")!)
            .edgesIgnoringSafeArea(.all)
            
            GeometryReader { g in
            VStack {
                AppIconView()
                    .frame(width:g.size.width, height: g.size.height/5)
            }
            }
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
            .colorScheme(.dark)
    }
}
