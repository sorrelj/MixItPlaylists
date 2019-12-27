//
//  AppIconView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 9/29/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct AppIconView: View {
    var body: some View {
        Image("AppImage")
            .resizable()
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
            .aspectRatio(contentMode: .fit)
            .padding(.top, 20)
            .padding(.bottom, 20)
    }
}

struct AppIconView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconView()
    }
}
