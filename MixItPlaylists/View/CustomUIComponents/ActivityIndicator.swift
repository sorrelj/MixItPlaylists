//
//  ActivityIndicator.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 10/16/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: View {
    
    // MARK: Variables
    
    @State var spinAnim: Bool = false
    
    // MARK: VIEW
    
    var body: some View {
        // loading spinner image
        VStack{
            ZStack {
                Color(.white)
                .edgesIgnoringSafeArea(.all)
                
                
                Image(systemName: "rays")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .font(.custom("Helvetica-Bold", size: 20))
                    .rotationEffect(.degrees(spinAnim ? 360: 0))
                    .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false))
                    .foregroundColor(.black)
                    .onAppear(){
                        self.spinAnim = true
                    }
                    .onDisappear(){
                        self.spinAnim = false
                    }
                /*
                Text("Loading...")
                    .font(.custom("Helvetica-Bold", size: 16))
                    .foregroundColor(.black)
                */
            }
        }
        .frame(width: 128, height: 64)
        .cornerRadius(20)
        
        
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator()
    }
}
